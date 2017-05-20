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
                let (inst,value) = io.getKey(io.getInput("\(testDatabase.key)의 시험카테고리 모두출력, "+io.getHelp(.InstKey)))
                showKeys(inst, value : value)
                
            case .publish:
                publishAndSolver(instruction.rawValue, gonnaShuffle: false, gonnaSolve: false)
            
            case .publishShuffled:
                publishAndSolver(instruction.rawValue, gonnaShuffle: true, gonnaSolve: false)
            
            case .solve:
                publishAndSolver(instruction.rawValue, gonnaShuffle: false, gonnaSolve: true)
                
            case .solveShuffled:
                publishAndSolver(instruction.rawValue, gonnaShuffle: true, gonnaSolve: true)
                
                
            case .save:
                let (inst,value) = io.getSave(io.getInput("저장할 형식을 선택, "+io.getHelp(.InstSave)))
                switch inst {
                case .all:
                    for testCategory in testDatabase.categories {
                        for testSubject in testCategory.testSubjects {
                            for test in testSubject.tests {
                                saveTest(test)
                                
//                                if self.outputManager.saveTest(test) {
//                                    //print("> [\(Date().HHmmss)]\(test.testSubject.testCategory.testDatabase.key)=\(test.key).json 저장성공")
//                                    //outputManager.saveFile()에 에러 로그가 있어 여기서 처리할 필요없음.
//                                } else {
//                                    //print("> [\(Date().HHmmss)]\(test.testSubject.testCategory.testDatabase.key)=\(test.key).json 저장실패")
//                                    // 정밀한 에러 핸들링 필요 2017. 5. 9. (+)
//                                }
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
                storageManager.refresh(io: io)
            
            case .unknown:
                _ = io.unkown(value, true)
            }
        }
    }
    
                
    func execute(_ input : String) -> Bool? {
        
        
//        if isSame(input, targets: ["shuffles","노ㅕㄹ릳ㄴ"]) {
//            let selectedSubject = selectTestSubject(selectTestCategory(testDatabase))
//            
//            guard let selectedSubjectWrapped = selectedSubject else {
//                print("선택한 과목을 찾을 수 없었음")
//                return false
//            }
//            
//            var selectedQuestions = [Question]()
//            
//            for test in selectedSubjectWrapped.tests {
//                selectedQuestions.append(contentsOf: test.questions)
//            }
//            
//            if selectedQuestions.count == 0 {
//                print(">\(selectedSubjectWrapped.key)에 문제가 하나도 없음")
//                return false
//            }
//            
//            _ = solveShuffledQuestions(selectedQuestions.shuffled())
//            
//            return true
//        }
//        
//        
        
        // 시험을 선택하여 문제당 5개의 변형문제를 진행
//        if isSame(input, targets: ["shufflet","노ㅕㄹ릳ㅅ"]) {
//            let selectedTest = selectTest(selectTestSubject(selectTestCategory(testDatabase)))
//            
//            guard let selectedTestWrapped = selectedTest else {
//                print("선택한 시험을 찾을 수 없었음")
//                return false
//            }
//            
//            let selectedQuestions = selectedTestWrapped.questions.shuffled()
//            
//            if selectedQuestions.count == 0 {
//                print(">\(selectedTestWrapped.key)에 문제가 하나도 없음")
//                return false
//            }
//
//            _ = solveShuffledQuestions(selectedQuestions.shuffled())
//            
//            return true
//        }
//
//        // 문제를 선택하여 10개의 변형문제를 진행
//        if isSame(input, targets: ["shuffleq","노ㅕㄹ릳ㅂ"]) {
//            
//            let selectedTest = selectTest(selectTestSubject(selectTestCategory(testDatabase)))
//    
//            let selectedQuestion = selectQuestion(selectedTest)
//            guard let selectedQuestionWrapped = selectedQuestion else { return false }
//            
//            selectedQuestionWrapped.publish(showAttribute: true, showAnswer: true, showTitle: true, showOrigSel: false)
//            
//            for _ in 1...5 {
//                let result = solveShuffledQuestion(question: selectedQuestionWrapped)
//                if !result.isShuffled {
//                    return false
//                }
//            }
//            return true
//        }

        return false
    }
    
    
    
    
    
    //// 내부보조함수
    
    
    
    
    // 입력이 주어진 값과 동일한지 확인하는 함수
    // 한글로 잘못 입력하는 경우도 동일한 입력으로 고려함
    func isSame(_ input : String, targets : [String]) -> Bool {
        var result = false
        for target in targets {
            if input.caseInsensitiveCompare(target) == ComparisonResult.orderedSame {
                result = true
            }
        }
        return result
    }
    
    
    
    
    
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

extension MainInstructionManager {
    
//    func solveShuffledQuestions(_ questions : [Question]) -> [Question] {
//        var wrongQuestions = [Question]()
//        
//        for (index,que) in questions.enumerated() {
//            print("(\(index) / \(questions.count))")
//            let result = solveShuffledQuestion(question: que)
//            if !result.isShuffled {
//                continue
//            }
//            if !result.isRight {
//                wrongQuestions.append(que)
//            }
//        }
//        if wrongQuestions.count == 0 {
//            print(">총 \(questions.count) 문제 모두 맞춤-종료(),문제수정(m) $ ", terminator: "")
//        } else {
//            print(">총 \(questions.count) 문제 중 \(questions.count - wrongQuestions.count) 개 맞춤-종료(),다시풀기(r),틀린문제만 다시풀기(w) $ ", terminator: "")
//        }
//        let input = readLine()
//        if input == "r" || input == "ㄱ" {
//            wrongQuestions = solveShuffledQuestions(questions)
//        }
//        if (input == "w" && wrongQuestions.count != 0) || (input == "ㅈ" && wrongQuestions.count != 0){
//            wrongQuestions = solveShuffledQuestions(wrongQuestions)
//        }
//        return wrongQuestions
//    }
    
    
    func showKeys(_ instKey : InstKey, value: String) {
        switch instKey {
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
            _ = true
            io.unkown(value)
        }
    }
    
    
    func publishAndSolver(_ instructionRaw : String, gonnaShuffle: Bool, gonnaSolve: Bool) {
        var str = ""
        if gonnaSolve {
            str = "풀 문제의 형식을 선택"
        } else {
            str = "출력할 형식을 선택"
        }
        let (inst,value) = io.getPublish(io.getInput(str+io.getHelp(.InstPublish)))
        if !selectQuestion(inst, value : value, gonnaShuffle: gonnaShuffle, gonnaSolve: gonnaSolve) {
            publishAndSolver(instructionRaw, gonnaShuffle:  gonnaShuffle, gonnaSolve: gonnaSolve)
            return
        }
    }
    
    
    // 함수를 건내줘서 출력하는 것으로 추후 수정 필요 2017. 5. 19.
    func selectQuestion(_ instruction : InstPublish, value: String, gonnaShuffle : Bool, gonnaSolve : Bool) -> Bool{
        var solvers = [Solver]()
        
        switch instruction {
        case .all:
            for testCategory in testDatabase.categories {
                for testSubject in testCategory.testSubjects {
                    for test in testSubject.tests {
                        for que in test.questions {
                            solvers.append(solveQuestion(que, gonnaShuffle: gonnaShuffle, gonnaSolve: gonnaSolve))
                        }
                    }
                }
            }
        case .category:
            guard let testCategory = selectTestCategory(testDatabase) else {
                io.writeMessage(to: .error, "시험명을 찾을 수 없음")
                return true
            }
            for testSubject in testCategory.testSubjects {
                for test in testSubject.tests {
                    for que in test.questions {
                        solvers.append(solveQuestion(que, gonnaShuffle: gonnaShuffle, gonnaSolve: gonnaSolve))
                    }
                }
            }
        case .subject:
            guard let testCategory = selectTestCategory(testDatabase) else {
                io.writeMessage(to: .error, "시험명을 찾을 수 없음")
                return true
            }
            guard let testSubject = selectTestSubject(testCategory) else {
                io.writeMessage(to: .error, "시험과목을 찾을 수 없음")
                return true
            }
            for test in testSubject.tests {
                for que in test.questions {
                    solvers.append(solveQuestion(que, gonnaShuffle: gonnaShuffle, gonnaSolve: gonnaSolve))

                }
            }
        case .test:
            guard let testCategory = selectTestCategory(testDatabase) else {
                io.writeMessage(to: .error, "시험명을 찾을 수 없음")
                return true
            }
            guard let testSubject = selectTestSubject(testCategory) else {
                io.writeMessage(to: .error, "시험과목을 찾을 수 없음")
                return true
            }
            guard let test = selectTest(testSubject) else {
                io.writeMessage(to: .error, "시험회차를 찾을 수 없음")
                return true
            }
            for que in test.questions {
                solvers.append(solveQuestion(que, gonnaShuffle: gonnaShuffle, gonnaSolve: gonnaSolve))
            }
        case .question:
            guard let testCategory = selectTestCategory(testDatabase) else {
                io.writeMessage(to: .error, "시험명을 찾을 수 없음")
                return true
            }
            guard let testSubject = selectTestSubject(testCategory) else {
                io.writeMessage(to: .error, "시험과목을 찾을 수 없음")
                return true
            }
            guard let test = selectTest(testSubject) else {
                io.writeMessage(to: .error, "시험회차를 찾을 수 없음")
                return true
            }
            guard let que = selectQuestion(test) else {
                io.writeMessage(to: .error, "문제를 찾을 수 없음")
                return true
            }
            solvers.append(solveQuestion(que, gonnaShuffle: gonnaShuffle, gonnaSolve: gonnaSolve))
            
        case .unknown:
            io.unkown(value)
        }
        return true
        
    }
    
    
    func solveQuestion(_ question : Question, gonnaShuffle: Bool, gonnaSolve: Bool) -> Solver {
        let showAttribute = gonnaSolve ? false : true
        let showAnswer = gonnaSolve ? false : true
        let showOrigSel = gonnaSolve ? false : true
        
        let solver = Solver(question, gonnaShuffle: gonnaShuffle)
        solver.publish(outputManager: outputManager, showAttribute: showAttribute, showAnswer: showAnswer, showTitle: true, showOrigSel: showOrigSel)
        
        if gonnaSolve {
            solver.solve(consoleIO : io)
        }
        return solver
    }

    
//    func modifyQuestion(_ question: Question) {
//        
//        print("수정할 문제의 항목을 선택-반전목록지 수정(2),반전선택지 수정(3),모든 반전내용 자동입력(4),문제보기(show),종료(end) $ ", terminator:"")
//        let input = io.getInput()
//        
//        switch input {
//        case "end" :
//            return
//            
//        case "show" :
//            
//            Solver(question).publish(outputManager: outputManager, showAttribute: true, showAnswer: true, showTitle: true, showOrigSel: false)
//
//            print()
//            print("<반전된 문제>")
//            question.controversalPublish()
//            modifyQuestion(question)
//            return
//            
//        // 문제 수정을 시작
//        case "2" :
//            guard let list = selectList(question) else {
//                modifyQuestion(question)
//                return
//            }
//            list.notContent = modifyControversalContent(name: "목록지", content: list.content, contentOX: list.getOX(), notContent: list.notContent, targetNumber: list.getListString()+".")
//            
//        case "3" :
//            if question.questionType == QuestionType.Find {
//                print("> 해당 문제 타입은 선택지를 수정할 수 없음-계속()", terminator: "")
//                _ = readLine()
//                modifyQuestion(question)
//                return
//            }
//            
//            guard let selection = selectSelection(question) else {
//                modifyQuestion(question)
//                return
//            }
//            selection.notContent = modifyControversalContent(name: "선택지", content: selection.content, contentOX: selection.getOX(), notContent: selection.notContent, targetNumber: selection.number.roundInt)
//            
//        case "4" :
//            print()
//            let listNumber = question.lists.count
//            if listNumber != 0 {
//                
//                print("> 목록 \(listNumber)개 수정을 진행")
//                for (index,list) in question.lists.enumerated() {
//                    
//                    print("> 질문 : \(question.content) (\(question.questionType)\(question.questionOX))")
//                    print("> 목록지 \(index+1) / \(listNumber) 수정진행..")
//                    list.notContent = modifyControversalContent(name: "목록지", content: list.content, contentOX: list.getOX(),notContent: list.notContent, targetNumber: list.getListString()+".")
//                }
//            }
//            
//            let selNumber = question.selections.count
//            print("> 선택지 \(selNumber)개 수정을 진행")
//            
//            if question.questionType != .Find {
//                for (index,sel) in question.selections.enumerated() {
//                    
//                    print("> 질문 : \(question.content) (\(question.questionType)\(question.questionOX))")
//                    print("> 선택지 \(index+1) / \(selNumber) 수정진행..")
//                    print("-. 선택지 : \(sel.number.roundInt)")
//                    sel.notContent = modifyControversalContent(name: "선택지", content: sel.content, contentOX: sel.getOX(),notContent: sel.notContent, targetNumber: sel.number.roundInt)
//                }
//            }
//            
//            
//        default:
//            modifyQuestion(question)
//            return
//        }
//        
//        var goon = true
//        while goon {
//            print("<반전된 문제> - 변경됨")
//            question.controversalPublish()
//            
//            print("변경사항을 저장?()-저장 후 계속문제 수정(m),저장 없이 계속문제 수정(n),종료(e) $ ", terminator: "")
//            
//            guard let input = readLine() else {
//                print("유효하지 않은 입력")
//                continue
//            }
//            
//            if input == "e" || input == "ㄷ" {
//                
//                print(">"+question.key+" 저장하지 않음")
//                return
//                
//            } else if input == "m" || input == "ㅡ" {
//                
//                print(">"+question.key+" 저장완료")
//                _ = outputManager.saveTest(question.test)
//                modifyQuestion(question)
//                return
//                
//            } else if input == "n" || input == "ㅜ" {
//                
//                modifyQuestion(question)
//                return
//            }
//            
//            print(">"+question.key+" 저장완료")
//            _ = outputManager.saveTest(question.test)
//            
//            print("")
//            goon = false
//        }
//    }
    
    func saveTest(_ selectedTest : Test?) {
        guard let selectedTestWrapped = selectedTest else {
            
            print("선택한 시험이 없어 시험저장 실패")
            return
        }
        
        if outputManager.saveTest(selectedTestWrapped) {
            return
        } else {
            return
        }
    }
    
}

