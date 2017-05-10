//
//  InputManager.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 3. 22..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class InputManager {
    var isDBChanged : Bool = false
    
    let testDatabase : TestDatabase
    let outputManager : OutputManager
    
    init(testDatabase : TestDatabase, outputManager : OutputManager) {
        self.testDatabase = testDatabase
        self.outputManager = outputManager
    }
    
    func execute(_ input : String) -> Bool? {
        
//        if input.caseInsensitiveCompare("dir") == ComparisonResult.orderedSame || input == "ㅇㅑㄱ" {
//            
//            outputManager.showDirectory(outputManager.url)
//            
//            return true
//        }
        
        
        // exit
        
        // 조회명령
        // tcatall
        // tsuball
        // testall
        // queall
        // keyall
        
        // 저장명령
        // savet
        
        // 출력명령
        // selta, selt
        // selqa, selq
        
        // 문제 섞어 출력
        // shufflet
        // shuffleq
        
        if input == "" {
            return nil
        }
        
        if input.caseInsensitiveCompare("exit") == ComparisonResult.orderedSame || input == "ㄷㅌㅑㅅ" {
            return true
        }
        
        
        
        
        if input.caseInsensitiveCompare("tcatall") == ComparisonResult.orderedSame || input == "ㅅㅊㅁㅅㅁㅣㅣ" {
            print("\(testDatabase.key)의 시험카테고리 모두출력")
            
            for testCategory in testDatabase.categories {
                print(" |",testCategory.key)
            }
            return true
        }
        
        
        if input.caseInsensitiveCompare("tsuball") == ComparisonResult.orderedSame || input == "ㅅㄴㅕㅠㅁㅣㅣ" {
            print("\(testDatabase.key)의 시험카테고리 모두출력")
            
            for testCategory in testDatabase.categories {
                print(" |",testCategory.key)
                for testSubject in testCategory.testSubjects {
                    print("  |",testSubject.key)
                }
            }
            return true
        }
        
        
        
        if input.caseInsensitiveCompare("testall") == ComparisonResult.orderedSame || input == "ㅅㄷㄴㅅㅁㅣㅣ" {
            print("\(testDatabase.key)의 시험을 모두출력")
            
            for testCategory in testDatabase.categories {
                print(" |",testCategory.key)
                for testSubject in testCategory.testSubjects {
                    print("  |",testSubject.key)
                    for test in testSubject.tests {
                        print("   |",test.key)
                    }
                }
            }
            return true
        }
        
        
        
        if input.caseInsensitiveCompare("queall") == ComparisonResult.orderedSame || input == "ㅂㅕㄷㅁㅣㅣ" {
            print("\(testDatabase.key)의 문제를 모두출력")
            
            for testCategory in testDatabase.categories {
                print(" |",testCategory.key)
                for testSubject in testCategory.testSubjects {
                    print("  |",testSubject.key)
                    for test in testSubject.tests {
                        print("   |",test.key)
                        for que in test.questions {
                            print("    |", que.key)
                        }
                    }
                }
            }
            return true        }
        
        if input.caseInsensitiveCompare("keyall") == ComparisonResult.orderedSame || input == "ㅏㄷㅛㅁㅣㅣ" {
            print("\(testDatabase.key)의 키를 모두출력")
            
            for testCategory in testDatabase.categories {
                print(" |",testCategory.key)
                for testSubject in testCategory.testSubjects {
                    print("  |",testSubject.key)
                    for test in testSubject.tests {
                        print("   |",test.key)
                        for que in test.questions {
                            print("    |", que.key)
                            for sel in que.lists {
                                print("     |",sel.key)
                            }
                            for sel in que.selections {
                                print("     |",sel.key)
                            }
                        }
                    }
                }
            }
            return true
        }
        
        if input.caseInsensitiveCompare("savet") == ComparisonResult.orderedSame || input == "ㄴㅁㅍㄷㅅ" {
            
            let selectedTest = selectTest(selectTestSubject(selectTestCategory(testDatabase)))
            
            guard let selectedTestWrapped = selectedTest else {
                print("선택한 시험이 없어 시험저장 실패")
                return false
            }
            
            if outputManager.saveTest(selectedTestWrapped) {
                return true
            } else {
                return false
            }
            
            
        }
        
        if input.caseInsensitiveCompare("saveall") == ComparisonResult.orderedSame || input == "ㄴㅁㅍㄷㅁㅣㅣ" {
            
            for testCategory in testDatabase.categories {
                for testSubject in testCategory.testSubjects {
                    for test in testSubject.tests {
                        
                        if self.outputManager.saveTest(test) {
                            //print("> [\(Date().HHmmss)]\(test.testSubject.testCategory.testDatabase.key)=\(test.key).json 저장성공")
                            //outputManager.saveFile()에 에러 로그가 있어 여기서 처리할 필요없음.
                        } else {
                            //print("> [\(Date().HHmmss)]\(test.testSubject.testCategory.testDatabase.key)=\(test.key).json 저장실패")
                            // 정밀한 에러 핸들링 필요 2017. 5. 9. (+)
                        }
                    }
                }
            }
            
            return true
        }
        
        
        if input.caseInsensitiveCompare("cq") ==  ComparisonResult.orderedSame || input == "ㅊㅂ" {
            //http://stackoverflow.com/questions/30532728/how-to-compare-two-strings-ignoring-case-in-swift-language
            createQuestion()
            
            return true
        }
        
        if input.caseInsensitiveCompare("selta") ==  ComparisonResult.orderedSame  || input == "ㄴㄷㅣㅅㅁ"
            || input.caseInsensitiveCompare("selt") ==  ComparisonResult.orderedSame  || input == "ㄴㄷㅣㅅ" {
            
            var showAnswer = false
            if input.caseInsensitiveCompare("selectta") ==  ComparisonResult.orderedSame  || input == "ㄴㄷㅣㄷㅊㅅㅅㅁ" {
                showAnswer = true
            }
            
            guard let selectedTest = selectTest(selectTestSubject(selectTestCategory(testDatabase))) else {
                print("선택한 시험을 찾을 수 없었음")
                return false
            }
            
            if selectedTest.questions.count == 0 {
                print(">\(selectedTest.key)에 문제가 하나도 없음")
                return false
            }
            
            for (index, question) in selectedTest.questions.enumerated() {
                if index == 0 {
                    question.publish(showAttribute: showAnswer, showAnswer: showAnswer, showTitle: true, showOrigSel: false)
                } else {
                    question.publish(showAttribute: showAnswer, showAnswer: showAnswer, showTitle: false, showOrigSel: false)
                }
            }
            
            return true
        }
        
        
        
        
        if input.caseInsensitiveCompare("selqa") ==  ComparisonResult.orderedSame  || input == "ㄴㄷㅣㅂㅁ"
            || input.caseInsensitiveCompare("selq") ==  ComparisonResult.orderedSame  || input == "ㄴㄷㅣㅂ" {
            
            var showAnswer = false
            if input.caseInsensitiveCompare("selqa") ==  ComparisonResult.orderedSame  || input == "ㄴㄷㅣㅂㅁ" {
                showAnswer = true
            }
            
            let selectedTest = selectTest(selectTestSubject(selectTestCategory(testDatabase)))
            
            guard let selectedQuestion = selectQuestion(selectedTest) else {
                print(">선택한 문제를 찾을 수 없었음")
                return false
            }
            
            selectedQuestion.publish(showAttribute: showAnswer, showAnswer: showAnswer, showTitle: true, showOrigSel: false)
            
            return true
        }
        
        
        // 시험을 선택하여 문제당 5개의 변형문제를 진행
        if input.caseInsensitiveCompare("shufflet") ==  ComparisonResult.orderedSame  || input == "ㄴㅗㅕㄹㄹㅣㅅ" {
            let selectedTest = selectTest(selectTestSubject(selectTestCategory(testDatabase)))
            
            guard let selectedTestWrapped = selectedTest else {
                print("선택한 시험을 찾을 수 없었음")
                return false
            }
            
            let selectedQuestions = selectedTestWrapped.questions
            
            if selectedQuestions.count == 0 {
                print(">\(selectedTestWrapped.key)에 문제가 하나도 없음")
                return false
            }
            
            for que in selectedQuestions {
                que.publish(showAttribute: true, showAnswer: true, showTitle: true, showOrigSel: false)
                print()
                print("[변형]" + que.key)
                for _ in 1...1 {
                    if !solveShuffledQuestion(question: que) {
                        return false
                    }
                }
            }
            return true
        }
        
        // 문제를 선택하여 10개의 변형문제를 진행
        if input.caseInsensitiveCompare("shuffleq") ==  ComparisonResult.orderedSame  || input == "ㄴㅗㅕㄹㄹㅣㄷㅂ" {
            
            let selectedTest = selectTest(selectTestSubject(selectTestCategory(testDatabase)))
    
            let selectedQuestion = selectQuestion(selectedTest)
            guard let selectedQuestionWrapped = selectedQuestion else { return false }
            
            selectedQuestionWrapped.publish(showAttribute: true, showAnswer: true, showTitle: true, showOrigSel: false)
            for _ in 1...1 {
                if !solveShuffledQuestion(question: selectedQuestionWrapped) {
                    return false
                }
            }
            return true
        }

        return false
    }
    
    
    // 문제를 입력하면 변형하여 문제를 출력하고 입력을 받아서 정답을 체크하는 함수
    // 변경문제에 대하여 문제변경이 성공하면 진행하지만, 실패하면 false를 반환
    // 1. 노트추가나 태그추가, 2. 문제변경 기능에 대해서 만들어내도록 기능추가해야할 핵심함수 2017. 5. 7. (+)
    private func solveShuffledQuestion(question : Question) -> Bool {
        var quetionShuffled : QuestionShuffled?
        
        quetionShuffled = QuestionShuffled(question: question, showLog: false)
        
        guard let qShuWrapped = quetionShuffled else {
            print("\(question.key) 문제는 변형할 수 없음")
            return false
        }
        
        QShufflingManager(outputManager: outputManager, qShuffled: qShuWrapped).publish(showAttribute: true, showAnswer: true, showTitle: false, showOrigSel: true)
        
        print("정답은? $ ", terminator : "")
        input = getInput()
        if Int(input) == (quetionShuffled?.getAnswerNumber())! + 1 {
            print("정답!", terminator: "")
        } else {
            //(+)자꾸 오답이라서 정답출력할 때 optional이 출력되는데 추후 확인 필요 2017. 4. 29. 수정완료 2017. 5. 8.
            print("오답임...정답은")
            print("   \(((quetionShuffled?.getAnswerNumber())! + 1).roundInt) \(qShuWrapped.getModfiedStatementOfCommonStatement(statement: qShuWrapped.answerSelectionModifed).content.spacing(3))")
            print("확인??", terminator: "")
        }
        print("-계속(),노트(n),태그(t),중단(s) $ ", terminator: "")
        input = getInput()
        if input.caseInsensitiveCompare("n") == ComparisonResult.orderedSame || input == "ㅜ" {
            print("노트를 입력하세요>", terminator: "")
            input = getInput()
        } else if input.caseInsensitiveCompare("t") == ComparisonResult.orderedSame || input == "t" {
            print("태그를 입력하세요>", terminator: "")
            // 데이터 추가 필요 2017. 5. 6. (+)
        } else if input.caseInsensitiveCompare("s") == ComparisonResult.orderedSame || input == "ㄴ" {
            print(question.key, "문제 변형을 중단함")
            return false
        }
        return true
    }
    
    func selectTestCategory(_ database : TestDatabase) -> TestCategory? {
        
        let categoryCount = testDatabase.categories.count
        
        if categoryCount == 0 {
            print("\(database.key)에 아무 시험이 없음")
            return nil
        }
        
        for (index,testCategory) in database.categories.enumerated() {
            print("[\(index+1)] : \(testCategory.key)")
        }
        
        var selectedCategoryIndex : Int = -1
        var goon = true
        while goon {
            print("시험명 선택(1~\(categoryCount))$ ", terminator : "")
            let input = readLine()
            
            guard let inputWrapped = input else {
                print(">올바르지 않은 입력, 재입력하세요.")
                continue
            }
            
            let number = Int(inputWrapped)
            if number == nil {
                print(">숫자를 입력하세요")
                continue
            }
            
            if number! - 1 < 0 || number! - 1 >= categoryCount {
                print(">시험 과목번호 범위에 맞는 숫자를 입력하세요")
                continue
            }
            
            goon = false
            selectedCategoryIndex = number!
        }
        
        
        return database.categories[selectedCategoryIndex-1]
    }
    
    func selectTestSubject(_ selectedCategoryUnwrapped : TestCategory?) -> TestSubject? {
        
        guard let selectedCategory = selectedCategoryUnwrapped else {
            return nil
        }
        
        let subjectCount = selectedCategory.testSubjects.count
        
        if subjectCount == 0 {
            print(">\(selectedCategory.key)에 시험과목이 하나도 없음")
            return nil
        }
        
        for (index,test) in selectedCategory.testSubjects.enumerated() {
            print("(\(index+1)) : \(test.key)")
        }
        
        var selectedSubjectIndex : Int = -1
        var goon = true
        while goon {
            print("시험과목 선택(1~\(subjectCount))$ ", terminator : "")
            let input = readLine()
            
            guard let inputWrapped = input else {
                print(">올바르지 않은 입력, 재입력하세요.")
                continue
            }
            
            let number = Int(inputWrapped)
            if number == nil {
                print(">숫자를 입력하세요")
                continue
            }
            
            if number! - 1 < 0 || number! - 1 >= subjectCount {
                print(">시험 과목번호 범위에 맞는 숫자를 입력하세요")
                continue
            }
            
            goon = false
            selectedSubjectIndex = number!
        }
        
        return selectedCategory.testSubjects[selectedSubjectIndex-1]
    }
    
    // 사용자로부터 입력을 받아서 데이터베이스 안의 시험을 선택하는 함수
    // 시험이 하나도 없을 경우 nil반환
    private func selectTest(_ selectedSubjectUnwrapped : TestSubject?) -> Test? {
        
        guard let selectedSubject = selectedSubjectUnwrapped else {
            return nil
        }
        
        let testCount = selectedSubject.tests.count
        
        if testCount == 0 {
            print(">\(selectedSubject.key)에 시험이 하나도 없음")
            return nil
        }
        
        for (index,test) in selectedSubject.tests.enumerated() {
            print("[\(index+1)] : \(test.key)")
        }
        
        
        //input이 0~ 정수로 입력받았는지 확인하는 로직 필요함 2017. 4. 26.(-)
        //노가다 및 Int(String)으로 완성 2017. 5. 6.
        
        var selectedTest : Int = -1
        var goon = true
        while goon {
            print("시험회차 선택(1~\(testCount))$ ", terminator : "")
            let input = readLine()
            
            guard let inputWrapped = input else {
                print(">올바르지 않은 입력, 재입력하세요.")
                continue
            }
            
            let testNumber = Int(inputWrapped)
            if testNumber == nil {
                print(">숫자를 입력하세요")
                continue
            }
            
            if testNumber! - 1 < 0 || testNumber! - 1 >= testCount {
                print(">시험번호 범위에 맞는 숫자를 입력하세요")
                continue
            }
            
            goon = false
            selectedTest = testNumber!
        }
        return selectedSubject.tests[selectedTest-1]
    }
    
    private func selectQuestion(_ selectedTestUnwrapped: Test?) -> Question? {

        guard let selectedTest = selectedTestUnwrapped else {
            return nil
        }
        
        var selectedQuestions = selectedTest.questions
        if selectedQuestions.count == 0 {
            print("\(selectedTest.key)에 문제가 하나도 없음")
            return nil
        }
        
        for question in selectedQuestions {
            print("[\(question.number)] : \(question.key)")
        }
        
        
        var goon = true
        while goon {
            print("문제번호 선택 $ ", terminator : "")
            let input = readLine()
            
            guard let inputWrapped = input else {
                print("올바르지 않은 입력, 재입력하세요.")
                continue
            }
            
            let questionNumber = Int(inputWrapped)
            if questionNumber == nil {
                print("숫자를 입력하세요")
                continue
            }
            selectedQuestions = selectedQuestions.filter({$0.number == questionNumber})
            if selectedQuestions.isEmpty {
                print("숫자를 입력하세요")
                continue
            }
            goon = false
        }
        
        return selectedQuestions[0]
    }
    
    private func createQuestion() {
    /*
        print("문제코드 입력>", terminator : "")
        let questionKey = readLine()!
        print("문제유형 입력>", terminator : "")
        let questionTypeSting =  readLine()!
        let questionType : QuestionType

        switch questionTypeSting {
        case "SO":
        questionType = QuestionType.SO
        case "SX":
        questionType = QuestionType.SX
        case "SC":
        questionType = QuestionType.SC
        case "SD":
        questionType = QuestionType.SD
        case "so":
        questionType = QuestionType.SO
        case "sx":
        questionType = QuestionType.SX
        case "sc":
        questionType = QuestionType.SC
        case "sd":
        questionType = QuestionType.SD
        default:
        questionType = QuestionType.SX
        }

        print("문제 입력>", terminator : "")
        let content = readLine()!
        print("문제반대 입력>", terminator : "")
        let contentControversal = readLine()!
        //database.qustions.append(Question(questionKey: questionKey, questionType: questionType, content: content, contentControversal: contentControversal))

        print("문항번호 입력>", terminator : "")
        let selctionNO = readLine()!
        print("\(selctionNO)의 내용 입력>", terminator : "")
        let selectionContent = readLine()!
        //database.testSelctions.append(TestSelction(selectNumber: selctionNO, content: selectionContent))
        }
        if input == "sqr" || input == "ㄴㅂㄱ" {
        for a in database.qustions {
        print(a.questionKey)
        print(a.content)
        print(a.questionType)
        }
        print(database.testSelctions)
    */
    }
    
    func getInput() -> String {
        var goon = true
        while goon {
            let inputRaw = readLine()
            
            
            guard let inputRawWrapped = inputRaw else {
                print(">유효하지 않은 입력\n")
                continue
            }
            
            input = inputRawWrapped.trimmingCharacters(in: .illegalCharacters)
            
            goon = false
            return input
        }
    }
}


