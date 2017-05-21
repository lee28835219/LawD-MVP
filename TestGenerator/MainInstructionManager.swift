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
                let generatorUnwrapped = publishAndSolver(gonnaShuffle: false, gonnaSolve: false, gonnaControversal: false)
                guard let generator = generatorUnwrapped else {
                    io.writeMessage(to: .error, "문제를 찾을 수 없음")
                    continue
                }
                if generator.solvers.count == 0 {
                    continue
                }
                let input = io.getInput("exit[], [e]dit ? ")
                if input == "e" || input == "ㄷ" {
                    editGenerator(generator)
                }
            
            case .publishShuffled:
                let generatorUnwrapped = publishAndSolver(gonnaShuffle: true, gonnaSolve: false, gonnaControversal: false)
                guard let generator = generatorUnwrapped else {
                    io.writeMessage(to: .error, "문제를 찾을 수 없음")
                    continue
                }
                if generator.solvers.count == 0 {
                    continue
                }
                let input = io.getInput("exit[], [e]dit ? ")
                if input == "e" || input == "ㄷ" {
                    editGenerator(generator)
                }
            
            case .solve:
                let generatorUnwrapped = publishAndSolver(gonnaShuffle: false, gonnaSolve: true, gonnaControversal: false)
                handleGenerator(generatorUnwrapped)
                
            case .solveShuffled:
                let generatorUnwrapped = publishAndSolver(gonnaShuffle: true, gonnaSolve: true, gonnaControversal: false)
                handleGenerator(generatorUnwrapped)
            
            case .solveControversal:
                let generatorUnwrapped = publishAndSolver(gonnaShuffle: true, gonnaSolve: true, gonnaControversal: true)
                handleGenerator(generatorUnwrapped)
                
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
    
    
    
    
    
