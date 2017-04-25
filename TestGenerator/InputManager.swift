//
//  InputManager.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 3. 22..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

struct InputManager {
    let inputTemp : String
//    var testSelectionTemp : TestSelctions
    /*
    func execute(input : String, database : Database) -> Bool {
        if input == "sq" || input == "ㄴ ㅂ" { //문제입력 명령
            print("문제코드 입력>", terminator : "")
            let questionKey = readLine()!
            print("문제유형 입력>", terminator : "")
            let questionTypeSting =  readLine()!
            let questionType : QuestionType
            /*
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
 */
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
        }
    return true
    }
 */
    
}
