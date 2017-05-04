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
    
    let que = database.questions[3]
//    que.publish()
    que.publish(showAttribute: true, showAnswer: true)
    
    
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
////    database.tests = 법조윤리.시험들
//    print("--법조윤리 파싱 complete")
////    for te in 법조윤리.시험들 {
////        print("ooooo")
////        print("[",te.category,"-",te.subject,"-",te.number,"회 ]")
////    }
    
    
//    let que = 법조윤리.시험들[6].questions[38]
//
//    que.publish()
//    
//    let queShu = QuestionFindTypeShuffled(question: que)
//    
//    queShu?.publish()
    
    
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


