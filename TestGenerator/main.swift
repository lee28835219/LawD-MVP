//
//  main.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 3. 22..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

print("Hello! LawD Console System Starts!")
print("\(#file) 시작 -", Date().HHmmSS)


if CommandLine.argc > 1 {
    if CommandLine.arguments[1] == "debug" {
        ConsoleIO.isDebug = true
    }
}


let g_testDatabase = TestDatabase(UUID())
let g_storageManager = StorageManager(g_testDatabase)
print(g_storageManager.log)
//let g_new_storageManager = StorageManager(g_testDatabase)
//print(g_new_storageManager.log)
let g_outputManager = OutputManager()


let books = Books(sequence: 1, name: "basic", value: "ver1")

let g_instrcutionManger = InstManagerMain(testDatabase : g_testDatabase, outputManager : g_outputManager, storageManager : g_storageManager, books : books)






var temp_testCategory = TestCategory(testDatabase: g_testDatabase, category: "변호사 시험 샘플(모의고사, 기출)")
var temp_testSubject = TestSubject(testCategory: temp_testCategory, subject: "민사법")
temp_testSubject.setSampleTest()





//
let dddd = DCDD(g_testDatabase)
//
//let barExam = DC변호사시험(g_testDatabase)
//print(barExam!.log)
//let firstBarExam = DC법조윤리(g_testDatabase)
//print(firstBarExam!.log)
//let HouseExam = DC공인중개사(g_testDatabase)
//print(HouseExam!.log)
//let barExamCivle6Mod = DC변호사시험_6회_민법정답수정(g_testDatabase)
//print(barExamCivle6Mod!.log)

//let barExamConstitOX = DC변호사시험헌법OX(g_testDatabase)
//print(barExamConstitOX!.log)


//let oldBarExam = DC사법시험(g_testDatabase)
//print(oldBarExam!.log)


//g_testDatabase.refreshTags()

//g_testDatabase.modifyAnswer(_변호사민사1회5회정답수정().value)


//g_testDatabase.doingSomeStuffRelatedWithQuestion()

//print(g_testDatabase.log)


let findedQuestionInstance = Question.findInstance(testDatabase: g_testDatabase, id: UUID(uuidString: "9A8B8074-9A6D-415A-A1F1-F54EF01844B8"))
MainDevEXE(toExecute: true)

//// EXEC
g_instrcutionManger.didInitializationComplete()


print("bye!")
