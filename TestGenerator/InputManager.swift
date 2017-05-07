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
    
    let testDB : TestDB
    
    init(testDB : TestDB) {
        self.testDB = testDB
    }
    
    func execute(input : String) -> Bool? {
        
        if input == "" {
            return nil
        }
        
        if input.caseInsensitiveCompare("exit") == ComparisonResult.orderedSame || input == "ㄷㅌㅑㅅ" {
            return true
        }
        
        if input.caseInsensitiveCompare("queall") == ComparisonResult.orderedSame || input == "ㅂㅕㄷㅁㅣㅣ" {
            print("\(testDB.key)의 key를 모두출력")
            for test in testDB.tests {
                print("------------",test.key)
                for que in test.questions {
                    print("-------", que.key)
                    for sel in que.lists {
                        print("---",sel.key)
                    }
                    for sel in que.selections {
                        print("---",sel.key)
                    }
                }
            }
            return true
        }
        
        if input.caseInsensitiveCompare("keyall") == ComparisonResult.orderedSame || input == "ㅏㄷㅛㅁㅣㅣ" {
            print("\(testDB.key)의 key를 모두출력")
            for test in testDB.tests {
                print("------------",test.key)
                for que in test.questions {
                    print("-------", que.key)
                    for sel in que.lists {
                        print("---",sel.key)
                    }
                    for sel in que.selections {
                        print("---",sel.key)
                    }
                }
            }
            return true
        }
        
        if input.caseInsensitiveCompare("save") == ComparisonResult.orderedSame || input == "ㄴㅁㅍㄷ" {
            let data = testDB.createJsonObject()
            if let dataWrapped = data {
                _ = outputManager.saveFile(fileName: "testDB-\(testDB.key).json", data: dataWrapped)
            } else {
                print("TestDB \(testDB.key) JSON DATA 생성실패")
            }
            return true
        }
        
        
        if input.caseInsensitiveCompare("cq") ==  ComparisonResult.orderedSame || input == "ㅊㅂ" {
            //http://stackoverflow.com/questions/30532728/how-to-compare-two-strings-ignoring-case-in-swift-language
            createQuestion()
            
            return true
        }
        
        // 시험을 선택하여 문제당 5개의 변형문제를 진행
        if input.caseInsensitiveCompare("shufflet") ==  ComparisonResult.orderedSame  || input == "ㄴㅗㅕㄹㄹㅣㅅ" {
            let selectedTest = selectTest()
            
            guard let selectedTestWrapped = selectedTest else {
                print("선택한 시험을 찾을 수 없었음")
                return false
            }
            
            let selectedQuestions = selectedTestWrapped.questions
            
            if selectedQuestions.count == 0 {
                print("\(selectedTestWrapped.key) 시험에 문제가 없음")
                return false
            }
            
            for que in selectedQuestions {
                que.publish(showAttribute: true, showAnswer: true, showTitle: true, showOrigSel: false)
                print()
                print("[변형]" + que.key)
                for _ in 1...5 {
                    if !solveShuffledQuestion(question: que) {
                        return false
                    }
                }
            }
            return true
        }
        
        // 문제를 선택하여 10개의 변형문제를 진행
        if input.caseInsensitiveCompare("shuffleq") ==  ComparisonResult.orderedSame  || input == "ㄴㅗㅕㄹㄹㅣㄷㅂ" {
            
            let selectedTest = selectTest()
            guard let selectedTestWrapped = selectedTest else { return false }
            
            let selectedQuestion = selectQuestion(test: selectedTestWrapped)
            guard let selectedQuestionWrapped = selectedQuestion else { return false }
            
            selectedQuestionWrapped.publish(showAttribute: true, showAnswer: true, showTitle: true, showOrigSel: false)
            for _ in 1...10 {
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
        
        QShufflingManager(outputManager: outputManager, qShuffled: qShuWrapped).publish(showAttribute: false, showAnswer: false, showTitle: false, showOrigSel: false)
        
        print("정답은?>>", terminator : "")
        input = getInput()
        if Int(input) == (quetionShuffled?.getAnswerNumber())! + 1 {
            print("정답!", terminator: "")
        } else {
            //(+)자꾸 오답이라서 정답출력할 때 optional이 출력되는데 추후 확인 필요 2017. 4. 29.
            print("오답임...정답은")
            print("\(((quetionShuffled?.getAnswerNumber())! + 1).roundInt) \(qShuWrapped.getModfiedStatementOfCommonStatement(statement: qShuWrapped.answerSelectionModifed).content.spacing(3))")
            print("확인??", terminator: "")
        }
        print("-노트추가(n),태그(t),중단(s)>", terminator: "")
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
    
    // 사용자로부터 입력을 받아서 데이터베이스 안의 시험을 선택하는 함수
    // 시험이 하나도 없을 경우 nil반환
    private func selectTest() -> Test? {
        
        for (index,test) in testDB.tests.enumerated() {
            print("(\(index+1)) : \(test.key)")
        }
        
        let testCount = testDB.tests.count
        if testCount == 0 {
            print("TestDB \(testDB.key)에 시험이 없음")
            return nil
        }
        
        //input이 0~ 정수로 입력받았는지 확인하는 로직 필요함 2017. 4. 26.(-)
        //노가다 및 Int(String)으로 완성 2017. 5. 6.
        
        var selectedTest : Int = -1
        var goon = true
        while goon {
            print("출력할 시험번호(1~\(testCount))>", terminator : "")
            let input = readLine()
            
            guard let inputWrapped = input else {
                print("올바르지 않은 입력, 재입력하세요.")
                continue
            }
            
            let testNumber = Int(inputWrapped)
            if testNumber == nil {
                print("숫자를 입력하세요")
                continue
            }
            
            if testNumber! - 1 < 0 || testNumber! - 1 >= testCount {
                print("시험번호 범위에 맞는 숫자를 입력하세요")
                continue
            }
            
            goon = false
            selectedTest = testNumber!
        }
        return testDB.tests[selectedTest-1]
    }
    
    private func selectQuestion(test: Test) -> Question? {
        var selectedQuestions = test.questions
        if selectedQuestions.count == 0 {
            print("\(test.key)에 문제가 하나도 없음")
            return nil
        }
        
        for question in selectedQuestions {
            print("(\(question.number)) : \(question.key)")
        }
        
        
        var goon = true
        while goon {
            print("출력할 문제번호>", terminator : "")
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
            let input = readLine()
        
            guard let inputWrapped = input else {
                print(" 유효하지 않은 입력")
                continue
            }
            goon = false
            return inputWrapped
        }
    }
}
