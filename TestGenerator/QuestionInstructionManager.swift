//
//  QuestionInstructionManager.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 23..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class QuestionInstructionManager {
    
    let io : ConsoleIO
    let editQueInstManager : EditQuestionInstructionManager
    
    init(_ io : ConsoleIO) {
        self.io = io
        self.editQueInstManager = EditQuestionInstructionManager(io: io)
    }
    
    func questionMenu(_ question : Question, instQuestion: InstQuestion, solvers : [Solver] = []) -> ([Solver], gonnaExit : Bool) {
        var solversRetrun = solvers
        
        io.writeMessage()
        io.writeMessage(to: .input, "\(question.key) 메뉴")
        let (instruction, _) = io.getSolve(io.getInput(io.getHelp(.InstSolve)))
        
        switch instruction {
            
        case .show:
            io.writeMessage(to: .notice, "문제의 모든 내용 출력(풀이이력포함)")
            show(question)
            
        case .showContent:
            io.writeMessage(to: .notice, "문제의 모든 내용 출력")
            showNotHistory(question)
            
            
        case .solve:
            var instQuestionForSolve : InstQuestion
            switch instQuestion {
            case .publish,.publishOriginal,.solve:
                instQuestionForSolve = .solve
            case .solveControversal:
                instQuestionForSolve = .solveControversal
            case .solveShuffled, .publishShuffled:
                instQuestionForSolve = .solveShuffled
            }
            
            let (solver, gonnaExit) = processingQuestion(
                question, instQuestion: instQuestionForSolve)
            
            if gonnaExit {
                return ([], true)// 문제를 풀다가 유저가 exit를 입력하면 그 곳에서 중단하고 결과도 저장하지 않도록 하는 매우 편리하고 중요한 구문
            }
            if solver != nil {
                question.solvers.append(solver!)
                solversRetrun.append(solver!)
            } else {
                // generator에 아무것도 없이 그냥 next
            }
        case .noteQuestion:
            _ = io.getInput("\(question.key)에 대한 노트입력")
            io.writeMessage(to: .error, "아직 구현되지 않은 기능")
            
        case .tagQuestion:
            if let newTag = writeTag(title : "\(question.key)") {
                if question.tags.contains(newTag) {
                    io.writeMessage(to: .alert, "\(newTag)는 이미 존재함")
                } else {
                    question.tags.insert(newTag)
                    io.writeMessage(to: .notice, "\(newTag) 추가완료")
                    question.test.testSubject.testCategory.testDatabase.refreshTags()
                    Solver(question, gonnaShuffle: false).publish(om: OutputManager(), type: .original, showTitle: false, showQuestion: false, showAnswer: false, showTags: true, showHistory: false)
                    _ = question.test.save()
                }
            } else {
                io.writeMessage(to: .error, "태그 입력되지 않음")
            }
            
        case .modifyQuestoin:
            let result = editQueInstManager.editQuestion(question, false)
            if  result.0 != nil {
                io.writeMessage(to: .notice, "\(question.key) 문제 수정완료")
                
                // 수정 끝날 때마다 저장을 실행합시다.
                _ = question.test.save()

            } else {
                io.writeMessage(to: .notice, "\(question.key) 문제 수정하지 않음")
            }
            
        case .next:
            return (solvers, false)
            
        case .nextWithSave:
            _ = question.test.save()
            return (solvers, false)
            
        case .exit:
            return (solvers, true)
        }
        return questionMenu(question, instQuestion : instQuestion, solvers : solversRetrun) // next 혹은 exit아니면 빠져나가지 못함
    }

    
    func processingQuestion(_ question : Question, instQuestion : InstQuestion) -> (Solver?, gonnaExit : Bool) {
        
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
        
        switch instQuestion {
            
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
        case .solveShuffled:
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
            
        }
        
        
        // 문제가 반전 불가능하고 명령이 반전가능한 문제만 풀겠다고 했을 때
        if !solver.isOXChangable && instQuestion == .solveControversal {
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
            
            // 함수화 필요? -> 뒤에 필요한 멸영이 아주 특징적인 것이라 함수화 불필요
            let input = io.getInput("continue[], edit[/] ?")
            if input == "/" {
                let generatorForOneQuestion = Generator()
                generatorForOneQuestion.solvers.append(solver)
//                editGenerator(generatorForOneQuestion)
                return (solver, false)
            }
            return (solver, false)
        }
        
        
        
        // 문제를 내용을 타입의 논리에 맞게 출력
        solver.publish(om: OutputManager(),
                       type: questionPublishType,
                       showTitle: showTitle, showQuestion: showQuestion, showAnswer: showAnswer, showTags: showTags,showHistory: showHistory,
                       showAttribute: showAttribute, showOrigSel: showOrigSel)
        
        
        /// publish 계열의 명령이면 여기서 반전된 문제는 출력해야되면 하고 아님 말고, 함수는 솔버 반환 퍼블리쉬 모드라 항상 gonnaExit는 false
        if !gonnaSolve {
            if instQuestion == .publish {
                
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
        solver.isRight = isRight
        solver.comment = io.getInput("주기할 내용")
        
        //다 됫으니 문제에 풀이이력 아카이브
        solver.question.solvers.append(solver)
        
        io.writeMessage(to: .notice, "\(solver.question.key) 문제 풀이이력 추가됨 - \(solver.date!.HHmmss)")
        
        solver.publish(om: OutputManager(),
                       type: .original,
                       showTitle: false, showQuestion: false, showAnswer: false, showTags: false,showHistory: true,
                       showAttribute: true, showOrigSel: false)
        _ = io.getInput("confirm[]")
        
        return (solver, false)
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
    
    func show(_ question : Question) {
        // solver가 셔플하든 말든 원래 값을 출력해야 할 것임
        Solver(question).publish(om: OutputManager(),
                                 type: .original,
                                 showTitle: true, showQuestion: true, showAnswer: true, showTags: false, showHistory: false,
                                 showAttribute: true, showOrigSel: true)
        
        io.writeMessage(to: .title, "[반전된 문제]")
        
        Solver(question).publish(om: OutputManager(),
                                 type: .originalNot,
                                 showTitle: true, showQuestion: true, showAnswer: true, showTags: true, showHistory: true,
                                 showAttribute: true, showOrigSel: true)
    }
    
    func showNotHistory(_ question : Question) {
        // solver가 셔플하든 말든 원래 값을 출력해야 할 것임
        Solver(question).publish(om: OutputManager(),
                                 type: .original,
                                 showTitle: true, showQuestion: true, showAnswer: true, showTags: false, showHistory: false,
                                 showAttribute: true, showOrigSel: true)
        
        io.writeMessage(to: .title, "[반전된 문제]")
        
        Solver(question).publish(om: OutputManager(),
                                 type: .originalNot,
                                 showTitle: true, showQuestion: true, showAnswer: true, showTags: true, showHistory: false,
                                 showAttribute: true, showOrigSel: true)
    }
    
    
    
    func writeTag(title : String) -> String? {
        
        let tag = io.getInput("\(title) 대한 태그 (다시입력 : \\)")
        
        if tag == "" {
            io.writeMessage(to: .notice, "입력한 태그없음")
            return nil
        } else if tag.characters.last == "\\" {
            return writeTag(title: title)
        }
        return tag
    }
}
