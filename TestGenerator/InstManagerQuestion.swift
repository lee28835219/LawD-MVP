//
//  InstManagerQuestion.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 23..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class InstManagerQuestion {
    
    
    let io : ConsoleIO
    let question : Question
    
    init(_ question : Question, io : ConsoleIO) {
        self.question = question
        self.io = io
    }
    
    func questionMenu(_ _instMainSubDefault : _InstMainSub? = nil) -> ([Solver], gonnaExit : Bool) {
        return _questionMenu(solvers: [], _instMainSubDefault : _instMainSubDefault)
    }
    
    private func _questionMenu(solvers: [Solver], _instMainSubDefault : _InstMainSub?) -> ([Solver], gonnaExit : Bool) {
        var solversRetrun = solvers
        var popUpMenu = true
        var intensiveMode = false
        
        io.writeMessage()
        // 향후 보기 좋게 수정 필요
        io.writeMessage(to: .input, "\(question.key) 문제메뉴")
        var instruction : InstQuestion
        
        if _instMainSubDefault == nil {
            (instruction, _) = io.getInstQuestion(io.getInput(io.getHelp(.InstQuestion)))
        } else {
            instruction = .solve
        }
        
        switch instruction {
            
        case .show:
            io.writeMessage(to: .notice, "문제의 모든 내용 출력(풀이이력포함)")
            show()
            showNot()
            
        case .showContent:
            io.writeMessage(to: .notice, "문제의 모든 내용 출력")
            showNoHistory()
            showNotNoHistory()
            
        case .solve:
            
            var _instMainSub : _InstMainSub
            if _instMainSubDefault != nil {
                _instMainSub = _instMainSubDefault!
                switch _instMainSub {
                case .solve, .solveControversal, .solveShuffled:
                    popUpMenu = true
                case .solveIntensive, .solveOX:
                    popUpMenu = true
                    intensiveMode = true
                case .publish, .publishOriginal, .publishShuffled:
                    popUpMenu = false
                }
            } else {
                let (instSolveType, _) = io.getInstSolveType(io.getInput(io.getHelp(.InstSolveType)))
                
                switch instSolveType {
                case .original:
                    _instMainSub = .solve
                case .shuffle :
                    _instMainSub = .solveShuffled
                case .controversal:
                    _instMainSub = .solveControversal
                default:
                    _instMainSub = .solveControversal // 기본적으로는 반대문제 풀기를 디폴트 세팅으로 둠 2017. 5. 28.
                }
            }
            
            if intensiveMode {
                for index in 0..<5 {
                    io.writeMessage(to: .title, "[[\(question.key) 집중풀이 모드 진행 중\(index+1)/5]]")
                    let (solver, gonnaExit) = processingQuestion(_instMainSub: _instMainSub)
                    
                    if gonnaExit {
                        return ([], true)// 문제를 풀다가 유저가 exit를 입력하면 그 곳에서 중단하고 결과도 저장하지 않도록 하는 매우 편리하고 중요한 구문
                    }
                    if solver != nil {
                        // question.solvers.append(solver!) // 문제 풀면서 넣어주고 있는데 여기서 다시 넣으면 안되므로 삭제 함 2017. 5. 27.
                        // io.writeMessage(to: .notice, "\(solver?.date?.yyyymmdd) 추가함")
                        solversRetrun.append(solver!)
                    } else {
                        // generator에 아무것도 없이 그냥 next
                    }
                }
            } else {
                let (solver, gonnaExit) = processingQuestion(_instMainSub: _instMainSub)
                if gonnaExit {
                    return ([], true)// 문제를 풀다가 유저가 exit를 입력하면 그 곳에서 중단하고 결과도 저장하지 않도록 하는 매우 편리하고 중요한 구문
                }
                if solver != nil {
                    // question.solvers.append(solver!) // 문제 풀면서 넣어주고 있는데 여기서 다시 넣으면 안되므로 삭제 함 2017. 5. 27.
                    // io.writeMessage(to: .notice, "\(solver?.date?.yyyymmdd) 추가함")
                    solversRetrun.append(solver!)
                } else {
                    // generator에 아무것도 없이 그냥 next
                }
            }
            
            
        case .noteQuestion:
            _ = io.getInput("\(question.key)에 대한 노트입력")
            io.writeMessage(to: .error, "아직 구현되지 않은 기능")
            
        case .tagQuestion:
            writeTag()
            
        case .edit:
            let result = InstManagerQuestionEdit(question, io : io).editQuestion()
            if  result.0 != nil {
                io.writeMessage(to: .notice, "\(question.key) 문제 수정완료")
                
                // 수정 끝날 때마다 저장을 실행합시다.
                _ = question.test.save()

            } else {
                io.writeMessage(to: .notice, "\(question.key) 문제 수정하지 않음")
            }
            
        case .save:
            _ = question.test.save()
            
        case .next:
            return (solversRetrun, false)
            
        case .nextWithSave:
            _ = question.test.save()
            return (solversRetrun, false)
            
        case .exit:
            return ([], true)
        }
        // 한번 _instMainSubDefault nil이 아닌 것으로 받아도 그 다음부터는 nil로 진행
        // popUpMenu를 체크해서 false이면 재귀함수 호출이 아닌 일반 리턴
        if popUpMenu {
            return _questionMenu(solvers : solversRetrun, _instMainSubDefault: nil) // next 혹은 exit아니면 빠져나가지 못함
        } else {
            return (solversRetrun, false)
        }
        
    }

    
    private func processingQuestion(_instMainSub : _InstMainSub) -> (Solver?, gonnaExit : Bool) {
        
        var solver : Solver
        var questionPublishType : QuestionPublishType
        
        var showTitle : Bool
        var showQuestion : Bool
        var showAnswer : Bool
        var showTags : Bool
        var showHistory : Bool
        var showAttribute : Bool
        var showOrigSel : Bool
        
        var gonnaSolve : Bool
        
        switch _instMainSub {
            
        // 수정안한 원래문제와 반전문제 다 출력, 단 오리지날 번호만 빼고
        case .publish:
            
            // 어떤 문제를 선택할지
            solver = Solver(question, gonnaShuffle: false)
            questionPublishType = .solver // solver의 문제와 원래문제가 동일해야 할것임
            
            // 문제를 최초에 어떻게 출력할지
            showTitle = true
            showQuestion = true
            showAnswer = true
            showTags = false
            showHistory = false // 뒤에 반전지문까지 출력한 뒤에 히스트로리와 태그를 출력할 거니 false
            showAttribute = true
            showOrigSel = false
            
            
            // 문제를 풀건지
            gonnaSolve = false
            
            
        // 수정안한 원래문제만 다 출력, 여기도 오리지날 번호 필요없음
        case .publishOriginal:
            solver = Solver(question, gonnaShuffle: false)
            questionPublishType = .solver // solver의 문제와 원래문제가 동일해야 할것임
            
            showTitle = true
            showQuestion = true
            showAnswer = true
            showTags = true
            showHistory = true
            showAttribute = true
            showOrigSel = false
            
            gonnaSolve = false
            
        // 수정한 문제를 출력, 오리지날 번호 필요함
        case .publishShuffled:
            solver = Solver(question, gonnaShuffle: true)
            questionPublishType = .solver
            
            showTitle = true
            showQuestion = true
            showAnswer = true
            showTags = true
            showHistory = true
            showAttribute = true
            showOrigSel = true
            
            gonnaSolve = false
            
            
        // 원래 문제를 품
        case .solve:
            solver = Solver(question, gonnaShuffle: false)
            questionPublishType = .solver // solver의 문제와 원래문제가 동일해야 할것임
            
            showTitle = true
            showQuestion = true
            showAnswer = false
            showTags = false
            showHistory = false
            showAttribute = false
            showOrigSel = false
            
            gonnaSolve = true
            
            
        // 수정한 문제를 품, 반전문제가 없으면 원래 문제를 품
        // 인텐시브 모드도 동일
        case .solveShuffled, .solveIntensive:
            solver = Solver(question, gonnaShuffle: true)
            questionPublishType = .solver
            
            showTitle = true
            showQuestion = true
            showAnswer = false
            showTags = false
            showHistory = false
            showAttribute = false
            showOrigSel = false
            
            gonnaSolve = true
            
        // 수정한 문제를 푸는데 반전문제가 없으면 문제를 출력하지 않음
        case .solveControversal:
            solver = Solver(question, gonnaShuffle: true)
            questionPublishType = .solver
            
            showTitle = true
            showQuestion = true
            showAnswer = false
            showTags = false
            showHistory = false
            showAttribute = false
            showOrigSel = false
            
            gonnaSolve = true
        
            
        case .solveOX:
            solver = Solver(question, gonnaShuffle: true)
            questionPublishType = .solver
            
            showTitle = true
            showQuestion = true
            showAnswer = false
            showTags = false
            showHistory = false
            showAttribute = false
            showOrigSel = false
            
            gonnaSolve = true
        }
    
    
        // 문제가 반전 불가능하고 명령이 반전가능한 문제만 풀겠다고 했을 때
        if !solver.isOXChangable && _instMainSub == .solveControversal {
            //원래의 문제와
            Solver(question).publish(om: OutputManager(),
                                     type: .original,
                                     showTitle: true, showQuestion: true, showAnswer: true, showTags: false, showHistory: false,
                                     showAttribute: true, showOrigSel: true)
            
            
            // 문제의 심각성을 보여주고
            io.writeMessage()
            io.writeMessage(to: .title, "[반전된 문제]")
            solver.publish(om: OutputManager(),
                           type: .originalNot,
                           showTitle: showTitle, showQuestion: true, showAnswer: true, showTags: true,showHistory: false,
                           showAttribute: true, showOrigSel: false)
            
            io.writeMessage(to: .error, "이 문제는 반전이 불가능한 상황")
            
            // 함수화 필요? -> 뒤에 필요한 멸영이 아주 특징적인 것이라 함수화 불필요,
            // 이게 왜 함수화?
            // _ = io.getInput("continue[]")
            return (solver, false)
        }
        
        
        
        // 문제를 내용을 타입의 논리에 맞게 출력
        solver.publish(om: OutputManager(),
                       type: questionPublishType,
                       showTitle: showTitle, showQuestion: showQuestion, showAnswer: showAnswer, showTags: showTags,showHistory: showHistory,
                       showAttribute: showAttribute, showOrigSel: showOrigSel)
        
        
        /// publish 계열의 명령이면 여기서 반전된 문제는 출력해야되면 하고 아님 말고, 함수는 솔버 반환 퍼블리쉬 모드라 항상 gonnaExit는 false
        if !gonnaSolve {
            if _instMainSub == .publish {
                
                io.writeMessage(to: .title, "[반전된 문제]")
                solver.publish(om: OutputManager(),
                               type: .originalNot,
                               showTitle: false, showQuestion: true, showAnswer: true, showTags: true,showHistory: true, // 히스토리는 여기서 보여줌
                    showAttribute: true, showOrigSel: false)
            }
            return (solver, false)
        } else {
            return solveQuestion(solver)
        }
    }
    
        
    // private?
    func solveQuestion(_ solver : Solver) -> (Solver?, gonnaExit : Bool) {
        // gonnaSolve == true, 즉 solve 계열 명령은 여기서 문제풀이 시작
        
        //// 문제를 푸는 매우 중요한 구문 시작
        let solveStart = Date()
        
        // userAnswer가 nil이면 문제 안풀고 넘긴 것임
        let (userAnswer, isExit) = _getUserAnswer(maxSelectionNumber : solver.selections.count)
        
        guard userAnswer != nil  else {
            io.writeMessage(to: .notice, "\(solver.question.key) 문제 풀지않고 넘김")
            
            // 만약 문제도 안풀었는데 종료하겠다면 isExit는 true로 반환될 것임
            // 문제 안풀거니 solver를 닐로 반환
            return (nil, isExit)
        }
        var isRight = false
        io.writeMessage()
        if userAnswer == solver.getAnswerNumber() {
            io.writeMessage(to: .notice, "정답!!!!!!!!")
            solver.publish(om: OutputManager(),
                           type: .solver,
                           showTitle: false, showQuestion: false, showAnswer: true, showTags: true,showHistory: false,
                           showAttribute: true, showOrigSel: false)
            isRight = true
        } else {
            io.writeMessage(to: .alert, "  <오답> ...다시 공부해야 함")
            let statement = solver.selections[userAnswer!-1].content
            let ox = solver.selections[userAnswer!-1].getOX()
            io.writeMessage(to: .alert, "    " + userAnswer!.roundInt + "  " + (statement + " " + ox).spacing(5))
            solver.publish(om: OutputManager(),
                           type: .solver,
                           showTitle: false, showQuestion: false, showAnswer: true, showTags: true,showHistory: false,
                           showAttribute: true, showOrigSel: false)
            
            
            isRight = false
        }
        solver.date = Date()
        solver.duration = solver.date?.timeIntervalSince(solveStart)
        solver.isRight = isRight
        
        io.writeMessage(to: .notice, "문제 풀이 시간 : \(String(format: "%.1f", solver.duration!))초")
        
        // solver를 던져주면 comment를 알아서 체워옴, 즉 리턴 없음
        _getSolverComment(solver)
        
        
        return (solver, false)
    }
    
    
    func tagEditMode() -> Bool {
        var gonnaExit = false
        
        InstManagerQuestion(question, io : io).writeTag()
        
        Solver(question).publish(om: OutputManager(), type: .original, showTitle: false, showQuestion: false, showAnswer: false, showTags: true, showHistory: false)
        
        
        let inputInTagEdit = io.getInput("show[=], reEdit[/], next[] ,exit[~]")
        
        if inputInTagEdit == "~" {
            gonnaExit = true
        } else if inputInTagEdit == "=" {
            Solver(question).publish(om: OutputManager(), type: .original, showTitle: true, showQuestion: true, showAnswer: true, showTags: true, showHistory: false)
            return tagEditMode()
        } else if inputInTagEdit == "/" {
            return tagEditMode()
        }
        
        return gonnaExit
    }

    
    
    func _getSolverComment(_ solver : Solver) {
        solver.comment = io.getInput("주기할 내용")
        
        solver.question.solvers.append(solver)
        
        solver.publish(om: OutputManager(),
                       type: .original,
                       showTitle: false, showQuestion: false, showAnswer: false, showTags: false,showHistory: true,
                       showAttribute: true, showOrigSel: false)
        let confirm = io.getInput("confirm[], rewrite[\\]")
        
        if confirm.last == "\\" {
            
            solver.question.solvers.remove(at: solver.question.solvers.count-1)
            return _getSolverComment(solver)
            
        } else {
            
            //다 됫으니 문제에 풀이이력 완료
            io.writeMessage(to: .notice, "\(solver.question.key) 문제 풀이이력 추가됨 - \(solver.date!.HHmmss)")
            
        }
    }

    
    
    // processingQuestion에서 유저의 질문을 받아오는 보조함수
    func _getUserAnswer(maxSelectionNumber : Int) -> (Int?, isExit : Bool) {
        
        let userAnswerString = io.getInput("정답을 입력하세요, skip[], exit[~]")
        if userAnswerString == "" {
            return (nil, false)
        } else if userAnswerString == "~" {
            return (nil, true)
        }
        
        let userAnswerUnwrapped = Int(userAnswerString)
        
        // 입력이 숫자인지 확인
        guard let userAnswer = userAnswerUnwrapped else {
            io.writeMessage(to: .error, "숫자입력이 필요함")
            return _getUserAnswer(maxSelectionNumber : maxSelectionNumber)
        }
        
        
        
        // 입력숫자가 선택지 범위인지 확인
        if userAnswer < 1 || maxSelectionNumber < userAnswer {
            io.writeMessage(to: .error, "선택지 범위를 벗어난 숫자")
            return _getUserAnswer(maxSelectionNumber : maxSelectionNumber)
        }
        
        return (userAnswer, true)
    }
    
    func show() {
        // solver가 셔플하든 말든 원래 값을 출력해야 할 것임
        Solver(question).publish(om: OutputManager(),
                                 type: .original,
                                 showTitle: true, showQuestion: true, showAnswer: true, showTags: false, showHistory: false,
                                 showAttribute: true, showOrigSel: true)
    }
    
    func showNot() {
    
        io.writeMessage(to: .title, "[반전된 문제]")
        
        Solver(question).publish(om: OutputManager(),
                                 type: .originalNot,
                                 showTitle: true, showQuestion: true, showAnswer: true, showTags: true, showHistory: true,
                                 showAttribute: true, showOrigSel: true)
    }
    
    func showNoHistory() {
        // solver가 셔플하든 말든 원래 값을 출력해야 할 것임
        Solver(question).publish(om: OutputManager(),
                                 type: .original,
                                 showTitle: true, showQuestion: true, showAnswer: true, showTags: false, showHistory: false,
                                 showAttribute: true, showOrigSel: true)
    }
    
    func showNotNoHistory() {
        io.writeMessage(to: .title, "[반전된 문제]")
        
        Solver(question).publish(om: OutputManager(),
                                 type: .originalNot,
                                 showTitle: true, showQuestion: true, showAnswer: true, showTags: true, showHistory: false,
                                 showAttribute: true, showOrigSel: true)
    }
    
    func writeTag() {
        
        if let newTag = _getTag(title : "\(question.key)") {
            if question.tags.contains(newTag) {
                io.writeMessage(to: .alert, "\(newTag)는 이미 존재함")
            } else {
                question.tags.insert(newTag)
                // _ = question.test.save()
                io.writeMessage(to: .notice, "\(newTag) 추가완료")
                
                // 아래 전체 db 태그 리프레시에 시간이 너무 많이 걸려서 일단 커멘트 아웃한다. 퍼포먼스 높일 방법을 찾아서 다시 추가해야할 쭝요한 구문이다. 
                // 2017. 5. 28. (+)
                // question.test.testSubject.testCategory.testDatabase.refreshTags()
                
                Solver(question, gonnaShuffle: false).publish(om: OutputManager(), type: .original, showTitle: false, showQuestion: false, showAnswer: false, showTags: true, showHistory: false)
                return writeTag()
            }
        } else {
            io.writeMessage(to: .notice, "태그 입력되지 않음")
        }
    }
    
    func _getTag(title : String) -> String? {
        
        let tag = io.getInput("새로운 태그, stop[], rewite[\\], edit tag[/])")
        
        if tag == "" {
            io.writeMessage(to: .notice, "입력한 태그없음")
            return nil
        } else if tag.last == "\\" {
            return _getTag(title: title)
        } else if tag.last == "/" {
            InstManagerQuestionEdit(question, io : io).editTags()
            return _getTag(title: title)
        }
        return tag
    }
}

