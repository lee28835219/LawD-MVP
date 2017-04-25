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
var inputManger = InputManager(inputTemp: "")
var database = Database()

//무한루프 시작
repeat {
    
    
    //질문 자동 초기화
    print("Intializing..")
    Question().publish()
    print("Intialization Complete")
//    Question().shuffle().publish()
    
    for index in 1...100 {
        print("---\(index)------")
        QuestionShuffled(question: Question()).publish()
    }
    
    //명령어 시작
    print(">>>>", terminator : "")
    input = readLine()
//    var result = inputManger.execute(input: input!, database: database)
    //명령어 끝
    
    
    
} while input != "exit"
//무한루프 끝 exit 입력 시 종료

print("bye!")


