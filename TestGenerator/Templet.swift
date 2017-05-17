//
//  Templet.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 7..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

struct Templet {
    struct TestCategory {
        var specification : String = ""
        
        var category : String = ""
        var catHelper : String? = nil
        
        var raw : String = ""
        
        var testSubjects : [Templet.TestSubject] = []
    }
    
    struct TestSubject {
        var specification : String = ""
        var subject : String = ""
        
        var tests : [Templet.Test] = []
    }
    
    struct Test {
        var revision : Int = 0
        var specification : String = ""
        
        var number : Int = 0
        var numHelper : Int? = nil
        var date : Date?
        
        var raw : String = ""
        
        var answers : [Templet.Answer] = []
        var questions : [Templet.Question] = []
    }
    
    struct Answer {
        var questionNumber : Int = 0
        var answer : Int = 0
    }
    
    struct Question {
        var revision : Int = 0
        
        var specification : String = ""
        
        var number : Int = 0
        var subjectDetails = [String]()
        
        var questionType : QuestionType
        var questionOX : QuestionOX
        
        var contentPrefix : String?
        
        var content: String = ""
        var notContent : String?
        var contentNote: String?
        
        var questionSuffix : String?
        
        var passage : String?
        var passageSuffix : String?
        
        var answer: Int = 0
        
        var raw : String = ""
        var rawSelections : String = ""
        var rawLists : String = ""
        
        var selections : [Templet.Selection] = []
        var lists : [Templet.List] = []
    }
    
    struct Selection {
        var revision : Int = 0
        var specification : String = ""
        
        var content : String = "대한민국의 주권은 국민에게 있고, 모든 권력은 국민으로부터 나온다."
        var notContent : String?
        var number : Int = 0
        
        var iscOrrect : Bool?
        var isAnswer : Bool? = false
    }
    
    struct List {
        var revision : Int = 0
        var specification : String = ""
        
        var content : String = "대한민국의 주권은 국민에게 있고, 모든 권력은 국민으로부터 나온다."
        var notContent : String?
        
        var listStringType : SelectStringType = .koreanCharcter
        var number : Int = 0
    }
}
