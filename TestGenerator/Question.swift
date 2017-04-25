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
    
    //기본 문제생성, 법인 아닌 사단
    convenience init() {
        self.init(questionKey : "TESTCVA00025", isPublished : true, testDate : "1701", testCategory: "변시", testSubject: "민사법", questionType: QuestionType.Select, questionOX : QuestionOX.X , content : "법인 아닌 사단에 관한 설명 중 옳지 않은 것은?", answer : 5)
        self.contentControversal = "법인 아닌 사단에 관한 설명 중 옳은 것은?"
        self.contentNote = "(다툼이 있는 경우 판례에 의함)"
        
        // 1번, 옳은 지문
        let selectionVeryFirst1 = TestSelction(question: self, selectNumber: 1, content: "법인 아닌 사단의 사원이 존재하지 않게 된 경우에도 그 법인 아닌 사단은 청산사무가 완료될 때까지 청산의 목적범위 내에서 권리의무의 주체가 된다.")
        // 2번, 옳은 지문
        let selectionVeryFirst2 = TestSelction(question: self, selectNumber: 2, content: "법인 아닌 사단의 대표자가 정관에 규정된 대표권 제한에 위반하여 법률행위를 한 경우, 그 상대방이 대표권 제한 및 그 위반 사실을 알았거나 과실로 인해 알지 못한 때에는 그 법률행위는 무효이다.")
        // 3번, 옳은 지문
        let selectionVeryFirst3 = TestSelction(question: self, selectNumber: 3, content: "법인 아닌 사단의 정관에 특별한 규정이 없는 경우 법인 아닌 사단의 대표자가 타인 간의 금전채무를 보증하기 위해 사원총회 결의를 거칠 필요는 없다.")
        // 4번, 옳은 지문
        let selectionVeryFirst4 = TestSelction(question: self, selectNumber: 4, content: "법인 아닌 사단의 총회 소집권자가 총회 소집을 철회하는 경우 반드시 총회 소집과 동일한 방식으로 통지해야 할 필요는 없고, 총회 구성원들에게 소집 철회의 결정이 있었음이 알려질 수 있는 적절한 조치를 취하는 것으로 충분하다.")
        // 5번, 틀린 지문, 정답
        let selectionVeryFirst5 = TestSelction(question: self, selectNumber: 5, content: "법인 아닌 사단의 채권자가 채권자대위권에 기하여 법인 아닌 사단의 총유재산에 대한 권리를 대위행사하는 경우, 사원총회의 결의 등 법인 아닌 사단의 내부적 의사결정 절차를 거쳐야 한다.")
        
        // 1번 지문 반전, 틀린지문
        selectionVeryFirst1.contentControversal = "법인 아닌 사단의 사원이 존재하지 않게 된 경우에는 그 법인 아닌 사단은 사단이 소멸하여 소송상의 당사자능력을 상실한다."
        // 2번 지문 반전, 틀린지문
        selectionVeryFirst2.contentControversal = "법인 아닌 사단의 대표자가 정관에 규정된 대표권 제한에 위반하여 법률행위를 한 경우, 그 상대방이 대표권 제한 및 그 위반 사실을 알았거나 과실로 인해 알지 못한 때에도 그 법률행위는 유효하다."
        // 3번 지문 반전, 틀린지문
        selectionVeryFirst3.contentControversal = "법인 아닌 사단의 정관에 특별한 규정이 없는 경우라도 법인 아닌 사단의 대표자가 타인 간의 금전채무를 보증하기 위해서는 사원총회 결의를 거쳐야 한다."
        // 4번 지문 반전, 틀린지문
        selectionVeryFirst4.contentControversal = "법인 아닌 사단의 총회 소집권자가 총회 소집을 철회하는 경우 반드시 총회 소집과 동일한 방식으로 통지해야 한다."
        // 5번 지문 반전, 틀린지문
        selectionVeryFirst5.contentControversal = "법인 아닌 사단의 채권자가 채권자대위권에 기하여 법인 아닌 사단의 총유재산에 대한 권리를 대위행사하는 경우, 사원총회의 결의 등 법인 아닌 사단의 내부적 의사결정 절차를 거칠 필요가 없다."
    }

    
    //문제와 선택지를 출판하는 함수
    func publish() {
        print("[\(testSubject) \(testDate) \(testCategory)] "+content, terminator : "")
        if let contNote = contentNote {
            print(" "+contNote)
        } else {
            print("")
        }
        print("\(questionType) \(questionOX)")
        for (index,sel) in selections.enumerated() {
            print((index+1).roundInt+" "+sel.content)
            print(sel.iscOrrect ?? "not sure")
        }
        
        print(answerSelection != nil ? "정답 : " + answer.roundInt + " " + answerSelection!.content : "정답없음")
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
