//
//  InstManagerMain.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 3. 22..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class InstManagerMain {
    
    let io = ConsoleIO()
    
    let testDatabase : TestDatabase
    let outputManager : OutputManager
    let storageManager : StorageManager
    // lazy var로 정의하는 방법은 업나? 현재는 self를 초기화에서 불러줘야 해서 안된다.
    let instManagerQuestionsGet : InstManagerQuestionsGet
    
    var input = ""
    
    init(testDatabase : TestDatabase, outputManager : OutputManager, storageManager : StorageManager) {
        self.testDatabase = testDatabase
        self.outputManager = outputManager
        self.storageManager = storageManager
        
        self.instManagerQuestionsGet = InstManagerQuestionsGet(testDatabase, io : self.io)
    }
    
    
    func didInitializationComplete() {
        
        var shouldExit = false
        
        while !shouldExit {

            let (instruction,value) = io.getInstMain(io.getInput())
            
            
            switch instruction {
                
            case .exit:
                shouldExit = true
                
                
            case .help:
                io.writeMessage(to: .notice, io.getHelp(.InstMain))
                
                
            case .keys:
                let (inst,value) = io.getQuestionsGet(io.getInput("\(testDatabase.key)의 시험카테고리 모두출력, "+io.getHelp(.InstQuestionsGet)))
                showKeys(inst, value : value)
                
            case .publish:
                let generatorUnwrapped = publishAndSolver(.publish)
                handleQuestionGenerator(generatorUnwrapped, instMain: instruction)  // 원래는 instQuestion이 전달되야 하나 여기서 변환하기 귀찮으므로 함수에서 변환하는 기능 내장
                
            case .publishOriginal:
                let generatorUnwrapped = publishAndSolver(.publishOriginal)
                handleQuestionGenerator(generatorUnwrapped, instMain: instruction)
            
            case .publishShuffled:
                let generatorUnwrapped = publishAndSolver(.publishShuffled)
                handleQuestionGenerator(generatorUnwrapped, instMain: instruction)
            
            case .solve:
                let generatorUnwrapped = publishAndSolver(.solve)
                handleSolverGenerator(generatorUnwrapped)
                
            case .solveShuffled:
                let generatorUnwrapped = publishAndSolver(.solveShuffled)
                handleSolverGenerator(generatorUnwrapped)
            
            case .solveControversal:
                let generatorUnwrapped = publishAndSolver(.solveControversal)
                handleSolverGenerator(generatorUnwrapped)
                
            case .solveIntensive:
                let generatorUnwrapped = publishAndSolver(.solveIntensive)
                handleSolverGenerator(generatorUnwrapped)
                
                
            case .save:
                let (inst,value) = io.getSave(io.getInput("저장할 형식을 선택, "+io.getHelp(.InstSave)))
                switch inst {
                    
                case .all:
                    for testCategory in testDatabase.categories {
                        for testSubject in testCategory.testSubjects {
                            for test in testSubject.tests {
                                saveTest(test)
                            }
                        }
                    }

                case .test:
                    let selectedTest = instManagerQuestionsGet.selectTest(instManagerQuestionsGet.selectTestSubject(instManagerQuestionsGet.selectTestCategory(testDatabase)))
                    saveTest(selectedTest)
                    
                case .unknown:
                    io.unkown(value)
                    
                }
                
                
            case .edit:
                io.unkown(value)
                
            case .refresh:
//                storageManager.refresh(io: io) // 구현실패 2017. 5. 20.
                io.unkown(value)
            
            case .unknown:
                _ = io.unkown(value, true)
            }
        }
    }
}


// Main 명령어용 함수들의 모임

extension InstManagerMain {
    
