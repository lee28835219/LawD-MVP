//
//  Questions.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 3. 22..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class Question {
////내가 무엇인지
    let test : Test
    let key : String //Primary key, 원본
    
////나의 속성은 무었인지
    var string = ""
    var description : String? = nil
    
    // (+) 질문의공통db, 추후 enum 등으로 변경 2017. 4. 29.
    var number : Int //문제번호, 원본
    var testQuestionNote : String? //유니온문제번호 등 기타 정보, 원본
    var testSubjectDetail : String? //민법, 원본
    
    var questionType : QuestionType //원본
    var questionOX : QuestionOX //원본
    
    var content: String //원본
    var contentControversal : String? //원본
    var contentNote: String? //원본
    
    //꼭 필요, 선택지 입력 시 문제의 논리와 정답을 이용해서 선택지의 T/F를 모두 자동으로 계산할 수 있음
    //하지만 문제 파싱시에 없는 값일 경우가 많을 것임, 추후 optional로 변경하도록 수정 필요(+) 2017. 4.29.
    var answer: Int
    
    var selectionsString : String? = nil
    var listSelectionsString : String? = nil
    
    
////내 식구들은 누구인지
    var selections = [Selection]() //원본
    var lists = [List]() //원본
    
////식구들이 정해지면 내가 찾아야 하는 존재
    //선택지가 없는 상태에서는 런타임에서도 존재하지 않음, 에러체크 방법 다시 숙고(+) 2017. 4. 26.
    weak var answerSelection: Selection?
    var answerListSelections = [List]()
    
    init(test : Test, number : Int, questionType : QuestionType, questionOX : QuestionOX , content : String, answer : Int) {
        
        self.test = test
        
        self.questionType = questionType
        self.questionOX = questionOX
        self.content = content
        self.answer = answer
        self.number = number
        
        let str = self.test.key + "=" + String(format: "%04d", self.number)
        
        if !test.questions.filter({$0.key == str}).isEmpty {
            fatalError("잘못된 문제key 입력 이미 \(str)이 존재함")
        }
        self.key = str
        
        self.test.questions.append(self)
    }
    
    //자동으로 이 명령을 실행하는 방법은 없을까? (+) 2017. 4. 30.
    //목록에 자동으로 iscOrrect와 isAnswer를 찍어주는 함수
    //정답이 제대로 입력 안되있으면 못찼음
    //현재 FO와 FX만 구현됨, FC는 못찾음
    public func findAnswer() -> Bool {
        guard let ans = self.answerSelection else {
            fatalError("정답 포인터가 없어서 정답을 찾을 수 없음 \(self.key)")
        }
        switch self.questionType {
        case .Find:
            switch self.questionOX {
            // Find O일 경우 정답지 숫자에 있는 문자가 문자선택지를 포함하면 iscOrrect = true, isAnswer = true
            case .O:
                for listSel in lists {
                    let listSelString = listSel.getListString()
                    if ans.content.range(of: listSelString) != nil {
                        listSel.iscOrrect = true
                        listSel.isAnswer = true
                        self.answerListSelections.append(listSel)
                    } else {
                        listSel.iscOrrect = false
                        listSel.isAnswer = false
                    }
                }
                _setlistInContentOfSelection()
                return true
            // Find X일 경우 정답지 숫자에 있는 문자가 문자선택지를 포함하면 iscOrrect = false, isAnswer = true
            case .X:
                for listSel in lists {
                    let listSelString = listSel.getListString()
                    if ans.content.range(of: listSelString) != nil {
                        listSel.iscOrrect = false
                        listSel.isAnswer = true
                        self.answerListSelections.append(listSel)
                    } else {
                        listSel.iscOrrect = true
                        listSel.isAnswer = false
                    }
                }
                _setlistInContentOfSelection()
                return true
            default:
                print("\(questionType)\(questionOX) 유형문제 정답을 찾으려고 했으나 확인할 수 없음 ", self.key)
                return false
            }
        default:
            print("\(questionType)\(questionOX) 유형문제 정답을 찾으려고 했으나 확인할 수 없음 ", self.key)
            return false
        }
    }
    
    // 객체 밖에서 함수가 들어나지 않도록 정의하는 방법은 무었인가 (+) 2017. 4. 30.
    // 다시 체크할 수 있도록 수정필요 (+) 2017. 5. 5.
    
    func _setlistInContentOfSelection() {
        for selection in selections {
            for list in lists {
                if selection.content.range(of: list.getListString()) != nil {
                    selection.listInContentOfSelection.append(list)
                }
            }
        }
    }
    
    func publish(showAttribute: Bool = false, showAnswer: Bool = false, showTitle: Bool = true, showOrigSel : Bool = false) {
        let oManager = OutputManager()
        oManager.showAnswer = showAnswer
        oManager.showTitle = showTitle
        oManager.showAttribute = showAttribute
        oManager.showOrigSel = showOrigSel
        
        var selectionsContent = [String]()
        var selsIscOrrect = [Bool?]()
        var selsIsAnswer = [Bool]()
        var originalSelectionsNumber = [String]()
        
        for sel in selections {
            selectionsContent.append(sel.content)
            selsIscOrrect.append(sel.iscOrrect)
            selsIsAnswer.append(sel.isAnswer)
            originalSelectionsNumber.append(sel.selectNumber.roundInt)
        }
        
        var listSelectionsContent = [String]()
        var listSelsIscOrrect = [Bool?]()
        var listSelsIntString = [String]()
        var origialListsNumberString = [String]()
        
        for (index,list) in lists.enumerated() {
            listSelectionsContent.append(list.content)
            listSelsIscOrrect.append(list.iscOrrect)
            listSelsIntString.append(list.getListString(int: index+1))
            origialListsNumberString.append(list.getListString())
        }
        
        oManager.questionPublish(
            testCategroy: test.category,
            testNumber: test.number,
            testSubject: test.subject,
            isPublished: test.isPublished,
            
            questionNumber: number,
            questionContent: content,  // 셔플하면 변경
            questionContentNote: contentNote,
            questionType: questionType,
            questionOX: questionOX,   // 셔플하면 변경
            
            listsContents : listSelectionsContent,
            listsIscOrrect : listSelsIscOrrect,
            listsNumberString : listSelsIntString,
            origialListsNumberString : origialListsNumberString,
            
            selectionsContent : selectionsContent,  // 셔플하면 변경
            selsIscOrrect : selsIscOrrect,  // 셔플하면 변경
            selsIsAnswer : selsIsAnswer,  // 셔플하면 변경
            originalSelectionsNumber : originalSelectionsNumber,
            
            ansSelContent: answerSelection?.content,  // 셔플하면 변경
            ansSelIscOrrect: answerSelection?.iscOrrect,  // 셔플하면 변경
            ansSelIsAnswer: answerSelection?.isAnswer,  // 셔플하면 변경
            questionAnswer: answer,  // 셔플하면 변경
            originalAnsSelectionNumber: answerSelection!.selectNumber.roundInt
        )
    }
    
    
    
    /*
    //문제와 선택지를 출판하는 함수
    func publish(showAttribute : Bool = false, showAnswer : Bool = false, showTitle : Bool = true) {
        
        //문제
        print("")
        if showTitle {
            let queTitle = "[\(test.category) \(test.number)회 \(test.subject) "+(test.isPublished ? "기출]" : "변형]")
            print(queTitle)
        }
        
        print("문 "+number.description+". ")
        var queCont = content
        if let contNote = contentNote {
            queCont = queCont + " " + contNote
        }
        if showAttribute {
            queCont = queCont + " (문제유형 : \(questionType)\(questionOX))"
        }
        print("  "+queCont.spacing(2))
        print()
        
        
        //목록
        if listSelections.count > 0 {
            for (index,sel) in listSelections.enumerated() {
                var selectionStr = sel.content
                if showAttribute {
                    if let OX = sel.iscOrrect {
                        selectionStr = selectionStr + (OX ? " (O)" : " (X)")
                    } else {
                        selectionStr = selectionStr + " (O?,X?)"
                    }
                }
                print(" "+sel.getListString(int : index+1)+". "+selectionStr.spacing(4))
            }
            print()
        }
        
        //선택지
        for (index,sel) in selections.enumerated() {
            print("  "+(index+1).roundInt+"  "+_getSelectionStringForPrinting(sel : sel, showAttribute : showAttribute).spacing(5))
        }
        print()
        
        //정답
        if showAnswer {
            print("<정답>")
            guard let ansS = answerSelection
                else {
                    print("  정답이 입력되지 않음")
                    return
            }
            print("  " + answer.roundInt + "  " + _getSelectionStringForPrinting(sel : ansS, showAttribute : showAttribute).spacing(5))
        }
        print()
    }
    private func _getSelectionStringForPrinting(sel : Selection, showAttribute : Bool) -> String {
        var selectionStr = sel.content
        if showAttribute {
            if let OX = sel.iscOrrect {
                selectionStr = selectionStr+(OX ? " (O)" : " (X)")
            } else {
                if questionType != .Select {
                    if sel.isAnswer {
                        selectionStr = selectionStr+" (O)"
                    } else {
                        selectionStr = selectionStr+" (X)"
                    }
                } else {
                    selectionStr = selectionStr+" (O,X)?"
                }
            }
        }
        return selectionStr
    }
    */

    
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
        let testSubject = ["label":self.test.subject, "Attribute":JsonAttributes().stringNotNullableAttribute] as [String : Any]
        let testCategory = ["label":self.test.category, "Attribute":JsonAttributes().stringNotNullableAttribute] as [String : Any]
        let testDate = ["label":self.test.date, "Attribute":JsonAttributes().stringNotNullableAttribute] as [String : Any]
        let isPublished = ["label":self.test.isPublished, "Attribute":JsonAttributes().boolNotNullableAttribute] as [String : Any]
        
        // 최종 question infromation
        let questionInfromation = ["isPublished":isPublished, "testDate":testDate, "testCategory":testCategory, "testSubject":testSubject, "questionType":questionType, "questionOX":questionOX, "content":content, "contentControversal":contentControversal, "contentNote":contentNote]
        
        //// 3. Selection들을 저장, Array
        var selections = [Any]()
        for sel in self.selections {
            guard let selUnwrapped = sel.createJsonDataTypeStructure() else {
                print("Creating Selection JSON Error While dealing with \(sel.question.key)-\(sel.selectNumber)")
                continue
            }
            selections.append(selUnwrapped)
        }
        
        //// 3. question의 완성 = label + question inforation + selections
        let question = ["label":self.key, "information":questionInfromation, "Selections":selections] as [String : Any]
        
        //// 4. json 형식인지 확인해서 그러하면 question json type structure 반환 아니면, nil
        guard JSONSerialization.isValidJSONObject(question) else {
            print("Creating Question JSON Error While dealing with \(self.key)")
            return nil
        }
        return question
    }
}

enum QuestionOX : String {
    case O //옳은 것
    case X //옳지 않은 것
    case Unknown
}

enum QuestionType : String {
    case Select // 고르시오
    case Find // 모두 고르시오
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

extension String {
    func spacing(_ space:Int, _ cutLength: Int = 39) -> String {
        // http://stackoverflow.com/questions/39677330/how-does-string-substring-work-in-swift-3
        // How does String substring work in Swift 3
        // 공부해야함 (+) 2017. 5. 4.
        
        var str = ""
        let chars = self.characters
        
        for (index,char) in chars.enumerated() {
            if index+1 < cutLength-space {
                str = str + char.description
            } else if (index+1) % (cutLength-space) == 0 {
                str = str + "\n" + String(repeating: " ", count: space)
                if char == " " {
                    continue
                }
                str = str + char.description
            } else {
                str = str + char.description
            }
        }
        return str
    }
}

