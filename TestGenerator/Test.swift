//
//  Test.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 3..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

class Test {
    let category : String //변호사시험
    let subject : String //민사법
    let number : Int
    
    var description : String? = nil
    var string : String? = nil
    
    var isPublished : Bool = true //기출, 원본
    var testDate : String = "N/A" //1701, 원본
    
    var questions = [Question]()
    
    init(category: String, subject: String, number: Int) {
        self.category = category
        self.subject = subject
        self.number = number
    }
}