    func showKeys(_ instruction : InstQuestionsGet, value: String) {
        switch instruction {

        case .all:
            for testCategory in testDatabase.categories {
                io.writeMessage(to: .publish, " | " + testCategory.key)
                for testSubject in testCategory.testSubjects {
                    io.writeMessage(to: .publish, "  | " + testSubject.key)
                    for test in testSubject.tests {
                        io.writeMessage(to: .publish, "   | " + test.key)
                        for que in test.questions {
                            io.writeMessage(to: .publish, "    | " +  que.key)
                            for sel in que.lists {
                                io.writeMessage(to: .publish, "     | " + sel.key)
                            }
                            for sel in que.selections {
                                io.writeMessage(to: .publish, "     | " + sel.key)
                            }
                        }
                    }
                }
            }
        case .category:
            for testCategory in testDatabase.categories {
                io.writeMessage(to: .publish, " | " + testCategory.key)
            }
        case .subject:
            for testCategory in testDatabase.categories {
                io.writeMessage(to: .publish, " | " + testCategory.key)
                for testSubject in testCategory.testSubjects {
                    io.writeMessage(to: .publish, "  | " + testSubject.key)
                }
            }
        case .test:
            for testCategory in testDatabase.categories {
                io.writeMessage(to: .publish, " | " + testCategory.key)
                for testSubject in testCategory.testSubjects {
                    io.writeMessage(to: .publish, "  | " + testSubject.key)
                    for test in testSubject.tests {
                        io.writeMessage(to: .publish, "   | " + test.key)
                    }
                }
            }
        case .question:
            for testCategory in testDatabase.categories {
                io.writeMessage(to: .publish, " | " + testCategory.key)
                for testSubject in testCategory.testSubjects {
                    io.writeMessage(to: .publish, "  | " + testSubject.key)
                    for test in testSubject.tests {
                        io.writeMessage(to: .publish, "   | " + test.key)
                        for que in test.questions {
                            io.writeMessage(to: .publish, "    | " +  que.key)
                        }
                    }
                }
            }
        case .allwithTag, .categorywithTag, .questionwithTag, .subjectwithTag, .testwithTag:
            io.writeMessage(to: .error, "아직 구현되지 않은 기능")
            
        case .unknown:
            io.unkown(value)
            
        }
    }
    
    
    // 출력이 nil인 경우는 유저가 문제를 풀다가 e[x]it 커맨드를 해서 강제종료하려고 하는 경우
    func publishAndSolver(_ _instMainSub : _InstMainSub) -> Generator? {
        
        //// 1. 명령에 대한 개요를 출력하고 어느 범위의 문제를 처리할지를 결정
        var str = ""
//        var popUpQuestionMenu = false
        
        // 1-1. 명령의 제목 결정
        switch _instMainSub {
        case .publish, .publishOriginal, .publishShuffled:
            str = "출력"
//            popUpQuestionMenu = false
        case .solve, .solveControversal, .solveShuffled, .solveIntensive:
            str = "풀이"
//            popUpQuestionMenu = true
        }
        
        // 1-2. 범위를 받아내는 구문, questions array가 받아옴
        // 현재는 getQuestionsInKey만 존재하나 필요에 따라서 이부분은 다양하게 변주를 만들어 낼수 있을 것 (+), 추가 필요 2017. 5. 23.
        var questions = instManagerQuestionsGet.getQuestions(title : str+"할 문제의 범주를 선택")
        let counter = questions.count
        
        
        if counter == 0 {
            
            io.writeMessage(to: .error, "선택한 문제없음")
            
        } else if counter > 1 {
            
            // 1-3. 문제를 섞을지 유저에게 물어보고 실행
            let input = io.getInput("문제를 섞어서 진행 yes[.], no[] ? ")
            if input == "." {
                questions.shuffle()
            }
            
        }
        
        
        
        // 1-4. 문제를 하나하나 처리하는 구문, 결과는 generator가 solver를 통해 래핑함,
        // generator는 전체 진행해서 하나만 존재하며 레퍼런스로 계속이동
        
        // 최종 결과를 가질 객체
        let generator = Generator()
        
        
        // 유저가 선택한 질문 하나하나에 대하여 처리 실행
        for (index, que) in questions.enumerated() {
            
            // 제목
            io.writeMessage()
            io.writeMessage(to: .title, "[[ \(str) : \(index+1) / \(counter)]]")
            
            
            
            // processingQusetion
            
            // solver는 문제를 유저가 안풀면 nik gonnaExit는 유저가 루프를 나가고 싶은 것임
            let (solvers, gonnaExit) = InstManagerQuestion(que, io : io).questionMenu(_instMainSub)
            
            
            if gonnaExit {
                return nil // 문제를 풀다가 유저가 exit를 입력하면 그 곳에서 중단하고 결과도 저장하지 않도록 하는 매우 편리하고 중요한 구문
            }
            
            if solvers == [] {
                // dㅣ미 자동으로 processingQuestion에서 자동으로 추가하므로 여기서 다시 넣어두지는 않음? 2017. 5. 25.
                // generator.solvers.append(solver!)
            } else {
                generator.solvers.append(contentsOf: solvers)
                // generator에 아무것도 없이 그냥 next
            }
        }
        
        // generator에 섞은걸 다시 돌리는데, 꼭 필요한가?
        // generator.solvers.sort{$0.question.key < $1.question.key}
        
        return generator
    }
    
    
    func handleSolverGenerator(_ generator : Generator?) {
        if let generator = generator {
            let (r,_) = generator.seperateWorngSolve()
            io.writeMessage(to: .notice, "총 \(generator.solvers.count) 문제 중 \(r.count) 문제 맞춤")
            
            let tests = generator.getTestinSolvers()
            
            for test in tests {
                // 저장에 관한 메세지는 함수 내부에서 가지고 있음
                _ = test.save()
            }
            
        } else {
            io.writeMessage(to: .notice, "문제풀이 강제종료함")
        }
    }
    
    
    func handleQuestionGenerator(_ generatorUnwrapped : Generator?, instMain : InstMain) {
        
        guard let generator = generatorUnwrapped else {
            io.writeMessage(to: .error, "문제가 없음")
            return
        }
        if generator.solvers.count == 0 {
            io.writeMessage(to: .error, "문제가 없음")
            return
        }
        let input = io.getInput("exit[], edit[/], solve[\\] ? ")
        if input == "v" || input == "\\" {
            
            let questions = generator.getQustioninSovers()
            let generator = Generator()
            
            let queCounter = questions.count
            for (index,question) in questions.enumerated() {

                io.writeMessage()
                io.writeMessage(to: .title, "[[풀이 - \(index+1) / \(queCounter)]]")
                
                InstManagerQuestion(question, io : io).showNoHistory()
                InstManagerQuestion(question, io : io).showNotNoHistory()
                
                var _instMainSub : _InstMainSub
                switch instMain {
                case .publishShuffled :
                    _instMainSub = .solveShuffled
                default:
                    _instMainSub = .solve
                }

                let (solvers, gonnaExit) = InstManagerQuestion(question, io : io).questionMenu(_instMainSub)
                
                if  gonnaExit  {
                    io.writeMessage(to: .notice, "강제종료")
                    return
                }
                
                generator.solvers.append(contentsOf: solvers)
            }
            
            handleSolverGenerator(generator)
            
        } else if input == "/" || input == "e" {
            
            let questions = generator.getQustioninSovers()
            let generator = Generator()
            
            let queCounter = questions.count
            for (index,question) in questions.enumerated() {
                
                io.writeMessage()
                io.writeMessage(to: .title, "[[수정 - \(index+1) / \(queCounter)]]")
                
                // 수정모드에서는 이력은 안보여주는게 편리할 것임
                Solver(question).publish(om: OutputManager(), type: .original, showTitle: true, showQuestion: true, showAnswer: true, showTags: false, showHistory: false, showAttribute: true, showOrigSel: false)
                
                if instMain == .publishOriginal {
                    Solver(question).publish(om: OutputManager(), type: .original, showTitle: false, showQuestion: false, showAnswer: false, showTags: true, showHistory: false, showAttribute: false, showOrigSel: false)
                } else {
                    
                    io.writeMessage(to: .title, "[반전된 문제]")
                    Solver(question).publish(om: OutputManager(), type: .originalNot, showTitle: false, showQuestion: true, showAnswer: true, showTags: true, showHistory: false, showAttribute: true, showOrigSel: false)
                }
                
                
                let (solvers, gonnaExit) = InstManagerQuestion(question, io : io).questionMenu()
                
                if  gonnaExit  {
                    io.writeMessage(to: .notice, "강제종료")
                    return
                }
                
                generator.solvers.append(contentsOf: solvers)
            }
            
            for test in generator.getTestinSolvers() {
                _ = test.save() // 이 기능이 잘 작동 안하는 것으로 의심되니 나중에 확인해야 한다. (+) 2017. 5. 24.
            }
        }
    }
    
    
    func saveTest(_ selectedTest : Test?) {
        guard let selectedTestWrapped = selectedTest else {
            io.writeMessage(to: .error, "선택한 시험이 없어 시험저장 실패")
            return
        }
        
        if selectedTestWrapped.save() {
            return
        } else {
            return
        }
    }
    
}




// Does there exist within Swift's API an easy way to remove duplicate elements from an array?
// http://stackoverflow.com/questions/25738817/does-there-exist-within-swifts-api-an-easy-way-to-remove-duplicate-elements-fro
// 담에 공부하자 2017. 5. 21.
extension Array where Element:Hashable {
    var unique: [Element] {
        var set = Set<Element>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(value) {
                set.insert(value)
                arrayOrdered.append(value)
            }
        }
        
        return arrayOrdered
    }
}

