//
//  ListSelection.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 5..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class ListSelection: Statement {
    var log = ""
    // key가 선택지이면 S접두어, ㄱ,ㄴ,ㄷ, 가,나,다이면 L접두어
    
    var listStringType : SelectStringType = .koreanCharcter
    let selectString: String
    var number : Int = 0
    
    // super클라스의 초기화 함수를 덮어 씌울수는 없는가? (-) 2017. 5. 5.
    // http://stackoverflow.com/questions/39344422/delegating-up-to-convenience-initializer-of-superclass
    // Delegating up to Convenience Initializer of Superclass
    init(revision: Int, question: Question, content: String, selectString: String) {
        
        self.selectString = selectString
        
        let stringArray = ["ㄱ", "ㄴ", "ㄷ", "ㄹ", "ㅁ", "ㅂ", "ㅅ", "ㅇ", "ㅈ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"]
        let stringArrayLetter = ["가", "나", "다", "라", "마", "바", "사", "아", "자", "차", "카", "타", "파", "하"]
        if let index = stringArray.firstIndex(of: selectString) {
            self.number = index + 1
            self.listStringType = SelectStringType.koreanCharcter
        } else if let index = stringArrayLetter.firstIndex(of: selectString) {
            self.number = index + 1
            self.listStringType = SelectStringType.koreanLetter
        } else {
            fatalError("잘못된 목록의 번호입력으로 진행할 수 없음 : \(selectString))")
        }
        
        let key = question.key + "=L" + String(format: "%02d",number)
        
        super.init(revision: revision, key: key, question: question, content: content)
        self.question.lists.append(self)
    }
    
    // 선택지가 열겨형일 경우에 그 선택지의 문자열을 형식에 맞게 출력하도록 도와주는 함수
//    func findStringNumberOfSelection() -> String {
//        if self.listStringType == .koreanCharcter {
//            return self.listInt.koreanCharaterInt
//        } else if self.listStringType == .koreanLetter {
//            return self.listInt.koreanLetterInt
//        }
//        print("error>>findStringNumberOfSelection 실패함")
//        return "?"
//    }
    
    // parameter를 간단하게 입력하는 방법을 고민해서 parameter default 값추가와 conditional unwrapped로 해결함(-) 2017. 4. 30.
    // int 입력이 없으면 해당 목록선택지의 원래 숫자를 문자열로 변환하며 입력된다면 거기에 맞는 문자열을 목록선택지 출력 형식에 맞는 문자열로 출력하는 함수
    func getListString(int : Int? = nil) -> String {
        let intToGet : Int
        if int == nil {
            intToGet = self.number
        } else {
            intToGet = int!
        }
        // https://thatthinginswift.com/switch-unwrap-shortcut/
        // switch와 enum의 동시사용 시간날 때 대해 공부해야함 (+) 2017. 4. 30.
        if self.listStringType == .koreanCharcter {
            return intToGet.koreanCharaterInt
        } else if self.listStringType == .koreanLetter {
            return intToGet.koreanLetterInt
        }
        log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "\(self.question) 문제의 목록 문자열 찾기를 실패함")
        return "목록 문자열 찾기 실패"
    }
}


enum SelectStringType : String {
    case koreanCharcter
    case koreanLetter
}

extension String {
    var koreanCharacterAndLetterInt : Int {
        if self == "ㄱ" {return 1}
        if self == "ㄴ" {return 2}
        if self == "ㄷ" {return 3}
        if self == "ㄹ" {return 4}
        if self == "ㅁ" {return 5}
        if self == "ㅂ" {return 6}
        if self == "ㅅ" {return 7}
        if self == "ㅇ" {return 8}
        if self == "ㅈ" {return 9}
        if self == "ㅊ" {return 10}
        if self == "ㅋ" {return 11}
        if self == "ㅌ" {return 12}
        if self == "ㅍ" {return 13}
        if self == "ㅎ" {return 14}
        if self == "가" {return 1}
        if self == "나" {return 2}
        if self == "다" {return 3}
        if self == "라" {return 4}
        if self == "마" {return 5}
        if self == "바" {return 6}
        if self == "사" {return 7}
        if self == "아" {return 8}
        if self == "자" {return 9}
        if self == "차" {return 10}
        if self == "카" {return 11}
        if self == "타" {return 12}
        if self == "파" {return 13}
        if self == "하" {return 14}
        return 0
    }
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
        if self == 10 {
            return "ㅊ"
        }
        if self == 11 {
            return "ㅋ"
        }
        if self == 12 {
            return "ㅌ"
        }
        if self == 13 {
            return "ㅍ"
        }
        if self == 14 {
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
        if self == 10 {
            return "차"
        }
        if self == 11 {
            return "카"
        }
        if self == 12 {
            return "타"
        }
        if self == 13 {
            return "파"
        }
        if self == 14 {
            return "하"
        }
        return self.description
    }
}

