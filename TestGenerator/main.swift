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

//무한루프 시작
repeat {
    
    var database = Database()
    print("Intialization Complete")
    print("")
    
    let question = database.questions[0] as Question
    
    question.publish()
    for index in 1...1 {
        print("")
        print("---\(index)------")
        QuestionShuffled(question: question).publish()
    }
    
    //명령어 시작
    print(">>>>", terminator : "")
    input = readLine()
    //명령어 끝
    
} while input != "exit"
//무한루프 끝 exit 입력 시 종료

print("bye!")