//    // content를 수정하는 modifyQuestion의 보조함수
//    func modifyControversalContent(name : String, content : String, contentOX : String, notContent : String?, targetNumber : String) -> String? {
//        
//        var result : String? = notContent
//        
//        print("\(targetNumber)")
//        print(content, contentOX)
//        print("\(targetNumber) (!!!반대)")
//        var contentOXCont = contentOX
//        if contentOXCont == "(O)" {
//            contentOXCont = "(X)"
//        } else if contentOXCont == "(X)" {
//            contentOXCont = "(O)"
//        }
//        
//        print((notContent != nil ? notContent! : "없음"),contentOXCont)
//        
//        print("-. 반대\(name) 신규입력 \(targetNumber) $ ")
//        let inp = consoleIO.getInput()
//        print()
//        if inp == "" {
//            print("> 아무것도 입력된 것이 없어 반대\(name) 변경없음")
//        } else {
//            result = inp
//            print("> 반대\(name) 입력완료 : \(targetNumber)")
//            print(result!, contentOXCont)
//        }
//        
//        print("계속()다시(r) $ ", terminator: "")
//        let iinp = consoleIO.getInput()
//        if iinp == "r" || iinp == "ㄱ" {
//            return modifyControversalContent(name : name, content : content, contentOX : contentOX, notContent : notContent, targetNumber : targetNumber)
//        }
//        print()
//        return result
//        
//        // 추가 디버깅 사항 2017. 5. 16. (+)
//        // 1. 문제 반전사항출력(완료)), 2. 문제유형 반전해서 출력, 3. 목록 선택지 문제일 경우 선택지는 손대지 않음
//        
//    }
    
    
    
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
    
    
    func publishAndSolver(gonnaShuffle: Bool, gonnaSolve: Bool, gonnaControversal: Bool = false) -> Generator? {
        let generator = Generator()
        
        var str = ""
        if gonnaSolve {
            str = "풀 문제의 형식을 선택"
        } else {
            str = "출력할 형식을 선택"
        }
        let (instruction,value) = io.getPublish(io.getInput(str+io.getHelp(.InstPublish)))
        
        
        switch instruction {
        case .all:
            for testCategory in testDatabase.categories {
                for testSubject in testCategory.testSubjects {
                    for test in testSubject.tests {
                        for que in test.questions {
                            let (generator, gonnaExit) = solveQuestion(que, gonnaShuffle: gonnaShuffle, gonnaSolve: gonnaSolve, gonnaControversal : gonnaControversal, generator: generator)
                            if gonnaExit {
                                return generator
                            }
                        }
                    }
                }
            }
        case .category:
            guard let testCategory = selectTestCategory(testDatabase) else {
                io.writeMessage(to: .error, "시험명을 찾을 수 없음")
                return nil
            }
            for testSubject in testCategory.testSubjects {
                for test in testSubject.tests {
                    for que in test.questions {
                        let (generator, gonnaExit) = solveQuestion(que, gonnaShuffle: gonnaShuffle, gonnaSolve: gonnaSolve, gonnaControversal : gonnaControversal, generator: generator)
                        if gonnaExit {
                            return generator
                        }
                    }
                }
            }
        case .subject:
            guard let testCategory = selectTestCategory(testDatabase) else {
                io.writeMessage(to: .error, "시험명을 찾을 수 없음")
                return nil
            }
            guard let testSubject = selectTestSubject(testCategory) else {
                io.writeMessage(to: .error, "시험과목을 찾을 수 없음")
                return nil
            }
            for test in testSubject.tests {
                for que in test.questions {
                    let (generator, gonnaExit) = solveQuestion(que, gonnaShuffle: gonnaShuffle, gonnaSolve: gonnaSolve, gonnaControversal : gonnaControversal, generator: generator)
                    if gonnaExit {
                        return generator
                    }
                }
            }
        case .test:
            guard let testCategory = selectTestCategory(testDatabase) else {
                io.writeMessage(to: .error, "시험명을 찾을 수 없음")
                return nil
            }
            guard let testSubject = selectTestSubject(testCategory) else {
                io.writeMessage(to: .error, "시험과목을 찾을 수 없음")
                return nil
            }
            guard let test = selectTest(testSubject) else {
                io.writeMessage(to: .error, "시험회차를 찾을 수 없음")
                return nil
            }
            for que in test.questions {
                let (generator, gonnaExit) = solveQuestion(que, gonnaShuffle: gonnaShuffle, gonnaSolve: gonnaSolve, gonnaControversal : gonnaControversal, generator: generator)
                if gonnaExit {
                    return generator
                }
            }
            
        case .question:
            guard let testCategory = selectTestCategory(testDatabase) else {
                io.writeMessage(to: .error, "시험명을 찾을 수 없음")
                return nil
            }
            guard let testSubject = selectTestSubject(testCategory) else {
                io.writeMessage(to: .error, "시험과목을 찾을 수 없음")
                return nil
            }
            guard let test = selectTest(testSubject) else {
                io.writeMessage(to: .error, "시험회차를 찾을 수 없음")
                return nil
            }
            guard let que = selectQuestion(test) else {
                io.writeMessage(to: .error, "문제를 찾을 수 없음")
                return nil
            }
            let (generator, gonnaExit) = solveQuestion(que, gonnaShuffle: gonnaShuffle, gonnaSolve: gonnaSolve, gonnaControversal : gonnaControversal, generator: generator)
            if gonnaExit {
                return generator
            }
            
        case .unknown:
            io.unkown(value)
        }
        
        return generator
        
    }
    
    
    func solveQuestion(_ question : Question, gonnaShuffle: Bool, gonnaSolve: Bool, gonnaControversal : Bool, generator: Generator) -> (Generator, Bool) {
        
        let showAnswer = gonnaSolve ? false : true
        let showHistory = gonnaSolve ? false : true
        let showAttribute = gonnaSolve ? false : true
        var showOrigSel = true
        
        if gonnaSolve {
            showOrigSel = false
        } else {
            showOrigSel ? true : false
        }
        
        let solver = Solver(question, gonnaShuffle: gonnaShuffle)
        
        if !solver.isOXChangable && gonnaControversal {
            return (generator, false)
        }
        
        solver.publish(outputManager: outputManager, showTitle: true, showAnswer: showAnswer, showHistory : showHistory, showAttribute: showAttribute, showOrigSel: showOrigSel)
        
        
        if gonnaSolve {
            solver.solve(io : io)
            solver.comment = io.getInput("남기고 싶은 코멘트")
            
            var goon = true
            while goon {
                let (instruction, value) = io.getSolve(io.getInput(io.getHelp(.InstSolve)))
                switch instruction {
                case .resolve:
                    generator.solvers.append(solver)
                    return solveQuestion(question, gonnaShuffle: gonnaShuffle, gonnaSolve: gonnaSolve, gonnaControversal: gonnaControversal, generator: generator)
                case .noteQuestion:
                    let note = io.getInput("\(question.key)에 대한 태그입력")
                case .tagQuestion:
                    let tag = io.getInput("\(question.key)에 대한 태그입력")
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
                    generator.solvers.append(solver)
                    goon = false
                }
            }
        } else {
            generator.solvers.append(solver)
        }
        
        return (generator,false)
    }
    
    func handleGenerator(_ generator : Generator?) {
        if let generator = generator {
            let (r,_) = generator.seperateWorngSolve()
            io.writeMessage(to: .notice, "총 \(generator.solvers.count) 문제 중 \(r.count) 문제 맞춤")
            var tests = generator.solvers.map{$0.question.test}
            
            tests = tests.unique
            
            for test in tests {
                // 저장에 관한 메세지는 함수 내부에서 가지고 있음
                _ = test.save()
            }
            
        } else {
            io.writeMessage(to: .error, "문제를 찾을 수 없음")
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
        
        let questions = generator.solvers.map(){$0.question}.unique
        
        var questionsEdited = [Question]()
        
        
        for question in questions {
            
            Solver(question).publish(outputManager: outputManager)
            Solver(question).controversalPublish()
            
            
            
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
            guard let result = editStatement(title: "문제의 반대질문", oriStr: question.content, notOriStr: question.notContent, isNotStatementEditMode: true) else
            {
                return editQuestion(question, nextUpadte)
            }
            nextUpadte = true
            question.notContent = result
            return editQuestion(question, nextUpadte)
        
        
        case .notLists:
            for (index,statement) in question.lists.enumerated() {
                let count = question.lists.count
                guard let result = editStatement(title: "반대목록지 \(index+1) / \(count)", oriStr: statement.content, notOriStr: statement.notContent, isNotStatementEditMode: true) else
                {
                    continue
                }
                nextUpadte = true
                question.lists[index].notContent = result
            }
            return editQuestion(question, nextUpadte)
        
        
        case .notSelections:
            for (index,statement) in question.selections.enumerated() {
                let count = question.selections.count
                guard let result = editStatement(title: "반대선택지 \(index+1) / \(count)", oriStr: statement.content, notOriStr: statement.notContent, isNotStatementEditMode: true) else
                {
                    continue
                }
                nextUpadte = true
                question.selections[index].notContent = result
            }
            nextUpadte = true
            return editQuestion(question, nextUpadte)
        
        
        case .originalQuestion:
            guard let result = editStatement(title: "문제의 질문", oriStr: question.content, notOriStr: question.notContent, isNotStatementEditMode: true) else
            {
                return editQuestion(question, nextUpadte)
            }
            nextUpadte = true
            question.notContent = result
            return editQuestion(question, nextUpadte)
        
        
        case .originalLists:
            for (index,statement) in question.lists.enumerated() {
                let count = question.lists.count
                guard let result = editStatement(title: "목록지 \(index+1) / \(count)", oriStr: statement.content, notOriStr: statement.notContent, isNotStatementEditMode: false) else
                {
                    continue
                }
                nextUpadte = true
                question.lists[index].content = result
            }
            return editQuestion(question, nextUpadte)
        
        
        case .originalSelection:
            for (index,statement) in question.selections.enumerated() {
                let count = question.selections.count
                guard let result = editStatement(title: "선택지 \(index+1) / \(count)", oriStr: statement.content, notOriStr: statement.notContent, isNotStatementEditMode: false) else
                {
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
                return (nil, false)
            }
        case .exit:
            return (nil, false)
        case .unknown:
            io.unkown(value, true)
            return editQuestion(question, nextUpadte)
        }
    }
    
    func editStatement(title : String, oriStr : String, notOriStr : String?, isNotStatementEditMode : Bool) -> String? {
        
        io.writeMessage()
        io.writeMessage(to: .title, "["+title+" 수정을 시작함]")
        
        
        
        let staOut = isNotStatementEditMode ? OutputType.standard : OutputType.important
        let notStaOut = isNotStatementEditMode ? OutputType.important : OutputType.standard
        let ontOriStrWrapped = notOriStr == nil ? "(입력되지 않음)" : notOriStr!
        
        io.writeMessage()
        io.writeMessage(to: staOut, "[원본진술]")
        io.writeMessage()
        io.writeMessage(to: staOut, oriStr)
        io.writeMessage()
        io.writeMessage(to: notStaOut, "[반대진술]")
        io.writeMessage()
        io.writeMessage(to: notStaOut, ontOriStrWrapped)
        io.writeMessage()
        
        let str = isNotStatementEditMode ? "> 수정할 반대진술 입력(다시 입력을 원할 시 \\) $ " : "> 수정할 진술 입력(다시 입력을 원할 시 \\) $"
        io.writeMessage(to: .notice, str)
        io.writeMessage()
        let inputUnwrapped : String? = io.getInput("", true)
        
        guard let input = inputUnwrapped else {
            io.writeMessage(to: .error, "올바르지 않은 입력")
            return editStatement(title: title, oriStr: oriStr, notOriStr: notOriStr, isNotStatementEditMode: isNotStatementEditMode)
        }
        
        if input == "" {
            io.writeMessage(to: .error, "아무것도 입력되지 않아 진술수정하지 않음")
            return nil
        } else if input.characters.last == "\\" {
            // http://stackoverflow.com/questions/25113672/how-do-you-get-the-last-character-of-a-string-without-using-array-on-swift
            // How do you get the last character of a string without using array on swift?
            io.writeMessage(to: .notice, "다시입력")
            io.writeMessage(to: .notice, "")
            return editStatement(title: title, oriStr: oriStr, notOriStr: notOriStr, isNotStatementEditMode: isNotStatementEditMode)
        }
        
        
        io.writeMessage()
        io.writeMessage(to: .important, "[수정한 진술]")
        io.writeMessage()
        io.writeMessage(to: .important, input)
        io.writeMessage()
        
        let inp = io.getInput("confirm[], [r]ewrite ?")
        if inp == "r" || inp == "ㄱ" {
            return editStatement(title: title, oriStr: oriStr, notOriStr: notOriStr, isNotStatementEditMode: isNotStatementEditMode)
        }
        return input
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

