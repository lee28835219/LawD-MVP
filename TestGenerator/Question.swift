//
//  Questions.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 3. 22..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class Question {
    let questionKey : String //Primary key, 원본
    
    // (+) 질문의공통db, 추후 enum 등으로 변경 2017. 4. 29.
    let isPublished : Bool //기출, 원본
    let testDate : String //1701, 원본
    let testCategory : String //변시, 원본
    var testSubject : String //민사법, 원본
    
    var testQuestionNo : Int? //문제번호, 원본
    var testQuestionNote : String? //유니온문제번호 등 기타 정보, 원본
    var testSubjectDetail : String? //민법, 원본
    
    var questionType : QuestionType //원본
    var questionOX : QuestionOX //원본
    var content: String //원본
    
    var contentControversal : String? //원본
    var contentNote: String? //원본
    
    let answer: Int //꼭 필요, 선택지 입력 시 문제의 논리와 정답을 이용해서 선택지의 T/F를 모두 자동으로 계산할 수 있음
    //하지만 문제 파싱시에 없는 값일 경우가 많을 것임, 추후 optional로 변경하도록 수정 필요 2017. 4.29.
    
    var selections = [Selection]() //원본
    weak var answerSelection: Selection? //선택지가 없는 상태에서는 런타임에서도 존재하지 않음, 에러체크 방법 다시 숙고(+) 2017. 4. 26.
    var listSelections = [Selection]() //원본
    var answerListSelections = [Selection]()
    
    init(questionKey : String, isPublished : Bool, testDate : String, testCategory : String, testSubject : String, questionType : QuestionType, questionOX : QuestionOX , content : String, answer : Int) {
        self.questionKey = questionKey
        self.isPublished = isPublished
        self.testCategory = testCategory
        self.testDate = testDate
        self.testSubject = testSubject
        self.questionType = questionType
        self.questionOX = questionOX
        self.content = content
        self.answer = answer
    }
    
    //자동으로 이 명령을 실행하는 방법은 없을까? (+) 2017. 4. 30.
    func findAnswer() -> Bool {
        guard let ans = self.answerSelection else { return false }
        switch self.questionType {
        case .Select:
            return true
        case .Find:
            switch self.questionOX {
            // Find O일 경우 정답지 숫자에 있는 문자가 문자선택지를 포함하면 iscOrrect = true, isAnswer = true
            case .O:
                for listSel in listSelections {
                    let listSelString = findStringNumberOfSelection(listSel: listSel)
                    if ans.content.range(of: listSelString) != nil {
                        listSel.iscOrrect = true
                        listSel.isAnswer = true
                    } else {
                        listSel.iscOrrect = false
                        listSel.isAnswer = false
                    }
                }
                return true
            // Find X일 경우 정답지 숫자에 있는 문자가 문자선택지를 포함하면 iscOrrect = false, isAnswer = true
            case .X:
                for listSel in listSelections {
                    let listSelString = findStringNumberOfSelection(listSel: listSel)
                    if ans.content.range(of: listSelString) != nil {
                        listSel.iscOrrect = false
                        listSel.isAnswer = true
                    } else {
                        listSel.iscOrrect = true
                        listSel.isAnswer = false
                    }
                }
                return true
            default:
                print("정답을 찾을 수 없음")
                return false
            }
        default:
            print("정답을 찾을 수 없음")
            return false
        }
    }
    
    func findStringNumberOfSelection(listSel : Selection) -> String {
        switch listSel.selectStringType! {
        case .koreanCharcter :
            return listSel.selectStringInt!.koreanCharaterInt
        case .koreanLetter :
            return listSel.selectStringInt!.koreanLetterInt
        }
    }
    
    //문제와 선택지를 출판하는 함수
    func publish() {
        //문제
        print("[\(testSubject) \(testDate) \(testCategory)] "+content, terminator : "")
        if let contNote = contentNote {
            print(" "+contNote)
        } else {
            print("")
        }
        print("\(questionType) \(questionOX)")
        
        if listSelections.count > 0 {
            for (index,sel) in listSelections.enumerated() {
                switch sel.selectStringType! {
                case .koreanCharcter :
                    print((index+1).koreanCharaterInt+" "+sel.content)
                    print(sel.iscOrrect ?? "not sure")
                    print(sel.key)
                case .koreanLetter :
                    print((index+1).koreanLetterInt+" "+sel.content)
                    print(sel.iscOrrect ?? "not sure")
                    print(sel.key)
                }
                
            }
        }
        
        //선택지
        print("")
        for (index,sel) in selections.enumerated() {
            print((index+1).roundInt+" "+sel.content)
            print(sel.iscOrrect ?? "not sure")
            print(sel.key)
        }
        
        //정답
        print("")
        print("<정답>")
        printAnswer(answerSelection: answerSelection)
    }
    
    func printAnswer(answerSelection : Selection?) {
        guard let ansS = answerSelection
            else {
                print("정답없음")
                return
        }
        print(answer.roundInt + " " + ansS.content)
    }
    
    func createJsonDataTypeStructure() -> [String:Any]? {

        //// 1. 1Question의 information을 정리함
        
        //ContentNot, nullabe, String
        //contentNote가 비었는지 확인하고, labeld에 저장함
        let contentNoteString = self.contentNote != nil ? self.contentNote! : "" as String
        let contentNote = ["label":contentNoteString, "Attribute":JsonAttributes().stringNullableAttribute] as [String : Any]
        
        //ContentControversal, nullabe, String
        //값이 비었는지 확인하고, label에 저장함
        let contentControversalString = self.contentControversal != nil ? self.contentControversal! : "" as String
        let contentControversal = ["label":contentControversalString, "Attribute":JsonAttributes().stringNullableAttribute] as [String : Any]
        
        //nullabel이 아닌 정보들 저장, 자신있는 label에 대한 저장
        let content = ["label":self.content, "Attribute":JsonAttributes().stringNotNullableAttribute] as [String : Any]
        let questionOX = ["label":self.questionOX.rawValue, "Attribute":JsonAttributes().questionOXNotNullableAttribute] as [String : Any]
        let questionType = ["label":self.questionType.rawValue, "Attribute":JsonAttributes().questionTypeNotNullableAttribute] as [String : Any]
        let testSubject = ["label":self.testSubject, "Attribute":JsonAttributes().stringNotNullableAttribute] as [String : Any]
        let testCategory = ["label":self.testCategory, "Attribute":JsonAttributes().stringNotNullableAttribute] as [String : Any]
        let testDate = ["label":self.testDate, "Attribute":JsonAttributes().stringNotNullableAttribute] as [String : Any]
        let isPublished = ["label":self.isPublished, "Attribute":JsonAttributes().boolNotNullableAttribute] as [String : Any]
        
        // 최종 question infromation
        let questionInfromation = ["isPublished":isPublished, "testDate":testDate, "testCategory":testCategory, "testSubject":testSubject, "questionType":questionType, "questionOX":questionOX, "content":content, "contentControversal":contentControversal, "contentNote":contentNote]
        
        //// 3. Selection들을 저장, Array
        var selections = [Any]()
        for sel in self.selections {
            guard let selUnwrapped = sel.createJsonDataTypeStructure() else {
                print("Creating Selection JSON Error While dealing with \(sel.question.questionKey)-\(sel.selectNumber)")
                continue
            }
            selections.append(selUnwrapped)
        }
        
        //// 3. question의 완성 = label + question inforation + selections
        let question = ["label":self.questionKey, "information":questionInfromation, "Selections":selections] as [String : Any]
        
        //// 4. json 형식인지 확인해서 그러하면 question json type structure 반환 아니면, nil
        guard JSONSerialization.isValidJSONObject(question) else {
            print("Creating Question JSON Error While dealing with \(self.questionKey)")
            return nil
        }
        return question
    }
}

enum QuestionOX : String {
    case O //옳은 것
    case X //옳지 않은 것
    case Correct //맞는 것
    case Difference //다른 것
    case Unknown
}

enum QuestionType : String {
    case Select // 고르시오
    case Find // 모두 고르시오
    case Define // ?
    case Unknown
}

// 변수타입을 정의
// enum을 이용해서 멋잇게 저장하는 법을 고민해봐야 한다. 2017. 4. 29.
struct JsonAttributes {
    let stringNullableAttribute = ["Type":"String", "Nullable":"true"]
    let stringNotNullableAttribute = ["Type":"String", "Nullable":"false"]
    let intNullableAttribute = ["Type":"int", "Nullable":"true"]
    let intNotNullableAttribute = ["Type":"int", "Nullable":"false"]
    let boolNotNullableAttribute = ["Type":"Bool", "Nullable":"false"]
    let questionTypeNotNullableAttribute = ["Type":"QuestionType", "Nullable":"false"]
    let questionOXNotNullableAttribute = ["Type":"QuestionOX", "Nullable":"false"]
}
