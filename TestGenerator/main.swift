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
    //명령어
    print(">>>>", terminator : "")
    input = readLine()
    
    if let inp = input {
        let re = inputManger.execute(input: inp)
    }
    
} while input != "exit"
//무한루프 끝 exit 입력 시 종료

print("bye!")


