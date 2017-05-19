//
//  main.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 3. 22..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

print("Hello!TestGenerator Starts!")
print("\(#file) 시작 -", Date().HHmmSS)


if CommandLine.argc > 1 {
    if CommandLine.arguments[1] == "debug" {
        ConsoleIO.isDebug = true
    }
}


let g_testDatabase = TestDatabase()
let g_storageManager = StorageManager(g_testDatabase)
let g_outputManager = OutputManager()
let g_instrcutionManger = InstructionManager(testDatabase : g_testDatabase, outputManager : g_outputManager)

print(g_storageManager.log)




var temp_testCategory = TestCategory(testDatabase: g_testDatabase, category: "변호사 시험 샘플(모의고사, 기출)")
var temp_testSubject = TestSubject(testCategory: temp_testCategory, subject: "민사법")
temp_testSubject.setSampleTest()


//
//let dddd = DCDD(g_testDatabase)
//
//let barExam = DC변호사시험(g_testDatabase)
//print(barExam!.log)
//let firstBarExam = DC법조윤리(g_testDatabase)
//print(firstBarExam!.log)
//let HouseExam = DC공인중개사(g_testDatabase)
//print(HouseExam!.log)


//// EXEC
g_instrcutionManger.didInitializationComplete()

print("bye!")



