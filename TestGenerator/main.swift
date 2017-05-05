//
//  main.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 3. 22..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

print("Hello!TextGenerator Starts!")
var input : String?
var database = Database()
var inputManger = InputManager(database : database)
print("Intialization Complete")
print("")


//무한루프 시작
repeat {
    
    
    print(database.tests.count)
    
    for test in database.tests {
        print("------------",test.key)
        for que in test.questions {
            print("-------", que.key)
            for sel in que.listSelections {
                print("--",sel.key)
            }
            for sel in que.selections {
                print("--",sel.key)
            }
        }
    }
    
//    let que = database.questions[0]
//    que.publish(showAttribute: true, showAnswer: true, showTitle: true, showOrigSel: true)
//    
//    
//    let qs = QuestionShuffled(question: que)
//
//    qs?.publish()
//    
//    let question = qs?.question
//    var answerSelectionModifed = qs?.answerSelectionModifed
//    var selectionsShuffled = qs?.selectionsShuffled
//    
//    var doesQuestionOXChanged = qs?.doesQuestionOXChanged
//    var doesQuestionAnswerChanged = qs?.doesQuestionAnswerChanged
//    
//    print("question\(question)")
//    print("answerSelectionModifed\(answerSelectionModifed)")
//    print("selectionsShuffled\(selectionsShuffled)")
//    print("doesQuestionOXChanged\(doesQuestionOXChanged)")
//    print("doesQuestionAnswerChanged\(doesQuestionAnswerChanged)")
//    
//    let newQS = QuestionShuffled(question: que)
//    newQS?.publish()
//    newQS?.answerSelectionModifed = answerSelectionModifed!
//    newQS?.selectionsShuffled = selectionsShuffled!
//    newQS?.doesQuestionAnswerChanged = doesQuestionAnswerChanged!
//    newQS?.doesQuestionOXChanged = doesQuestionOXChanged!
//    
//    newQS?.publish()
    
    
    
    // db를 json으로 출력
//    print(database.createJsonObject() != nil ? database.createJsonObject()! : "")
//    guard let str = database.createJsonObject() else {
//        continue
//    }
//    for que in database.questions {
//        que.publish()
//        inputManger.solveShuffledQuestion(question: que, rep: 3)
//    }
//    let sampleQuestion = database.questions[3]
//    sampleQuestion.publish()
//    inputManger.solveShuffledQuestion(question: sampleQuestion)
    
//    let 법조윤리 = DC법조윤리()
//    database.tests = 법조윤리.시험들
//    print("--법조윤리 파싱 complete")
//    for te in 법조윤리.시험들 {
//        print("ooooo")
//        print("[",te.category,"-",te.subject,"-",te.number,"회 ]")
//    }
    
    
//    let ques = 법조윤리.시험들[4]
//    
//    for que in ques.questions {
//        QuestionShuffled(question: que)?.publish()
//    }
    
    //명령어
    print(">>>>", terminator : "")
    input = readLine()
    
    guard let inp = input else {
        print("유효하지 않은 입력")
        continue
    }
    let re = inputManger.execute(input: inp)
    
} while input != "exit"
//무한루프 끝 exit 입력 시 종료

print("bye!")


