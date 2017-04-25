//
//  Questions.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 3. 22..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class Question {
    let questionKey : String //Primary key, 원본
    let isPublished : Bool //기출, 원본
    let testDate : String //1701, 원본
    let testCategory : String //변시, 원본
    var testSubject : String //민사법, 원본
    var testQuestionNo : Int? //문제번호, 원본
    var testQuestionNote : String? //유니온문제번호 등 기타 정보, 원본
    var testSubjectDetail : String? //민법, 원본
    var questionType : QuestionType //원본
    var questionOX : QuestionOX //원본
    var content: String //원본
    var contentControversal : String? //원본
    var contentNote: String? //원본
    let answer: Int //불확실
    var selections = [TestSelction]() //원본
    var answerSelection: TestSelction? //변경
    
    init(questionKey : String, isPublished : Bool, testDate : String, testCategory : String, testSubject : String, questionType : QuestionType, questionOX : QuestionOX , content : String, answer : Int) {
        self.questionKey = questionKey
        self.isPublished = isPublished
        self.testCategory = testCategory
        self.testDate = testDate
        self.testSubject = testSubject
        self.questionType = questionType
        self.questionOX = questionOX
        self.content = content
        self.answer = answer
    }
    
    //문제와 선택지를 출판하는 함수
    func publish() {
        //문제
        print("[\(testSubject) \(testDate) \(testCategory)] "+content, terminator : "")
        if let contNote = contentNote {
            print(" "+contNote)
        } else {
            print("")
        }
        print("\(questionType) \(questionOX)")
        
        //선택지
        print("")
        for (index,sel) in selections.enumerated() {
            print((index+1).roundInt+" "+sel.content)
            print(sel.iscOrrect ?? "not sure")
        }
        
        //정답
        print("")
        print("<정답>")
        print(answerSelection != nil ? answer.roundInt + " " + answerSelection!.content : "정답없음")
    }
}

enum QuestionOX {
    case O //옳은 것
    case X //옳지 않은 것
    case Correct //맞는 것
    case Difference //다른 것
}

enum QuestionType {
    case Select // 고르시오
    case Find // 모두 고르시오
    case Define // ?
}


//http://stackoverflow.com/questions/34240931/creating-random-bool-in-swift-2
//Creating random Bool in Swift 2

extension Bool {
    static func random() -> Bool {
        return arc4random_uniform(2) == 0
    }
}

// 숫자 스트링 -> 라운드 숫자 스트링 변환, 뭔가 더 고급스러운 방법은 없는가? 2017. 4. 9.
extension Int {
    var roundInt : String {
        if self == 1 {
            return "①"
        }
        if self == 2 {
            return "②"
        }
        if self == 3 {
            return "③"
        }
        if self == 4 {
            return "④"
        }
        if self == 5 {
            return "⑤"
        }
        if self == 6 {
            return "⑥"
        }
        if self == 7 {
            return "⑦"
        }
        if self == 8 {
            return "⑧"
        }
        if self == 9 {
            return "⑨"
        }
        if self == 9 {
            return "⑩"
        }
        return self.description
    }
}
