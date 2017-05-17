//
//  Selection.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 5..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Cocoa

class Selection: Statement {
    // key 부여방식 답선택지이면 SN접두어, ㄱ,ㄴ,ㄷ이면 KC접두어, 가,나,다이면 KL접두어
    
    let number : Int
    var listInContentOfSelection = [List]()
    var anotherSelectionInStatement = [Selection]()
    
    init(revision: Int, question: Question, number: Int, content: String) {
        
        self.number = number
        let key = question.key + "=S" + String(format: "%02d",number)
        
        super.init(revision: revision, key: key, question: question, content: content)
        
        self.question.selections.append(self)
        
        isAnswer = false
        if self.number == question.answer {
            question.answerSelection = self
            isAnswer = true
        }
        
        //Select OX 문제 유형에 대하여 선택지가 T/F 인지 자동 판단하는 로직
        switch question.questionType {
        case .Select:
            switch question.questionOX {
            case .O:
                if isAnswer! {  //selection에서는 항상 isAnwer가 존재
                    iscOrrect = true
                } else {
                    iscOrrect = false
                }
            case .X:
                if isAnswer! {
                    iscOrrect = false
                } else {
                    iscOrrect = true
                }
            default:
                iscOrrect = nil
            }
            
        // case .Find:
        // 여기에 두고 싶지만 Find 유형의 경우에는 모든 목록이
            
        default:
            iscOrrect = nil
        }
        //(-) find 유형의 문제에도 자동 확인 기능 추가 필요 2017. 4. 26.
        //find 유형 문제에는 의미있는 OX 질문이 없을 것이므로 필요없을 것임, 차리리 Select.Defference를 추가하는게 나을듯 2017. 5. 5.
    }
}
