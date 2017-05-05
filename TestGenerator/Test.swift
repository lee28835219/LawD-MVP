//
//  Test.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 3..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//
import Foundation

class Test {
    //내가 무엇인지
    let testDB : TestDB?
    var key : String
    
    //나의 속성은 어떤지
    var isPublished : Bool //기출, 원본
    let category : String //변호사시험
    let catHelper : String? = nil //모의
    let subject : String //민사법
    let number : Int
    var numHelper : Int? = nil
    
    var description : String? = nil
    var string : String? = nil
    
    var date : Date //1701, 원본
    
    //내 식구들은 누구인지
    var questions = [Question]()
    
    init(testDB : TestDB?, isPublished: Bool, category: String, catHelper: String? = nil, subject: String, number: Int, numHelper: Int? = nil) {
        self.testDB = testDB
        self.isPublished = isPublished
        self.category = category
        self.subject = subject
        self.number = number
        self.date = Date()
        
        // 변호사시험.민사법.2017-001
        var str : String = ""
        if let catHelperWrapped = catHelper {
            str = self.category + "." + self.subject + "-" + catHelperWrapped
        } else {
            str = self.category + "." + self.subject
        }
        if let numHeplerWrapped = numHelper {
            str = str + "." + String(format: "%04d",numHeplerWrapped) + "-" + String(format: "%03d", self.number)
        } else {
            str = str + "." + String(format: "%03d", self.number)
        }
        
        self.key = str
        
        if testDB != nil {
            if !testDB!.tests.filter({$0.key == str}).isEmpty {
                fatalError("잘못된 시험key 입력 : 이미 \(testDB!.name)에 \(str)이 존재함")
            }
            testDB!.tests.append(self)
        }
        
    }
}




extension Date {
    var yyyymmdd : String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. dd. mm."
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}
