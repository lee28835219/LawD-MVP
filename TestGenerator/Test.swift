//
//  Test.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 3..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//
import Foundation

class Test : DataStructure {
    //내가 무엇인지
    let testSubject : TestSubject
    var revision : Int
    
    //나의 속성은 어떤지
    var createDate : Date
    
    var isPublished : Bool //기출, 원본
    let number : Int
    let numHelper : Int?
    var date : Date? //1701, 원본
    
    var raw : String = ""
        
    //내 식구들은 누구인지
    var questions = [Question]()
    
    // 아카이브 하지않는 파싱 및 디버깅 에서만 사용하는 임시함수
    var jsonFileName : String? = nil
    
    init(createDate : Date, testSubject : TestSubject, revision : Int, isPublished: Bool, number: Int, numHelper: Int? = nil) {
        self.createDate = createDate
        self.testSubject = testSubject
        self.revision = revision
        
        self.isPublished = isPublished
        self.number = number
        self.date = Date()
        self.numHelper = numHelper
        
        
        
        var str = testSubject.key
        
        if let numHeplerWrapped = numHelper {
            str = str + "=" + String(format: "%04d",numHeplerWrapped) + "-" + String(format: "%03d", self.number)
        } else {
            str = str + "=" + String(format: "%03d", self.number)
        }
        
        for test in testSubject.tests {
            if test.key == str {
                fatalError("\(str)과 똑같은 시험이 이미 testDB \(testSubject.key)에 있음")
            }
        }
        
        super.init(UUID(), str)
        testSubject.tests.append(self)
    }
    
    // key를 대체하기 위해 각기 시험에 따라 이에 걸맞게 직관적인 시험의 이름을 생성 2023. 6. 25.
    func getKeySting() -> String {
        var str = ""
        switch testSubject.testCategory.category {
        case "변호사시험":
            str += "[변시] \(testSubject.subject) 제\(self.number)회"
        case "★MVP 시연용★":
            str += "★MVP 시연용★"
        default:
            str += key
        }
        
        return str
    }
}
