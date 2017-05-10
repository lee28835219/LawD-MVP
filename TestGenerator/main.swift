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

var testDatabase = TestDatabase()
var testCategory = TestCategory(testDatabase: testDatabase, category: "변호사 시험 샘플(모의고사, 기출)")
var testSubject = TestSubject(testCategory: testCategory, subject: "민사법")

testSubject.setSampleTest()

let outputManager = OutputManager()
var inputManger = InputManager(testDatabase : testDatabase, outputManager : outputManager)

print("시작 -", Date().HHmmss)

let dddd = DCDD(testDatabase)

let barExam = DC변호사시험민사법(testDatabase)
let firstBarExam = DC법조윤리(testDatabase)
let HouseExam = DC공인중개사(testDatabase)


//무한루프 시작
repeat {
    //명령어
    print("$ ", terminator : "")
    
    input = inputManger.getInput()
    let result = inputManger.execute(input)
    
    
    switch result {
    case .some(true) :
        print(">>\(input) 명령실행 성공!")
    case .some(false) :
        print(">>\(input) 명령실행 실패")
    default :
        continue
    }
    
} while input != "exit"  && input != "ㄷㅌㅑㅅ"

//무한루프 끝 exit 입력 시 종료

print("bye!")


