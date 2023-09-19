//
//  Questions.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 3. 22..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class Question : DataStructure {
////내가 무엇인지
    let test : Test?
    var cases = [String]()
    var revision : Int
    
////나의 속성은 무었인지
    
    // (+) 질문의공통db, 추후 enum 등으로 변경 2017. 4. 29. => json으로 변환을 생각한다면 기본데이터형으로 놔두는게 오히려 더 편리함
    // 문제에 관한 항목
    var number : Int //문제번호, 원본
    var subjectDetails = [String]() //민법, 원본
    
    var questionType : QuestionType //원본
    var questionOX : QuestionOX //원본
    
    // 질문에 관한 항목
    var contentPrefix : String?
    
    var content: String //원본
    var notContent : String? //원본
    var contentNote: String? //원본
    
    // 지문에 관한 항목
    var passage : String?
    var passageSuffix : String?
    
    // 지문에 관한 항목
    var questionSuffix : String?
    
    //꼭 필요, 선택지 입력 시 문제의 논리와 정답을 이용해서 선택지의 T/F를 모두 자동으로 계산할 수 있음
    //하지만 문제 파싱시에 없는 값일 경우가 많을 것임, 추후 optional로 변경하도록 수정 필요(+) 2017. 4.29.
    var answer: Int
    
    var raw : String = ""
    var rawSelections : String = ""
    var rawLists : String = ""
    
    ////식구들이 정해지면 내가 찾아야 하는 존재
    //선택지가 없는 상태에서는 런타임에서도 존재하지 않음, 에러체크 방법 다시 숙고(+) 2017. 4. 26.
    weak var answerSelection: Selection?
    var answerLists = [ListSelection]()
    
    
    ////내 식구들은 누구인지
    var selections = [Selection]() //원본
    var lists = [ListSelection]() //원본
    
    
    // 문제풀이 이력 드디어 추가 2017. 5. 20.
    // 먼저는 맞았는지 틀렸지와 푼날짜, 노트를 아카이브 할 것임
    // 향후 추가정보를 다룰 수 잇도록 수정 필요 (+)
    var solvers = [Solver]()
    
    init(id : UUID, revision : Int, test : Test?, number : Int, questionType : QuestionType, questionOX : QuestionOX , content : String, answer : Int) {
        
        self.revision = revision
        self.test = test
        
        self.questionType = questionType
        self.questionOX = questionOX
        self.content = content
        self.answer = answer
        self.number = number
        
        let key = (self.test?.key ?? "") + "=" + String(format: "%04d", self.number)
        
        let ques = test?.questions ?? []
        if !ques.filter({$0.key == key}).isEmpty {
            fatalError("잘못된 문제key 입력 이미 \(key)이 존재함")
        }
        super.init(id, key)
        
        self.test?.questions.append(self)
    }
    
}



extension Question {
    
    func getNotOX() -> QuestionOX {
        var result = self.questionOX
        if result == .O {
            result = .X
        } else if result == .X {
            result = .O
        }
        return result
    }
}


// 2023.09.19. QuestionData로의 이주를 위해 아래 아주 중요한 이넘을 QuestionData.swift로 옮겼습니다.
/*
enum QuestionOX : String {
    case O //옳은 것
    case X //옳지 않은 것
    case Correct // 올바른 것
    case Unknown
}

enum QuestionType : String {
    case Select // 고르시오
    case Find // 모두 고르시오
    case Unknown
}
*/


extension String {
    func spacing(_ space:Int, _ cutLength: Int = 39) -> String {
        // http://stackoverflow.com/questions/39677330/how-does-string-substring-work-in-swift-3
        // How does String substring work in Swift 3
        // 공부해야함 (+) 2017. 5. 4.
        
        var str = ""
        let chars = self
        
        var pointer = 0
        for (_,char) in chars.enumerated() {
            
            pointer = pointer + 1
            
            if char == "\n" {
                str = str + "\n" + String(repeating: " ", count: space+1)
                continue
            }
            if pointer == cutLength {
                if char.description != " " {
                    str = str + "\n" + String(repeating: " ", count: space) + char.description
                    pointer = 0
                    continue
                } else {
                    str = str + "\n" + String(repeating: " ", count: space)
                    pointer = 0
                    continue
                }
            }
            str = str + char.description
            
//            if char != "\n" {
//                if index+1 < cutLength-space {
//                    str = str + char.description
//                } else if (index+1) % (cutLength-space) == 0 {
//                    str = str + "\n" + String(repeating: " ", count: space)
//                    if char == " " {
//                        continue
//                    }
//                    str = str + char.description
//                } else {
//                    str = str + char.description
//                }
//            } else {
//                str = str + char.description + String(repeating: " ", count: space + 1)
//            }
        }
        return str
    }
    
    
//    2023. 6. 13. 스위프트유아이를 위해 추가
    func truncateString(_ str: String, maxLength: Int) -> String {
        var truncatedString = str

        if truncatedString.count > maxLength {
            let endIndex = truncatedString.index(truncatedString.startIndex, offsetBy: maxLength)
            truncatedString = truncatedString[..<endIndex] + "..."
        }

        return truncatedString
    }
    
}




// 변수타입을 정의
// enum을 이용해서 멋잇게 저장하는 법을 고민해봐야 한다. 2017. 4. 29. (-)
// 2017. 5. 6. json완성한 지금은 별 필요없다. 향후 쓸일이 있을까???
struct JsonAttributes {
    let stringNullableAttribute = ["Type":"String", "Nullable":"true"]
    let stringNotNullableAttribute = ["Type":"String", "Nullable":"false"]
    let intNullableAttribute = ["Type":"int", "Nullable":"true"]
    let intNotNullableAttribute = ["Type":"int", "Nullable":"false"]
    let boolNotNullableAttribute = ["Type":"Bool", "Nullable":"false"]
    let questionTypeNotNullableAttribute = ["Type":"QuestionType", "Nullable":"false"]
    let questionOXNotNullableAttribute = ["Type":"QuestionOX", "Nullable":"false"]
}

