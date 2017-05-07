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
    let testDB : TestDB
    
    //나의 속성은 어떤지
    let createDate : Date = Date()
    
    var isPublished : Bool //기출, 원본
    let category : String //변호사시험
    let catHelper : String //모의
    let subject : String //민사법
    let number : Int
    let numHelper : Int
    var date : Date? //1701, 원본
    
    var raw : String = ""
    
    //내 식구들은 누구인지
    var questions = [Question]()
    
    init(testDB : TestDB, isPublished: Bool, category: String, catHelper: String? = nil, subject: String, number: Int, numHelper: Int? = nil) {
        self.testDB = testDB
        self.isPublished = isPublished
        self.category = category
        if catHelper == nil {
            self.catHelper = ""
        } else {
            self.catHelper = catHelper!
        }
        self.subject = subject
        self.number = number
        self.date = Date()
        if numHelper == nil {
            self.numHelper = 0
        } else {
            self.numHelper = numHelper!
        }
        
        // 변호사시험.민사법.2017-001
        var str : String = ""
        if isPublished {
            str = str + "[기출]"
        } else {
            str = str + "[변형]"
        }
        if let catHelperWrapped = catHelper {
            str = str + self.category + "-" + catHelperWrapped + "." + self.subject
        } else {
            str = str + self.category + "." + self.subject
        }
        if let numHeplerWrapped = numHelper {
            str = str + "." + String(format: "%04d",numHeplerWrapped) + "-" + String(format: "%03d", self.number)
        } else {
            str = str + "." + String(format: "%03d", self.number)
        }
        
        super.init(str)
    }
}
