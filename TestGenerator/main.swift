//
//  main.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 3. 22..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

print("Hello!TestGenerator Starts!")

let testDatabase = TestDatabase()
let storageManager = StorageManager(testDatabase)
print(storageManager.log)


let outputManager = OutputManager()
let instrcutionManger = InstructionManager(testDatabase : testDatabase, outputManager : outputManager)


if CommandLine.argc > 1 {
    if CommandLine.arguments[1] == "debug" {
        instrcutionManger.consoleIO.isDebug = true
    }
}

var testCategory = TestCategory(testDatabase: testDatabase, category: "변호사 시험 샘플(모의고사, 기출)")
var testSubject = TestSubject(testCategory: testCategory, subject: "민사법")
testSubject.setSampleTest()


let que = testDatabase.categories[1].testSubjects[0].tests[0].questions[0]
let a = Solver(que)
print(a.log)


instrcutionManger.didInitializationComplete()

print("bye!")



//var input : String


//





//getchar()

//
//
//print("\(#file) 시작 -", Date().HHmmSS)
//
//let dddd = DCDD(testDatabase)
//
////let barExam = DC변호사시험(testDatabase)
////print(barExam!.log)
////let firstBarExam = DC법조윤리(testDatabase)
////print(firstBarExam!.log)
////let HouseExam = DC공인중개사(testDatabase)
//
//
////무한루프 시작
//
//
//
//
//
//
//
//repeat {
//    //명령어
//    print("$ ", terminator : "")
//    
//    input = inputManger.getInput()
//    let result = inputManger.execute(input)
//    
//    
//    switch result {
//    case .some(true) :
//        print(">>\(input) 명령실행 성공!")
//    case .some(false) :
//        print(">>\(input) 명령실행 실패")
//    default :
//        continue
//    }
//    
//} while input != "exit"  && input != "ㄷㅌㅑㅅ"

//무한루프 끝 exit 입력 시 종료

func newLog(_ file : String) -> String {
    return "\(file) 시작 \(Date().HHmmSS)\n"
}

func writeLog(_ log : String, funcName : String, outPut : String) -> String {
    return  log + "  \(funcName) : \(outPut)\n"
}

func closeLog(_ log : String, file : String) -> String {
    return log + "\(file) 종료 \(Date().HHmmSS)"
}

