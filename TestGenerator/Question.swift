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
    
    init(revision : Int, test : Test?, number : Int, questionType : QuestionType, questionOX : QuestionOX , content : String, answer : Int) {
        
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
        super.init(UUID(), key)
        
        self.test?.questions.append(self)
    }
    
    
    
    //자동으로 이 명령을 실행하는 방법은 없을까? (+) 2017. 4. 30.
    //목록에 자동으로 iscOrrect와 isAnswer를 찍어주는 함수
    //정답이 제대로 입력 안되있으면 못찼음
    //현재 FO와 FX만 구현됨, FC는 못찾음
    // select 형식일 경우에도 selection별로 찍어주도록 추가함 2017. 5. 31.
    public func findAnswer() -> Bool {
        
        guard let ans = self.answerSelection else {
            fatalError("정답 포인터가 없어서 정답을 찾을 수 없음 \(self.key)")
        }
        
        for sel in selections {
            sel.findAnswer()
        }
        
        switch questionType {
        case .Find:
            switch questionOX {
            case .O:
                _setlistInContentOfSelection()
                for listSel in lists {
                    let listSelString = listSel.getListString()
                    if ans.content.range(of: listSelString) != nil {
                        listSel.iscOrrect = true
                        listSel.isAnswer = true
                        self.answerLists.append(listSel)
                    } else {
                        listSel.iscOrrect = false
                        listSel.isAnswer = false
                    }
                }
                return true
            case .X:
                _setlistInContentOfSelection()
                for listSel in lists {
                    let listSelString = listSel.getListString()
                    if ans.content.range(of: listSelString) != nil {
                        listSel.iscOrrect = false
                        listSel.isAnswer = true
                        self.answerLists.append(listSel)
                    } else {
                        listSel.iscOrrect = true
                        listSel.isAnswer = false
                    }
                }
                return true
            case .Correct:
                return false
            case .Unknown:
                return false
            }
        case .Select:
            switch questionOX {
            case .O:
                return false
            case .X:
                return false
            case .Correct:
                return false
            case .Unknown:
                return false
            }
        case .Unknown:
            return false
        }
    }
    
    
    
    
    // 객체 밖에서 함수가 들어나지 않도록 정의하는 방법은 무었인가 (+) 2017. 4. 30.
    // 다시 체크할 수 있도록 수정필요 (+) 2017. 5. 5.
    
    func _setlistInContentOfSelection() {
        
        for selection in selections {
            // 혹시몰라서 초기화 시켜두었음
            // selection.listInContentOfSelection = []
            
            // 초기화보다는 잘못된 함수호출인 셈이니 치명적 에러를 발생시킴이 맞을 듯 2017. 5. 9.
            // 문제 정답을 수정하면서 이 함수를 호출할 때는 더이상 listInContentOfSelection이 []이 아닌데 여기서 에러 체크 하면 프로그램 진행이 안됨 그래서 []이 아닐때는 다시 []초기화 시켜주고 프로그램을 진행하도록 수정 2017. 5. 31.
            // 덮어씌어서 ㄱ,ㄴ,ㄷ이 이중으로 추가되는 문제 방지를 위해서, 아래 조건식은 꼭 필요할 것이며 []이 아니면 []로 다시 초기화 하는 액션 필요함
            // if selection.listInContentOfSelection != [] {
                // fatalError("잘못된 함수호출 _setlistInContentOfSelection(), 선택지의 내용안에 있는 목록지가 초기화되지 않은 상태에서 호출됨")
            //}
            selection.listInContentOfSelection = []
        
            for list in lists {
                // 선택지에 문제의 목록 문자가 존재하는지 확인하는 분기
                if selection.content.range(of: list.getListString()) != nil {
                    selection.listInContentOfSelection.append(list)
                }
                
            }
        }
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

