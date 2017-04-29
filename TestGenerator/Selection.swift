//
//  Selections.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 3. 22..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

//선택지
class Selection {
    let question : Question
    // 답선택지이면 SN접두어, ㄱ,ㄴ,ㄷ이면 KC접두어, 가,나,다이면 KL접두어
    var key : String {
        if selectNumber != 0 {
            return question.questionKey+"-SN"+String(format: "%02d",selectNumber)
        }
        switch selectListStringType! {
        case .koreanCharcter :
            return question.questionKey+"-KC"+String(format: "%02d",selectListStringInt!)
        case .koreanLetter :
            return question.questionKey+"-KL"+String(format: "%02d",selectListStringInt!)
            //int에 description 변환할 경우 %02d 구문이 이상하게 변함
            // return question.questionKey+"-KL"+String(format: "%02d",selectStringInt!.description)
        }
    }
    
    // 0이면 ㄱ,ㄴ,ㄷ혹은 가,나,다 존재 숫자면 선택지임
    var selectNumber : Int = 0
    var selectListStringType : SelectStringType?
    var selectListStringInt : Int?
    
    var content : String = "대한민국의 주권은 국민에게 있고, 모든 권력은 국민으로부터 나온다."
    var contentControversal : String?
    var codes : Array<Codes>?
    var cases : Array<Cases>?
    var keywords : Array<Keyword>?
    var notes : Array<Note>?
    var isAnswer : Bool = false
    var iscOrrect : Bool?
    
    init(question : Question, selectNumber : Int, content : String, selectString : String? = nil) {
        
        //(+)문제와 선택지가 상호참조에 따른 문제점이 없는지 시간내서 확인 2017. 4. 26
        self.question = question
        
        
        // ㄱ,ㄴ,ㄷ 및 가,나,다 패턴을 정리함
        // array mapping으로 더 멋있게 처리할 방법 궁리 필요함 2017. 4. 29.
        if let selString = selectString {
            self.selectNumber = 0
            let stringArray = ["ㄱ", "ㄴ", "ㄷ", "ㄹ", "ㅁ", "ㅂ", "ㅅ", "ㅇ", "ㅈ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"]
            let stringArrayLetter = ["가", "나", "다", "라", "마", "바", "사", "아", "자", "차", "카", "타", "파", "하"]
            if let index = stringArray.index(of: selString) {
                self.selectListStringInt = index + 1
                self.selectListStringType = SelectStringType.koreanCharcter
            } else if let index = stringArrayLetter.index(of: selString) {
                self.selectListStringInt = index + 1
                self.selectListStringType = SelectStringType.koreanCharcter
            }
            self.question.listSelections.append(self)
        } else {
            self.selectNumber = selectNumber
            self.question.selections.append(self)
        }
        
        //(+)동일한 선택지 번호가 이미 있으면 에러발생하도록 수정하면 좋을 것 2017. 4. 26.
        
        //문제에 있는 정답 정보를 이용하여 선택지가 정답인지를 확인
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
                print("OX를 파악할 수 없음, 문제타입을 직접확인해야 OX를 찾을 수 있음 \(self.key)")
            }
        case .Find:
            switch question.questionOX {
            case .O:
                print("check")
            default:
                print("OX를 파악할 수 없음, 문제타입을 직접확인해야 OX를 찾을 수 있음 \(self.key)")
            }
        default:
            print("not suitable for finding OX of selection \(self.key)")
        }
        //(+) find 유형의 문제에도 자동 확인 기능 추가 필요 2017. 4. 26.
        //지문이 올바른것/틀린것을 확인한 선택지가 가르키는 ㄱ,ㄴ,ㄷ을 선택지에서 추출하고, 선택지 주소를 각각 찾아내서 그 ㄱ,ㄴ,ㄷ 선택지의 iscOrrect를 수정하면 될 것임
        //이런 순서대로 답을 찍으려면 ㄱ,ㄴ,ㄷ 선택지를 먼저 db에 입력해야 하는데?
        //꼭 그런 것은 아님 ㄱ,ㄴ,ㄷ선택지가 생길 때 db를 확인해서 정답을 찾으면 됨
        //양쪽방향 모두 구현? 보통은 ㄱ,ㄴ,ㄷ 선택지가 먼저 생길것임
        
        self.content = content
    }
    
    
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
    
    func getListString(int : Int) -> String {
        guard let type = self.selectListStringType else { return "?" }
        switch type {
        case .koreanCharcter :
            return int.koreanCharaterInt
        case .koreanLetter :
            return int.koreanLetterInt
        }
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

enum SelectStringType {
    case koreanCharcter
    case koreanLetter
}

extension Int {
    var koreanCharaterInt : String {
        if self == 1 {
            return "ㄱ"
        }
        if self == 2 {
            return "ㄴ"
        }
        if self == 3 {
            return "ㄷ"
        }
        if self == 4 {
            return "ㄹ"
        }
        if self == 5 {
            return "ㅁ"
        }
        if self == 6 {
            return "ㅂ"
        }
        if self == 7 {
            return "ㅅ"
        }
        if self == 8 {
            return "ㅇ"
        }
        if self == 9 {
            return "ㅈ"
        }
        if self == 9 {
            return "ㅊ"
        }
        if self == 10 {
            return "ㅋ"
        }
        if self == 11 {
            return "ㅌ"
        }
        if self == 11 {
            return "ㅍ"
        }
        if self == 11 {
            return "ㅎ"
        }
        return self.description
    }
}
extension Int {
    var koreanLetterInt : String {
        if self == 1 {
            return "가"
        }
        if self == 2 {
            return "나"
        }
        if self == 3 {
            return "다"
        }
        if self == 4 {
            return "라"
        }
        if self == 5 {
            return "마"
        }
        if self == 6 {
            return "바"
        }
        if self == 7 {
            return "사"
        }
        if self == 8 {
            return "아"
        }
        if self == 9 {
            return "자"
        }
        if self == 9 {
            return "차"
        }
        if self == 10 {
            return "카"
        }
        if self == 11 {
            return "타"
        }
        if self == 12 {
            return "파"
        }
        if self == 13 {
            return "하"
        }
        return self.description
    }
}




