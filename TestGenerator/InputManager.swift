//
//  InputManager.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 3. 22..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class InputManager {
    
    let testDatabase : TestDatabase
    let outputManager : OutputManager
    
    init(testDatabase : TestDatabase, outputManager : OutputManager) {
        self.testDatabase = testDatabase
        self.outputManager = outputManager
    }
    
    
    var helps = [
        "exit" : "exit"
        , "~~조회명령어" : "-"
        , "tcatall" : "tcatall"
        , "tsuball" : "tsuball"
        , "testall" : "testall"
        , "queall" : "queall"
        , "keyall" : "keyall"
        , "~~저장명령어" : "-"
        , "savet" : "savet"
        , "saveall" : "saveall"
        , "selta" : "selta"
        , "~~출력명령어" : "-"
        , "selt" : "시험"
        , "selqa" : "문제(정답포함)"
        , "selq" : "문제"
        , "~~문제변경" : "-"
        , "shuffles" : "과목"
        , "shufflet" : "시험"
        , "shuffleq" : "문제"
    ]
                
    func execute(_ input : String) -> Bool? {
        
        
        if isSame(input, targets: ["h","h"]) {
            
            for help in helps {
                print(help)
            }
            
            return true
        }
        
        
        
        if input == "" {
            return nil
        }
        
        
        
        if isSame(input, targets: ["exit","ㄷ턋"]) {
            return true
        }
        
        
        
        
        if isSame(input, targets: ["tcatall","ㅅㅊㅁㅅ미ㅣ"]) {
            
            print("\(testDatabase.key)의 시험카테고리 모두출력")
            
            for testCategory in testDatabase.categories {
                print(" |",testCategory.key)
            }
            return true
        }
        
        
        if isSame(input, targets: ["suball","녀ㅠ미ㅣ"]) {
            print("\(testDatabase.key)의 시험카테고리 모두출력")
            
            for testCategory in testDatabase.categories {
                print(" |",testCategory.key)
                for testSubject in testCategory.testSubjects {
                    print("  |",testSubject.key)
                }
            }
            return true
        }
        
        
        
        if isSame(input, targets: ["testall","ㅅㄷㄴㅅ미ㅣ"]) {
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
        
        
        
        if isSame(input, targets: ["queall","볃미ㅣ"]) {
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
        
        if isSame(input, targets: ["keyall","ㅏ됴미ㅣ"]) {
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
        
        if isSame(input, targets: ["savet","ㄴㅁㅍㄷㅅ"]) {
            
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
        
        if isSame(input, targets: ["saveall","ㄴㅁㅍㄷ미ㅣ"]) {
            
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
        
        
        if isSame(input, targets: ["selta","selt","ㄴ딧ㅁ","ㄴ딧"]) {
            
            var showAnswer = false
            if isSame(input, targets: ["selta","ㄴ딧ㅁ"]) {
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
        
        
        
        
        if isSame(input, targets: ["seltqa","seltq","ㄴ딧ㅂㅁ","ㄴ딧ㅂ"]) {
            
            var showAnswer = false
            if isSame(input, targets: ["selqa","ㄴㄷㅣㅂㅁ"]) {
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
        
        if isSame(input, targets: ["shuffles","노ㅕㄹ릳ㄴ"]) {
            let selectedSubject = selectTestSubject(selectTestCategory(testDatabase))
            
            guard let selectedSubjectWrapped = selectedSubject else {
                print("선택한 과목을 찾을 수 없었음")
                return false
            }
            
            var selectedQuestions = [Question]()
            
            for test in selectedSubjectWrapped.tests {
                selectedQuestions.append(contentsOf: test.questions)
            }
            
            if selectedQuestions.count == 0 {
                print(">\(selectedSubjectWrapped.key)에 문제가 하나도 없음")
                return false
            }
            
            _ = solveShuffledQuestions(selectedQuestions.shuffled())
            
            return true
        }
        
        
        
        // 시험을 선택하여 문제당 5개의 변형문제를 진행
        if isSame(input, targets: ["shufflet","노ㅕㄹ릳ㅅ"]) {
            let selectedTest = selectTest(selectTestSubject(selectTestCategory(testDatabase)))
            
            guard let selectedTestWrapped = selectedTest else {
                print("선택한 시험을 찾을 수 없었음")
                return false
            }
            
            let selectedQuestions = selectedTestWrapped.questions.shuffled()
            
            if selectedQuestions.count == 0 {
                print(">\(selectedTestWrapped.key)에 문제가 하나도 없음")
                return false
            }
            
            _ = solveShuffledQuestions(selectedQuestions.shuffled())
            
            return true
        }

        // 문제를 선택하여 10개의 변형문제를 진행
        if isSame(input, targets: ["shuffleq","노ㅕㄹ릳ㅂ"]) {
            
            let selectedTest = selectTest(selectTestSubject(selectTestCategory(testDatabase)))
    
            let selectedQuestion = selectQuestion(selectedTest)
            guard let selectedQuestionWrapped = selectedQuestion else { return false }
            
            selectedQuestionWrapped.publish(showAttribute: true, showAnswer: true, showTitle: true, showOrigSel: false)
            
            for _ in 1...5 {
                let result = solveShuffledQuestion(question: selectedQuestionWrapped)
                if !result.isShuffled {
                    return false
                }
            }
            return true
        }

        return false
    }
    
    
    //// 내부보조함수
    
    // 문제를 입력하면 변형하여 문제를 출력하고 입력을 받아서 정답을 체크하는 함수
    // 변경문제에 대하여 문제변경이 성공하면 진행하지만, 실패하면 false를 반환
    // 1. 노트추가나 태그추가, 2. 문제변경 기능에 대해서 만들어내도록 기능추가해야할 핵심함수 2017. 5. 7. (+)
    func solveShuffledQuestion(question : Question) -> (isShuffled : Bool, isRight : Bool, questionShuffled : QuestionShuffled?) {
        
        var isRight = false
        var quetionShuffled : QuestionShuffled?
        
        quetionShuffled = QuestionShuffled(question: question, showLog: false)
        
        guard let qShuWrapped = quetionShuffled else {
            print("\(question.key) 문제는 변형할 수 없음")
            return (false, isRight, quetionShuffled)
        }
        

        
        QShufflingManager(outputManager: outputManager, qShuffled: qShuWrapped).publish(showAttribute: false, showAnswer: false, showTitle: true, showOrigSel: false)
        
        
        
        print("정답은? $ ", terminator : "")
        input = getInput()
        
        if Int(input) == (quetionShuffled?.getAnswerNumber())! + 1 {
            print("정답!", terminator: "")
            isRight = true
        } else {
            //(+)자꾸 오답이라서 정답출력할 때 optional이 출력되는데 추후 확인 필요 2017. 4. 29. 수정완료 2017. 5. 8.
            print("오답임...정답은")
            print("   \(((quetionShuffled?.getAnswerNumber())! + 1).roundInt) \(qShuWrapped.getModfiedStatementOfCommonStatement(statement: qShuWrapped.answerSelectionModifed).content.spacing(3))")
            print("확인??", terminator: "")
        }
        
        
        
        print("-계속(),노트(n),태그(t),문제수정(m),중단(s) $ ", terminator: "")
        input = getInput()
        
        if input.caseInsensitiveCompare("n") == ComparisonResult.orderedSame || input == "ㅜ" {
            print("노트를 입력하세요>", terminator: "")
            input = getInput()
        } else if input.caseInsensitiveCompare("t") == ComparisonResult.orderedSame || input == "t" {
            print("태그를 입력하세요>", terminator: "")
            // 데이터 추가 필요 2017. 5. 6. (+)
            let tagInput = getInput()
            print("> 태그(\(tagInput)) 입력완료~")
            _ = readLine()
            print()
        } else if input.caseInsensitiveCompare("m") == ComparisonResult.orderedSame || input == "ㅡ" {
            question.publish(showAttribute: true, showAnswer: true, showTitle: true, showOrigSel: false)
            print()
            print("<반전된 문제>")
            question.controversalPublish()
            print()
            modifyQuestion(question)
        } else if input.caseInsensitiveCompare("s") == ComparisonResult.orderedSame || input == "ㄴ" {
            print(question.key, "문제 변형을 중단함")
            return (true, isRight, quetionShuffled)
        }
        
        
        return (true, isRight, quetionShuffled)
    }
    
    
    // 유효한 입력을 받는 보조함수
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
    
    
    // content를 수정하는 modifyQuestion의 보조함수
    func modifyControversalContent(name : String, content : String, contentOX : String, notContent : String?, targetNumber : String) -> String? {
        
        var result : String? = notContent
        
        print("\(targetNumber)")
        print(content, contentOX)
        print("\(targetNumber) (!!!반대)")
        var contentOXCont = contentOX
        if contentOXCont == "(O)" {
            contentOXCont = "(X)"
        } else if contentOXCont == "(X)" {
            contentOXCont = "(O)"
        }
        
        print((notContent != nil ? notContent! : "없음"),contentOXCont)
        
        print("-. 반대\(name) 신규입력 $ ")
        let inp = getInput()
        print()
        if inp == "" {
            print("> 아무것도 입력된 것이 없어 반대\(name) 변경없음")
        } else {
            result = inp
            print("> 반대\(name) 입력완료 : \(targetNumber) \(result!)", contentOXCont)
        }
        print("계속()다시(r) $ ", terminator: "")
        let iinp = getInput()
        if iinp == "r" || iinp == "ㄱ" {
            return modifyControversalContent(name : name, content : content, contentOX : contentOX, notContent : notContent, targetNumber : targetNumber)
        }
        print()
        return result
        
        // 추가 디버깅 사항 2017. 5. 16. (+)
        // 1. 문제 반전사항출력(완료)), 2. 문제유형 반전해서 출력, 3. 목록 선택지 문제일 경우 선택지는 손대지 않음
        
    }
    
    
    // 사용자로부터 입력을 받아서 데이터베이스 안의 시험명, 과목, 시험회차, 문제를 선택하는 함수
    // 대상이 하나도 없을 경우 nil반환
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
    
    func selectTest(_ selectedSubjectUnwrapped : TestSubject?) -> Test? {
        
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
    
    func selectQuestion(_ selectedTestUnwrapped: Test?) -> Question? {
        
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
    
    
}




extension InputManager {
    
    
    func solveShuffledQuestions(_ questions : [Question]) -> [Question] {
        var wrongQuestions = [Question]()
        
        for (index,que) in questions.enumerated() {
            print("(\(index) / \(questions.count))")
            let result = solveShuffledQuestion(question: que)
            if !result.isShuffled {
                continue
            }
            if !result.isRight {
                wrongQuestions.append(que)
            }
        }
        if wrongQuestions.count == 0 {
            print(">총 \(questions.count) 문제 모두 맞춤-종료(),문제수정(m) $ ", terminator: "")
        } else {
            print(">총 \(questions.count) 문제 중 \(questions.count - wrongQuestions.count) 개 맞춤-종료(),다시풀기(r),틀린문제만 다시풀기(w) $ ", terminator: "")
        }
        let input = readLine()
        if input == "r" || input == "ㄱ" {
            wrongQuestions = solveShuffledQuestions(questions)
        }
        if (input == "w" && wrongQuestions.count != 0) || (input == "ㅈ" && wrongQuestions.count != 0){
            wrongQuestions = solveShuffledQuestions(wrongQuestions)
        }
        return wrongQuestions
    }
    
    
    
    func modifyQuestion(_ question: Question) {
        
        print("수정할 문제의 항목을 선택-모든 반전내용 자동입력(4),문제보기(show),종료(end) $ ", terminator:"")
        let input = getInput()
        
        switch input {
        case "end" :
            return
            
        case "show" :
            question.publish(showAttribute: true, showAnswer: true, showTitle: true, showOrigSel: false)
            print()
            print("<반전된 문제>")
            question.controversalPublish()
            modifyQuestion(question)
            return
            
        // 문제 수정을 시작
        case "4" :
            print()
            let listNumber = question.lists.count
            if listNumber != 0 {
                
                print("> 목록 \(listNumber)개 수정을 진행")
                for (index,list) in question.lists.enumerated() {
                    
                    print("> 질문 : \(question.content) (\(question.questionType)\(question.questionOX))")
                    print("> 목록지 \(index+1) / \(listNumber) 수정진행..")
                    list.notContent = modifyControversalContent(name: "목록지", content: list.content, contentOX: list.getOX(),notContent: list.notContent, targetNumber: list.getListString()+".")
                }
            }
            
            let selNumber = question.selections.count
            print("> 선택지 \(selNumber)개 수정을 진행")
            
            if question.questionType != .Find {
                for (index,sel) in question.selections.enumerated() {
                    
                    print("> 질문 : \(question.content) (\(question.questionType)\(question.questionOX))")
                    print("> 선택지 \(index+1) / \(selNumber) 수정진행..")
                    print("-. 선택지 : \(sel.number.roundInt)")
                    sel.notContent = modifyControversalContent(name: "선택지", content: sel.content, contentOX: sel.getOX(),notContent: sel.notContent, targetNumber: sel.number.roundInt)
                }
            }
            
            
        default:
            modifyQuestion(question)
            return
        }
        
        var goon = true
        while goon {
            print("<반전된 문제> - 변경됨")
            question.controversalPublish()
            
            print("변경사항을 저장?()-저장 후 계속(m),종료(e) $ ", terminator: "")
            
            guard let input = readLine() else {
                print("유효하지 않은 입력")
                continue
            }
            
            if input == "e" || input == "ㄷ" {
                
                print(">"+question.key+" 저장하지 않음")
                return
                
            } else if input == "m" || input == "ㅡ" {
                
                print(">"+question.key+" 저장완료")
                _ = outputManager.saveTest(question.test)
                modifyQuestion(question)
                return
            }
            
            print(">"+question.key+" 저장완료")
            _ = outputManager.saveTest(question.test)
            
            print("")
            goon = false
        }
    }

    
}

