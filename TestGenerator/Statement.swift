//
//  Statement.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 3. 22..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

//선택지
class Statement : DataStructure {
    
    var cases = [String]()
    var revision : Int
    let question : Question
    
    var content : String = "대한민국의 주권은 국민에게 있고, 모든 권력은 국민으로부터 나온다."
    var notContent : String?
    
    var iscOrrect : Bool?
    var isAnswer : Bool? = false
    
    
    init(revision : Int, key : String, question : Question, content : String) {
        
        self.revision = revision
        
        //(+)문제와 선택지가 상호참조에 따른 문제점이 없는지 시간내서 확인 2017. 4. 26
        
        self.question = question
        //(+)동일한 선택지 번호가 이미 있으면 에러발생하도록 수정하면 좋을 것 2017. 4. 26.
        
        //지문이 올바른것/틀린것을 확인한 선택지가 가르키는 ㄱ,ㄴ,ㄷ을 선택지에서 추출하고, 선택지 주소를 각각 찾아내서 그 ㄱ,ㄴ,ㄷ 선택지의 iscOrrect를 수정하면 될 것임
        //이런 순서대로 답을 찍으려면 ㄱ,ㄴ,ㄷ 선택지를 먼저 db에 입력해야 하는데?
        //꼭 그런 것은 아님 ㄱ,ㄴ,ㄷ선택지가 생길 때 db를 확인해서 정답을 찾으면 됨
        //양쪽방향 모두 구현? 보통은 ㄱ,ㄴ,ㄷ 선택지가 먼저 생길것임
        
        //문제에 있는 정답 정보를 이용하여 선택지가 정답인지를 확인하는 매우 중요한 함수
        // 확인되지 않을경우 치명적 에러
        self.content = content
        
        // Statement는 오로지 key가 있어야만 존재할 수 있긴한데
        // 이를 OX문제로 향후에 변경하도록 수정할 때를 대비해서 key 관리방안을 고민해야되긴 한다 2017. 5. 6,
        super.init(UUID(), key)
    }
    
    func getOX() -> String {
        var result = "(알수없음)"
        if let iscOrrectUnwrapped = iscOrrect {
            if iscOrrectUnwrapped {
                result = "(O)"
            } else {
                result = "(X)"
            }
        }
        return result
    }
    
}

// 숫자 스트링 -> 라운드 숫자 스트링 변환, 뭔가 더 고급스러운 방법은 없는가? 2017. 4. 9.
extension Int {
    var roundInt : String {
        if self == 1 {return "①"}
        if self == 2 {return "②"}
        if self == 3 {return "③"}
        if self == 4 {return "④"}
        if self == 5 {return "⑤"}
        if self == 6 {return "⑥"}
        if self == 7 {return "⑦"}
        if self == 8 {return "⑧"}
        if self == 9 {return "⑨"}
        if self == 10 {return "⑩"}
        return self.description
    }
}

extension String {
    var roundInt : Int {
        if self == "①" {return 1}
        if self == "②" {return 2}
        if self == "③" {return 3}
        if self == "④" {return 4}
        if self == "⑤" {return 5}
        if self == "⑥" {return 6}
        if self == "⑦" {return 7}
        if self == "⑧" {return 8}
        if self == "⑨" {return 9}
        if self == "⑩" {return 10}
        return 0
    }
}


//extension Bool {
//    var OX : String? {
//        if self == nil {
//            return "(알수없음)"
//        }
//    }
//}
