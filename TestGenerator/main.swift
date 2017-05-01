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
    
    // db를 json으로 출력
//    print(database.createJsonObject() != nil ? database.createJsonObject()! : "")
//    guard let str = database.createJsonObject() else {
//        continue
//    }
//    for que in database.questions {
//        que.publish()
//        inputManger.solveShuffledQuestion(question: que, rep: 3)
//    }
    let sampleQuestion = database.questions[3]
    sampleQuestion.publish()
    inputManger.solveShuffledQuestion(question: sampleQuestion)

    
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


