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
    var content : String = "대한민국의 주권은 국민에게 있고, 모든 권력은 국민으로부터 나온다."
    var contentControversal : String?
    var codes : Array<Codes>?
    var cases : Array<Cases>?
    var keywords : Array<Keyword>?
    var notes : Array<Note>?
    var isAnswer : Bool = false
    var iscOrrect : Bool?
    
    init(question : Question, selectNumber : Int, content : String) {
        self.question = question
        self.question.selections.append(self)
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
        
        self.selectNumber = selectNumber
        self.content = content
    }
    
    
}
