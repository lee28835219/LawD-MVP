//
//  main.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 3. 22..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

print("Hello!TestGenerator Starts!")
var input : String

var testDB = TestDB()
var inputManger = InputManager(testDB : testDB)
let outputManager = OutputManager()

print("시작 -", Date().description)

//무한루프 시작
repeat {
    let dd = DC변호사시험민사법()
    
    
    //명령어
    print(">", terminator : "")
    input = inputManger.getInput()
    let result = inputManger.execute(input: input)
    
    
    switch result {
    case .some(true) :
        print("<\(input) 명령실행 성공!>")
    case .some(false) :
        print("<\(input) 명령실행 실패>")
    default :
        continue
    }
    
} while input != "exit"  && input != "ㄷㅌㅑㅅ"

//무한루프 끝 exit 입력 시 종료

print("bye!")


