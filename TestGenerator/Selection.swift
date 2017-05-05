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
    var contentSelectionsList = [List]()
    
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
        
        //문제 유형을 통해서 정답지가 T/F 인지 자동 판단하는 로직
        switch question.questionType {
        case .Select:
            switch question.questionOX {
            case .Correct, .O:
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
            case .Difference, .Unknown:
                //                print("OX를 파악할 수 없음, 문제타입을 직접확인해야 OX를 찾을 수 있음 \(self.key)")
                _ = true
            }
        default:
            _ = true
            //            print("not suitable for finding OX of selection \(self.key)")
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
