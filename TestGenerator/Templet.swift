//
//  Templet.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 7..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

// 이건 뭐하는 구조체인가? 2023. 7. 7. (-)
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
        
        var selections : [Templet.Selection] = [Templet.Selection(), Templet.Selection(), Templet.Selection(), Templet.Selection(), Templet.Selection()] // 이런식으로 초기화 가능할까???, 추가로 좀더 다양한 선택지 추가는 불가능할지? 2023. 7. 7. (-)
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
        
        var iscOrrect : Bool? = nil // 필수인데 여기선 빼놓고 지나갔었음, 추가함 2017. 5. 23.
        var isAnswer : Bool? = false  // 필수인데 여기선 빼놓고 지나갔었음
    }
}
