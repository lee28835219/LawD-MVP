//
//  TestSelections.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 3. 22..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

//선택지
class TestSelction {
    let question : Question
    var selectNumber : Int = 1
    var selectString : String?
    var content : String = "대한민국의 주권은 국민에게 있고, 모든 권력은 국민으로부터 나온다."
    var contentControversal : String?
    var codes : Array<Codes>?
    var cases : Array<Cases>?
    var keywords : Array<Keyword>?
    var notes : Array<Note>?
    var isAnswer : Bool = false
    var iscOrrect : Bool?
    
    init(question : Question, selectNumber : Int, content : String) {
        
        //(+)문제와 선택지가 상호참조에 따른 문제점이 없는지 시간내서 확인 2017. 4. 26
        self.question = question
        self.question.selections.append(self)
        
        //(+)동일한 선택지 번호가 이미 있으면 에러발생하도록 수정하면 좋을 것 2017. 4. 26.
        
        //문제에 있는 정답 정보를 이용하여 선택지가 정답인지를 확인
        if selectNumber == question.answer {
            question.answerSelection = self
            isAnswer = true
        }
        //문제 유형을 통해서 정답지가 T/F 인지 자동 판단하는 로직
        if question.questionOX == QuestionOX.O {
            if isAnswer {
                iscOrrect = true
            } else {
                iscOrrect = false
            }
        } else if question.questionOX == QuestionOX.X {
            if isAnswer {
                iscOrrect = false
            } else {
                iscOrrect = true
            }
        }

        //(+) find 유형의 문제에도 자동 확인 기능 추가 필요 2017. 4. 26.
        //지문이 올바른것/틀린것을 확인한 선택지가 가르키는 ㄱ,ㄴ,ㄷ을 선택지에서 추출하고, 선택지 주소를 각각 찾아내서 그 ㄱ,ㄴ,ㄷ 선택지의 iscOrrect를 수정하면 될 것임
        //이런 순서대로 답을 찍으려면 ㄱ,ㄴ,ㄷ 선택지를 먼저 db에 입력해야 하는데?

        
        self.selectNumber = selectNumber
        self.content = content
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

