//
//  InputManager.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 3. 22..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class InputManager {
    let testDB : TestDB
//    var testSelectionTemp : TestSelctions
    
    init(testDB : TestDB) {
        self.testDB = testDB
    }
    
    func execute(input : String) -> Bool {
        
        if input.caseInsensitiveCompare("sq") ==  ComparisonResult.orderedSame || input == "ㄴㅂ" {
            //http://stackoverflow.com/questions/30532728/how-to-compare-two-strings-ignoring-case-in-swift-language
            createQuestion()
        }
        
        // 100개의 문제를 만듬
        if input.caseInsensitiveCompare("ts") ==  ComparisonResult.orderedSame  || input == "ㅅㄴ" {
            
            print("출력할 문제번호(0~)>", terminator : "")
            let input = readLine()
            
            if Int(input!)! < testDB.tests[0].questions.count {
                
                //input이 0~ 정수로 입력받았는지 확인하는 로직 필요함 2017. 4. 26.(+)
                let question = selectQuestion(number : Int(input!)!)
                question.publish()
                
                solveShuffledQuestion(question : question)
            } else {
                print("선택한 문제가 없음")
            }
        }
        
        return true
    }
    
    func selectQuestion(number : Int) -> Question {
        let question = testDB.tests[0].questions[number] as Question
        return question
    }
    
    func solveShuffledQuestion(question : Question, rep: Int = 20) {
//        var quetionShuffled : QuestionShuffled?
//        
//        for index in 1...rep {
//            if question.questionType == QuestionType.Find {
////                quetionShuffled = QuestionFindTypeShuffled(question: question)
//            } else {
//                quetionShuffled = QuestionShuffled(question: question)
//            }
//            print("")
//            print("------\(index)------")
//            quetionShuffled?.publish()
//            print("정답은?>>", terminator : "")
//            input = readLine()
//            if Int(input!) == (quetionShuffled?.getAnswerNumber())! + 1 {
//                print("정답!")
//            } else {
//                //(+)자꾸 오답이라서 정답출력할 때 optional이 출력되는데 추후 확인 필요 2017. 4. 29.
//                print("오답...정답은 \(((quetionShuffled?.getAnswerNumber())! + 1).roundInt) \(quetionShuffled?.getModfiedStatement(statement: (quetionShuffled?.answerSelectionModifed)!).content)")
//                input = readLine()
//            }
//            print("다음문제~")
//        }
    }
    
    func createQuestion() {
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
}
