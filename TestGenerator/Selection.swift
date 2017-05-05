//
//  Selection.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 5..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Cocoa

class Selection: Statement {
    // 답선택지이면 SN접두어, ㄱ,ㄴ,ㄷ이면 KC접두어, 가,나,다이면 KL접두어
    let key : String
    
    let selectNumber : Int
    var listInContentOfSelection = [List]()
    
    var isAnswer : Bool = false
    
    init(question: Question, selectNumber: Int, content: String) {
        
        self.selectNumber = selectNumber
        self.key = question.key + "=S" + String(format: "%02d",selectNumber)
        
        super.init(question: question, content: content)
        
        self.question.selections.append(self)
        
        if self.selectNumber == question.answer {
            question.answerSelection = self
            isAnswer = true
        }
        
        //Select OX 문제 유형에 대하여 선택지가 T/F 인지 자동 판단하는 로직
        switch question.questionType {
        case .Select:
            switch question.questionOX {
            case .O:
                if isAnswer {
                    iscOrrect = true
                } else {
                    iscOrrect = false
                }
            case .X:
                if isAnswer {
                    iscOrrect = false
                } else {
                    iscOrrect = true
                }
            default:
                iscOrrect = nil
            }
        default:
            iscOrrect = nil
        }
        //(-) find 유형의 문제에도 자동 확인 기능 추가 필요 2017. 4. 26.
        //find 유형 문제에는 의미있는 OX 질문이 없을 것이므로 필요없을 것임, 차리리 Select.Defference를 추가하는게 나을듯 2017. 5. 5.
    }
}


extension Selection {
    func createJsonDataTypeStructure() -> [String:Any]? {
        //ContentControversal, nullabe, String
        let contentControversalString = self.contentControversal != nil ? self.contentControversal! : ""
        let contentControversal = ["label":contentControversalString, "Attribute":JsonAttributes().stringNullableAttribute] as [String : Any]
        
        //nullabe이 아니므로 간단하게 정의가능
        let content = ["label":self.content, "Attribute":JsonAttributes().stringNotNullableAttribute] as [String : Any]
        let selectNumber = ["label":self.selectNumber, "Attribute":JsonAttributes().intNotNullableAttribute] as [String : Any]
        
        let selection = ["label":self.key, "Attribute":["selectNumber":selectNumber, "content":content, "contentControversal":contentControversal]] as [String : Any]
        
        guard JSONSerialization.isValidJSONObject(selection) else {
            return nil
        }
        return selection
    }
}
