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
    
    var input = ""
    
    
    
    init(testDatabase : TestDatabase, outputManager : OutputManager, storageManager : StorageManager) {
        self.testDatabase = testDatabase
        self.outputManager = outputManager
        self.storageManager = storageManager
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
                handleQuestionGenerator(generatorUnwrapped)
                
            case .publishOriginal:
                let generatorUnwrapped = publishAndSolver(.publishOriginal)
                handleQuestionGenerator(generatorUnwrapped)
            
            case .publishShuffled:
                let generatorUnwrapped = publishAndSolver(.publishShuffled)
                handleQuestionGenerator(generatorUnwrapped)
            
            case .solve:
                let generatorUnwrapped = publishAndSolver(.solve)
                handleSolveGenerator(generatorUnwrapped)
                
            case .solveShuffled:
                let generatorUnwrapped = publishAndSolver(.solveShuffled)
                handleSolveGenerator(generatorUnwrapped)
            
            case .solveControversal:
                let generatorUnwrapped = publishAndSolver(.solveControversal)
                handleSolveGenerator(generatorUnwrapped)
                
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
                    let selectedTest = selectTest(selectTestSubject(selectTestCategory(testDatabase)))
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
    
    
    
    //// 내부보조함수
    
    
    
    //input이 0~ 정수로 입력받았는지 확인하는 로직 필요함 2017. 4. 26.(-)
    //노가다 및 Int(String)으로 완성 2017. 5. 6.
    // 함수로 엔켑슐레이션 2017. 5. 20.
    func checkNumberRange(max: Int?, prefix: String) -> Int {
        let input = io.getInput(prefix)
        let number = Int(input)
        
        if number == nil {
            io.writeMessage(to: .error, "숫자를 입력하세요")
            return checkNumberRange(max: max, prefix: prefix)
        }
        
        if max != nil {
            if number! - 1 < 0 || number! - 1 >= max! {
                io.writeMessage(to: .error, "범위에 맞는 숫자를 입력하세요")
                return checkNumberRange(max: max, prefix: prefix)
            }
        } else {
            if number! - 1 < 0 {
                io.writeMessage(to: .error, "정확한 숫자를 입력하세요")
                return checkNumberRange(max: max, prefix: prefix)
            }
        }
        
        return number!
    }
    
    
    // 사용자로부터 입력을 받아서 데이터베이스 안의 시험명, 과목, 시험회차, 문제를 선택하는 함수
    // 대상이 하나도 없을 경우 nil반환
    func selectTestCategory(_ database : TestDatabase) -> TestCategory? {
        
        let categoryCount = testDatabase.categories.count
        
        if categoryCount == 0 {
            io.writeMessage(to: .error, "\(database.key)에 아무 데이터가 없음")
            return nil
        }
        
        // 선택할 시험을 출력
        for (index,testCategory) in database.categories.enumerated() {
            io.writeMessage(to: .notice, "[\(index+1)] : \(testCategory.key)")
        }
        
        // 시험명에 맞는 숫자를 선택
        let selectedCategoryIndex = checkNumberRange(max: categoryCount, prefix: "시험명 선택")
        
        return database.categories[selectedCategoryIndex-1]
    }
    
    func selectTestSubject(_ selectedCategoryUnwrapped : TestCategory?) -> TestSubject? {
        
        guard let selectedCategory = selectedCategoryUnwrapped else {
            return nil
        }
        
        let subjectCount = selectedCategory.testSubjects.count
        
        if subjectCount == 0 {
            io.writeMessage(to: .error, "\(selectedCategory.key)에 시험과목이 하나도 없음")
            return nil
        }
        
        for (index,test) in selectedCategory.testSubjects.enumerated() {
            io.writeMessage(to: .notice, "[\(index+1)] : \(test.key)")
        }
        
        let selectedSubjectIndex = checkNumberRange(max: subjectCount, prefix: "시험과목 선택")

        return selectedCategory.testSubjects[selectedSubjectIndex-1]
    }
    
    
    func selectTest(_ selectedSubjectUnwrapped : TestSubject?) -> Test? {
        
        guard let selectedSubject = selectedSubjectUnwrapped else {
            return nil
        }
        
        let testCount = selectedSubject.tests.count
        
        if testCount == 0 {
            io.writeMessage(to: .error, "\(selectedSubject.key)에 시험이 하나도 없음")
            return nil
        }
        
        for (index,test) in selectedSubject.tests.enumerated() {
            io.writeMessage(to: .notice, "[\(index+1)] : \(test.key)")
        }
        
        
        let selectedTest = checkNumberRange(max: testCount, prefix: "시험회차 선택")
        
        return selectedSubject.tests[selectedTest-1]
    }
    
    
    func selectQuestion(_ selectedTestUnwrapped: Test?) -> Question? {
        
        guard let selectedTest = selectedTestUnwrapped else {
            return nil
        }
        
        var selectedQuestions = selectedTest.questions
        if selectedQuestions.count == 0 {
            io.writeMessage(to: .error, "\(selectedTest.key)에 문제가 하나도 없음")
            return nil
        }
        
        for question in selectedQuestions {
            io.writeMessage(to: .notice, "[\(question.number)] : \(question.key)")
        }
        
        
        let selectedQuestionNumber = checkNumberRange(max: nil, prefix: "문제번호 선택")
        
        
        // 문제의 경우 문제번호를 정확하게 선택해야 하므로 어레이의 필터를 확인해서 체크함
        selectedQuestions = selectedQuestions.filter({$0.number == selectedQuestionNumber})
        if selectedQuestions.isEmpty {
            io.writeMessage(to: .error, "정확한 숫자를 입력하세요")
            return selectQuestion(selectedTestUnwrapped)
        }
        
        return selectedQuestions[0]
    }
    
    
    
    func selectList(_ questionUnwapped : Question?, showNot : Bool = true) -> List? {
        guard let question = questionUnwapped else {
            print("> 목록지를 찾을 수 없음")
            return nil
        }
        
        var lists = question.lists
        if lists.count == 0 {
            print("> \(question.key)에 목록지가 하나도 없음")
            return nil
        }
        
        for (index,list) in lists.enumerated() {
            var selString = ""
            if showNot {
                selString = list.notContent != nil ? list.notContent! : "없음"
            } else {
                selString = list.content
            }
            print(" [\(index+1)] : \(list.getListString()). \(selString)")
        }
        
        
        var goon = true
        while goon {
            print("목록지 번호 선택 $ ", terminator : "")
            let input = readLine()
            
            guard let inputWrapped = input else {
                print("올바르지 않은 입력, 재입력하세요.")
                continue
            }
            
            let listNumber = Int(inputWrapped)
            if listNumber == nil {
                print("숫자를 입력하세요")
                continue
            }
            lists = lists.filter({$0.number == listNumber})
            if lists.isEmpty {
                print("숫자를 입력하세요")
                continue
            }
            goon = false
        }
        
        return lists[0]
    }
    
    func selectSelection(_ questionUnwapped : Question?, showNot : Bool = true) -> Selection? {
        guard let question = questionUnwapped else {
            print("> 선택지를 찾을 수 없음")
            return nil
        }
        
        var selections = question.selections
        if selections.count == 0 {
            print("> \(question.key)에 선택지가 하나도 없음")
            return nil
        }
        
        
        for selection in selections {
            var selString = ""
            if showNot {
                selString = selection.notContent != nil ? selection.notContent! : "없음"
            } else {
                selString = selection.content
            }
            print(" \(selection.number.roundInt) \(selString)")
        }
        
        
        var goon = true
        while goon {
            print("목록지 번호 선택 $ ", terminator : "")
            let input = readLine()
            
            guard let inputWrapped = input else {
                print("올바르지 않은 입력, 재입력하세요.")
                continue
            }
            
            let number = Int(inputWrapped)
            if number == nil {
                print("숫자를 입력하세요")
                continue
            }
            selections = selections.filter({$0.number == number!})
            if selections.isEmpty {
                print("숫자를 입력하세요")
                continue
            }
            goon = false
        }
        
        return selections[0]
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
    func publishAndSolver(_ solveQuestionInstructionType : SolveQuestionInstructionType) -> Generator? {
        
        var str = ""
        var gonnaTestShuffling = false
        
        switch solveQuestionInstructionType {
        case .publish, .publishOriginal, .publishShuffled:
            str = "출력"
        case .solve, .solveControversal, .solveShuffled:
            let input = io.getInput("문제를 섞어서 진행 [y]es, no[] ? ")
            if input == "y" || input == "ㅛ" {
                gonnaTestShuffling = true
            }
            str = "풀이"
        }
        
        
        var questions = getQuestionsInKey(title : str+"할 문제의 범주를 선택")
        
        var generator = Generator()
        
        if gonnaTestShuffling {
            questions.shuffle()
        }
        let counter = questions.count
        for (index, que) in questions.enumerated() {
            
            io.writeMessage(to: .title, "[[ \(str) : \(index+1) / \(counter)]]")
            let (generatorResult, gonnaExit) = solveQuestion(que, generator: generator, solveQuestionInstructionType : solveQuestionInstructionType)
            generator = generatorResult
            
            // 문제를 풀다가 유저가 e[x]를 입력하면 그 곳에서 중단하고 결과도 저장하지 않도록 하는 매우 편리하고 중요한 구문
            if gonnaExit {
                return nil
            }
        }
        generator.solvers.sort{$0.question.key < $1.question.key}
        
        return generator
    }
    
    func getQuestionsInKey(title : String) -> [Question] {
        
        var questions = [Question]()
        
        let (instruction,value) = io.getPublish(io.getInput(title + io.getHelp(.InstPublish)))
        
        
        switch instruction {
        case .all:
            for testCategory in testDatabase.categories {
                for testSubject in testCategory.testSubjects {
                    for test in testSubject.tests {
                        for que in test.questions {
                            questions.append(que)
                        }
                    }
                }
            }
        case .category:
            guard let testCategory = selectTestCategory(testDatabase) else {
                io.writeMessage(to: .error, "시험명을 찾을 수 없음")
                return questions
            }
            for testSubject in testCategory.testSubjects {
                for test in testSubject.tests {
                    for que in test.questions {
                        questions.append(que)
                    }
                }
            }
        case .subject:
            guard let testCategory = selectTestCategory(testDatabase) else {
                io.writeMessage(to: .error, "시험명을 찾을 수 없음")
                return questions
            }
            guard let testSubject = selectTestSubject(testCategory) else {
                io.writeMessage(to: .error, "시험과목을 찾을 수 없음")
                return questions
            }
            for test in testSubject.tests {
                for que in test.questions {
                    questions.append(que)
                    
                }
            }
        case .test:
            guard let testCategory = selectTestCategory(testDatabase) else {
                io.writeMessage(to: .error, "시험명을 찾을 수 없음")
                return questions
            }
            guard let testSubject = selectTestSubject(testCategory) else {
                io.writeMessage(to: .error, "시험과목을 찾을 수 없음")
                return questions
            }
            guard let test = selectTest(testSubject) else {
                io.writeMessage(to: .error, "시험회차를 찾을 수 없음")
                return questions
            }
            for que in test.questions {
                questions.append(que)
                
            }
            
        case .question:
            guard let testCategory = selectTestCategory(testDatabase) else {
                io.writeMessage(to: .error, "시험명을 찾을 수 없음")
                return questions
            }
            guard let testSubject = selectTestSubject(testCategory) else {
                io.writeMessage(to: .error, "시험과목을 찾을 수 없음")
                return questions
            }
            guard let test = selectTest(testSubject) else {
                io.writeMessage(to: .error, "시험회차를 찾을 수 없음")
                return questions
            }
            guard let que = selectQuestion(test) else {
                io.writeMessage(to: .error, "문제를 찾을 수 없음")
                return questions
            }
            questions.append(que)
            
        case .unknown:
            io.unkown(value)
        }
        return questions
    }
    
    
    func solveQuestion(_ question : Question, generator: Generator, solveQuestionInstructionType : SolveQuestionInstructionType) -> (Generator, gonnaExit : Bool) {
        
        
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
        
        switch solveQuestionInstructionType {
            
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
        if !solver.isOXChangable && solveQuestionInstructionType == .solveControversal {
            
            // 문제의 심각성을 보여주고
            io.writeMessage()
            io.writeMessage(to: .title, "[반전된 문제]")
            solver.publish(om: outputManager,
                           type: .originalNot,
                           showTitle: showTitle, showQuestion: true, showAnswer: true, showTags: false,showHistory: false,
                           showAttribute: true, showOrigSel: false)
            
            io.writeMessage(to: .error, "이 문제는 반전이 불가능한 상황")
            
            // 함수화 필요? -> 뒤에 필요한 멸영이 아주 특징적인 것이라 함수화 불필요
            let input = io.getInput("continue[], [e]dit ?")
            if input == "e" || input == "ㄷ" {
                let generatorForOneQuestion = Generator()
                generatorForOneQuestion.solvers.append(solver)
                editGenerator(generatorForOneQuestion)
                return (generator, false)
            }
            return (generator, false)
        }
        
        
        
        // 문제를 내용을 타입의 논리에 맞게 출력
        solver.publish(om: outputManager,
                       type: questionPublishType,
                       showTitle: showTitle, showQuestion: showQuestion, showAnswer: showAnswer, showTags: showTags,showHistory: showHistory,
                       showAttribute: showAttribute, showOrigSel: showOrigSel)
        
        
        /// publish 계열의 명령이면 여기서 반전된 문제는 출력해야되면 하고 아님 말고, 제네레이터에 솔버 추가해서 반환함
        if !gonnaSolve {
            if solveQuestionInstructionType == .publish {
                
                io.writeMessage(to: .title, "[반전된 문제]")
                solver.publish(om: outputManager,
                               type: .originalNot,
                               showTitle: false, showQuestion: true, showAnswer: true, showTags: true,showHistory: true, // 히스토리는 여기서 보여줌
                               showAttribute: true, showOrigSel: false)
            }
            generator.solvers.append(solver)
            return (generator, false)
        }
        
        
        // solve 계열 명령은 여기서 문제풀이 시작
        
        // 문제를 푸는 매우 중요한 함수
        solve(solver)
        
        // 문제를 푼 결과를 처리하는 구문
        var goon = true
        while goon {
            
            io.writeMessage()
            io.writeMessage(to: .input, "\(question.key) 문제 풀이 : ")
            let (instruction, value) = io.getSolve(io.getInput(io.getHelp(.InstSolve)))
            
            switch instruction {
            
            case .resolve:
                generator.solvers.append(solver)
                return solveQuestion(question, generator: generator, solveQuestionInstructionType: solveQuestionInstructionType)
            
            case .noteQuestion:
                _ = io.getInput("\(question.key)에 대한 노트입력")
                io.writeMessage(to: .error, "아직 구현되지 않은 기능")
            
            case .tagQuestion:
                if let newTag = writeTag(title : "\(question.key)") {
                    question.tags.append(newTag)
                    
                    
                }
            
            case .modifyQuestoin:
                let generator = Generator()
                generator.solvers = [solver]
                editGenerator(generator)
                io.writeMessage(to: .notice, "\(question.key) 문제 수정완료")
            
            case .next:
                generator.solvers.append(solver)
                goon = false
            
            case .exit:
                generator.solvers = []
                return (generator, true)
            
            case .unknown:
                io.unkown(value)
                generator.solvers.append(solver)
                goon = false
            }
        }
        
        // 푼 문제에 대한 출력을 반환
        return (generator, false) // exit되지 않도록 반환을 잘 확인해야함
        
    }
    
    // 문제를 입력하면 변형하여 문제를 출력하고 입력을 받아서 정답을 체크하는 함수
    // 변경문제에 대하여 문제변경이 성공하면 진행하지만, 실패하면 false를 반환
    // 1. 노트추가나 태그추가, 2. 문제변경 기능에 대해서 만들어내도록 기능추가해야할 핵심함수 2017. 5. 7. (+)
    func solve(_ solver : Solver) {
        
        let userAnswerString = io.getInput("정답을 입력하세요, skip[]")
        if userAnswerString == "" {
            io.writeMessage(to: .notice, "\(solver.question.key) 문제 풀지않고 넘김")
            return
        }
        let userAnswerUnwrapped = Int(userAnswerString)
        
        // 입력이 숫자인지 확인
        guard let userAnswer = userAnswerUnwrapped else {
            io.writeMessage(to: .error, "숫자입력이 필요함")
            solve(solver)
            return
        }
        
        // 입력숫자가 선택지 범위인지 확인
        if userAnswer < 1 || solver.selections.count < userAnswer {
            io.writeMessage(to: .error, "선택지 범위를 벗어난 숫자")
            solve(solver)
            return
        }
        
        io.writeMessage("")
        
        if solver.selections[userAnswer-1] === solver.answerSelectionModifed {
            io.writeMessage(to: .notice, "정답!!!!!!!!")
            solver.isRight = true
        } else {
            io.writeMessage(to: .error, "오답...XXXXXXXX")
            solver.isRight = false
        }
        solver.date = Date()
        
        
        solver.publish(om: outputManager,
                       type: .solver,
                       showTitle: false, showQuestion: false, showAnswer: true, showTags: true,showHistory: true,
                       showAttribute: true, showOrigSel: false)
        
        
        let input = io.getInput("남기고 싶은 주기, (입력안함 \\) ?")
        if input == "" {
            io.writeMessage(to: .notice, "주기 입력안함")
        } else {
            solver.comment = input
            io.writeMessage(to: .notice, "주기 입력완료")
            solver.publish(om: outputManager,
                           type: .original,
                           showTitle: false, showQuestion: false, showAnswer: false, showTags: false,showHistory: true,
                           showAttribute: true, showOrigSel: false)
            
        }
        
        
        // 문제를 solve한 이 시점에 원 question에 풀이 이력을 추가
        solver.question.solvers.append(solver)
    }
    
    
    
    func handleSolveGenerator(_ generator : Generator?) {
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
    
    func handleQuestionGenerator(_ generatorUnwrapped : Generator?) {
        guard let generator = generatorUnwrapped else {
            return
        }
        if generator.solvers.count == 0 {
            return
        }
        let input = io.getInput("exit[], [e]dit ? ")
        if input == "e" || input == "ㄷ" {
            editGenerator(generator)
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
    
    func editGenerator(_ generator : Generator)  {
        
        let questions = generator.getQustioninSovers()
        var questionsEdited = [Question]()
        
        let queCounter = questions.count
        for (index,question) in questions.enumerated() {
            
            io.writeMessage()
            io.writeMessage(to: .title, "[[시험문제 수정 - \(index+1) / \(queCounter)]]")
            
            
            // solver가 셔플하든 말든 원래 값을 출력해야 할 것임
            Solver(question).publish(om: outputManager,
                                     type: .original,
                                     showTitle: true, showQuestion: true, showAnswer: true, showTags: false, showHistory: false,
                                     showAttribute: true, showOrigSel: true)
            
            io.writeMessage(to: .title, "[반전된 문제]")
            
            Solver(question).publish(om: outputManager,
                                     type: .originalNot,
                                     showTitle: true, showQuestion: true, showAnswer: true, showTags: false, showHistory: true,
                                     showAttribute: true, showOrigSel: true)
            
            
            
            var editedQuestion = Templet.Question(
                revision: question.revision + 1,  // revision up
                specification: question.specification,
                number: question.number,
                subjectDetails: question.subjectDetails,
                questionType: question.questionType,
                questionOX: question.questionOX,
                contentPrefix: question.contentPrefix,
                content: question.content,
                notContent: question.notContent,
                contentNote: question.contentNote,
                questionSuffix: question.questionSuffix,
                passage: question.passage,
                passageSuffix: question.passageSuffix,
                answer: question.answer,
                raw: question.raw,
                rawSelections: question.rawSelections,
                rawLists: question.rawLists,
                selections: [],  // 2. 선택지
                lists: []  // 3. 목록
            )
            
            for (_, statement) in question.lists.enumerated() {
                let list = Templet.List(
                    revision: statement.revision + 1,
                    specification: statement.specification,
                    content: statement.content,
                    notContent: statement.notContent,
                    listStringType: statement.listStringType,
                    number: statement.number)
                editedQuestion.lists.append(list)
            }
            
            for (_, statement) in question.selections.enumerated() {
                let selection = Templet.Selection(
                    revision: statement.revision + 1,
                    specification: statement.specification,
                    content: statement.content,
                    notContent: statement.notContent,
                    number: statement.number,
                    iscOrrect: statement.iscOrrect,
                    isAnswer: statement.isAnswer)
                editedQuestion.selections.append(selection)
            }
            
            
            let result = editQuestion(editedQuestion, false)
            if result.gonnaExit {
                return
            }
            guard let reultEdidtedQuestion = result.editedQuestion else {
                continue
            }
            
            
            question.revision = reultEdidtedQuestion.revision
            question.specification = reultEdidtedQuestion.specification
            question.number = reultEdidtedQuestion.number
            question.subjectDetails = reultEdidtedQuestion.subjectDetails
            question.questionType = reultEdidtedQuestion.questionType
            question.questionOX = reultEdidtedQuestion.questionOX
            question.contentPrefix = reultEdidtedQuestion.contentPrefix
            question.content = reultEdidtedQuestion.content
            question.notContent = reultEdidtedQuestion.notContent
            question.contentNote = reultEdidtedQuestion.contentNote
            question.questionSuffix = reultEdidtedQuestion.questionSuffix
            question.passage = reultEdidtedQuestion.passage
            question.passageSuffix = reultEdidtedQuestion.passageSuffix
            question.answer = reultEdidtedQuestion.answer
            question.raw = reultEdidtedQuestion.raw
            question.rawSelections = reultEdidtedQuestion.rawSelections
            question.rawLists = reultEdidtedQuestion.rawLists
            
            
            
            for (index,statement) in question.lists.enumerated() {
                statement.content = reultEdidtedQuestion.lists[index].content
                statement.notContent = reultEdidtedQuestion.lists[index].notContent
            }
            for (index,statement) in question.selections.enumerated() {
                statement.content = reultEdidtedQuestion.selections[index].content
                statement.notContent = reultEdidtedQuestion.selections[index].notContent
            }
            
            questionsEdited.append(question)
        }
        
        
        for que in questionsEdited {
            print(que.key)
        }
        
        let testsEdited = questionsEdited.map(){$0.test}.unique
        
        for test in testsEdited {
            print(test.key)
            saveTest(test)
        }
        
    }
    
    func editQuestion(_ editedQuestion : Templet.Question, _ next: Bool) -> (editedQuestion : Templet.Question?, gonnaExit : Bool) {
        let (instruction, value) = io.getEdit(io.getInput("수정할 대상선택 : "+io.getHelp(.InstEdit)))
        
        var question = editedQuestion
        
        var nextUpadte = next
        
        switch instruction {
        case .notQuestion:
            guard let result = editStatementString(
                title: "문제의 반대질문",
                question : nil,
                oriStr: question.content,
                oriIscOrrect: nil,
                notOriStr: question.notContent,
                isNotStatementEditMode: true)
                else {
                    return editQuestion(question, nextUpadte)
            }
            nextUpadte = true
            question.notContent = result
            return editQuestion(question, nextUpadte)
        
        
        case .notLists:
            for (index,statement) in question.lists.enumerated() {
                let count = question.lists.count
                guard let result = editStatementString(
                    title: "반대목록지 \(index+1) / \(count)",
                    question : question.notContent,
                    oriStr: statement.content,
                    oriIscOrrect: nil, // list는 아직 oX판단하는 기능이 없다? 충격적 꼭 필요함 추가 필요 2017. 5. 21. (+)(+)(+)(+)(+)
                    notOriStr: statement.notContent,
                    isNotStatementEditMode: true)
                    else {
                    continue
                }
                nextUpadte = true // 단 하나라도 수정된게 있어서 result가 가드문을 빠져 나오면 업데이트 된것으로 판단. -> 파일저장
                question.lists[index].notContent = result
            }
            if question.lists.count == 0 {
                io.writeMessage(to: .error, "문제에 목록지가 없음")
            }
            return editQuestion(question, nextUpadte)
        
        
        case .notSelections:
            for (index,statement) in question.selections.enumerated() {
                let count = question.selections.count
                guard let result = editStatementString(
                    title: "반대선택지 \(index+1) / \(count)",
                    question : question.notContent,
                    oriStr: statement.content,
                    oriIscOrrect: statement.iscOrrect,
                    notOriStr: statement.notContent,
                    isNotStatementEditMode: true)
                    else {
                    continue
                }
                nextUpadte = true
                question.selections[index].notContent = result
            }
            return editQuestion(question, nextUpadte)
        
        
        case .originalQuestion:
            guard let result = editStatementString(
                title: "문제의 질문",
                question : nil,
                oriStr: question.content,
                oriIscOrrect: nil,
                notOriStr: question.notContent,
                isNotStatementEditMode: true)
                else {
                return editQuestion(question, nextUpadte)
            }
            nextUpadte = true
            question.notContent = result
            return editQuestion(question, nextUpadte)
        
        
        case .originalLists:
            for (index,statement) in question.lists.enumerated() {
                let count = question.lists.count
                guard let result = editStatementString(
                    title: "목록지 \(index+1) / \(count)",
                    question : question.content,
                    oriStr: statement.content,
                    oriIscOrrect: nil,
                    notOriStr: statement.notContent,
                    isNotStatementEditMode: false)
                    else {
                    continue
                }
                nextUpadte = true
                question.lists[index].content = result
            }
            if question.lists.count == 0 {
                io.writeMessage(to: .error, "문제에 목록지가 없음")
            }
            return editQuestion(question, nextUpadte)
        
        
        case .originalSelection:
            for (index,statement) in question.selections.enumerated() {
                let count = question.selections.count
                guard let result = editStatementString(
                    title: "선택지 \(index+1) / \(count)",
                    question : question.content,
                    oriStr: statement.content,
                    oriIscOrrect : statement.iscOrrect,
                    notOriStr: statement.notContent,
                    isNotStatementEditMode: false)
                    else {
                    continue
                }
                nextUpadte = true
                question.selections[index].content = result
            }
            return editQuestion(question, nextUpadte)
            
        
        
        case .next:
            if nextUpadte {
                return (question, false)
            } else {
                return (nil, false) // -> gonnaExit은 false이나 질문반환ㄴ은 nil 이는 요번 질문은 수정안한다는 예기
            }
            
        case .exit:
            return (nil, true) // -> gonnaExit true 이는 파일저장 안하고 종료한다는 의미
            
        case .unknown:
            io.unkown(value, true)
            return editQuestion(question, nextUpadte)
        }
    }
    
    func editStatementString(title : String, question : String?, oriStr : String, oriIscOrrect : Bool?, notOriStr : String?, isNotStatementEditMode : Bool) -> String? {
        
        io.writeMessage()
        io.writeMessage(to: .title, "["+title+" 수정을 시작함]")
        
        
        let staOut = isNotStatementEditMode ? OutputType.standard : OutputType.important
        let notStaOut = isNotStatementEditMode ? OutputType.important : OutputType.standard
        let ontOriStrWrapped = notOriStr == nil ? "(입력되지 않음)" : notOriStr!
        
        var oriOX : String = ""
        var notOriOX : String = ""
        
        io.writeMessage()
        
        // 질문이 아니므로 목록지와 선택지는 OX를 판단할 수 있고 앞에 질문 출력이 필요함
        if question != nil {
            io.writeMessage(to: .publish, "[질문]")
            io.writeMessage()
            io.writeMessage(to: .publish, question!)
            io.writeMessage()
            
            if oriIscOrrect == nil {
                oriOX = "(알수없음)"
                notOriOX = oriOX
            } else {
                if oriIscOrrect == true {
                    oriOX = "(O)"
                    notOriOX = "(X)"
                } else {
                    oriOX = "(X)"
                    notOriOX = "(O)"
                }
            }
            
        }
        
        
        io.writeMessage(to: staOut, "[원본진술]")
        io.writeMessage()
        io.writeMessage(to: staOut, oriStr+"   \(oriOX)")
        io.writeMessage()
        io.writeMessage(to: notStaOut, "[반대진술]")
        io.writeMessage()
        io.writeMessage(to: notStaOut, ontOriStrWrapped+"   \(notOriOX)")
        io.writeMessage()
        
        let str = isNotStatementEditMode ? "> 수정할 반대진술 입력 (다시입력 : \\) $ " : "> 수정할 진술 입력 (다시입력 : \\) $"
        io.writeMessage(to: .notice, str)
        io.writeMessage()
        let inputUnwrapped : String? = io.getInput("", true)
        
        guard let input = inputUnwrapped else {
            io.writeMessage(to: .error, "올바르지 않은 입력")
            return editStatementString(title: title, question: question, oriStr: oriStr, oriIscOrrect: oriIscOrrect, notOriStr: notOriStr, isNotStatementEditMode: isNotStatementEditMode)
        }
        
        if input == "" {
            io.writeMessage(to: .error, "아무것도 입력되지 않아 진술수정하지 않음")
            return nil
        } else if input.characters.last == "\\" {
            // http://stackoverflow.com/questions/25113672/how-do-you-get-the-last-character-of-a-string-without-using-array-on-swift
            // How do you get the last character of a string without using array on swift?
            io.writeMessage(to: .notice, "다시입력")
            io.writeMessage(to: .notice, "")
            return editStatementString(title: title, question: question, oriStr: oriStr, oriIscOrrect: oriIscOrrect, notOriStr: notOriStr, isNotStatementEditMode: isNotStatementEditMode)
        }
        
        
        io.writeMessage()
        io.writeMessage(to: .important, "[수정한 진술]")
        io.writeMessage()
        io.writeMessage(to: .important, input)
        io.writeMessage()
        
        let inp = io.getInput("confirm[], [r]ewrite ?")
        if inp == "r" || inp == "ㄱ" {
            return editStatementString(title: title, question: question, oriStr: oriStr, oriIscOrrect: oriIscOrrect, notOriStr: notOriStr, isNotStatementEditMode: isNotStatementEditMode)
        }
        return input
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

