//
//  MainInstrctionManager.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 3. 22..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class MainInstructionManager {
    
    let io = ConsoleIO()
    
    let testDatabase : TestDatabase
    let outputManager : OutputManager
    let storageManager : StorageManager
    // lazy var로 정의하는 방법은 업나? 현재는 self를 초기화에서 불러줘야 해서 안된다.
    let questionInstManager : QuestionInstructionManager
    let getQuesInsManager : GetQuestoinsInstructionManager
    
    var input = ""
    
    init(testDatabase : TestDatabase, outputManager : OutputManager, storageManager : StorageManager) {
        self.testDatabase = testDatabase
        self.outputManager = outputManager
        self.storageManager = storageManager
        self.questionInstManager = QuestionInstructionManager(self.io)
        self.getQuesInsManager = GetQuestoinsInstructionManager(testDatabase: testDatabase, io : self.io)
    }
    
    
    func didInitializationComplete() {
        
        var shouldExit = false
        
        while !shouldExit {

            let (instruction,value) = io.getIntstruction(io.getInput())
            
            
            switch instruction {
                
            case .exit:
                shouldExit = true
                
                
            case .help:
                io.writeMessage(to: .notice, io.getHelp(.InstMain))
                
                
            case .keys:
                let (inst,value) = io.getPublish(io.getInput("\(testDatabase.key)의 시험카테고리 모두출력, "+io.getHelp(.InstPublish)))
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
                    let selectedTest = getQuesInsManager.selectTest(getQuesInsManager.selectTestSubject(getQuesInsManager.selectTestCategory(testDatabase)))
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

extension MainInstructionManager {
    
    func showKeys(_ instruction : InstPublish, value: String) {
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
        case .unknown:
            io.unkown(value)
        }
    }
    
    
    // 출력이 nil인 경우는 유저가 문제를 풀다가 e[x]it 커맨드를 해서 강제종료하려고 하는 경우
    func publishAndSolver(_ instQuestion : InstQuestion) -> Generator? {
        
        //// 1. 명령에 대한 개요를 출력하고 어느 범위의 문제를 처리할지를 결정
        var str = ""
        var popUpQuestionMenu = false
        
        // 1-1. 명령의 제목 결정
        switch instQuestion {
        case .publish, .publishOriginal, .publishShuffled:
            str = "출력"
            popUpQuestionMenu = false
        case .solve, .solveControversal, .solveShuffled:
            str = "풀이"
            popUpQuestionMenu = true
        }
        
        // 1-2. 범위를 받아내는 구문, questions array가 받아옴
        // 현재는 getQuestionsInKey만 존재하나 필요에 따라서 이부분은 다양하게 변주를 만들어 낼수 있을 것 (+), 추가 필요 2017. 5. 23.
        var questions = getQuesInsManager.getQuestionsInKey(title : str+"할 문제의 범주를 선택")
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
            let (solver, gonnaExit) = questionInstManager.processingQuestion(
                que, instQuestion: instQuestion)
            
            if gonnaExit {
                return nil // 문제를 풀다가 유저가 exit를 입력하면 그 곳에서 중단하고 결과도 저장하지 않도록 하는 매우 편리하고 중요한 구문
            }
            
            if solver != nil {
                generator.solvers.append(solver!)
            } else {
                // generator에 아무것도 없이 그냥 next
            }
            
            // solve 모드에서만 띄어줌
            if popUpQuestionMenu {
                
                let (solvers, gonnaExitExit) = questionInstManager.questionMenu(que, instQuestion: instQuestion)
                generator.solvers.append(contentsOf: solvers)
                
                if gonnaExitExit {
                    break // 문제를 풀다가 유저가 exit를 입력하면 그 곳에서 중단하고 결과도 저장하지 않도록 하는 매우 편리하고 중요한 구문
                }
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
        let input = io.getInput("exit[], [e]dit ? ")
        if input == "e" || input == "ㄷ" {
            
            let questions = generator.getQustioninSovers()

            let queCounter = questions.count
            for (index,question) in questions.enumerated() {

                io.writeMessage()
                io.writeMessage(to: .title, "[[시험문제 수정 - \(index+1) / \(queCounter)]]")
                
                questionInstManager.showNotHistory(question)
                
                var instQuestion : InstQuestion
                switch instMain {
                case .publishShuffled :
                    instQuestion = .solveShuffled
                default:
                    instQuestion = .solve
                }

                let (_, gonnaExit) = questionInstManager.questionMenu(question, instQuestion: instQuestion)
                
                if  gonnaExit  {
                    io.writeMessage(to: .notice, "강제종료")
                }
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

