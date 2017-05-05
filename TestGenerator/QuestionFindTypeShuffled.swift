//
//  QuestionFindTypeShuffled.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 4. 30..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Cocoa

class QuestionFindTypeShuffled: QuestionShuffled {
    
    override init?(question: Question) {
        if question.lists.count == 0 {
            print("error>> 목록선택지가 없음")
            return nil
        }
        if question.answerListSelections.count == 0 {
            print("error>> 목록선택지의 정답이 없음")
            return nil
        }
        
        super.init(question: question)
        
        self.lists = question.lists
        _ = _shufflingAndOXChangingAndChangingAnswerOfSelectionOfFindType()
    }
    
    func _shufflingAndOXChangingAndChangingAnswerOfSelectionOfFindType() -> Bool {
        let isSuccess = true
        lists.shuffle()
        selections.shuffle()
        
        print("")
        print("1. 목록선택지와 선택지 순서 변경함")
        
        // 2,3-1. 정오변경 지문이 문제에 있는지 확인
        let isOppositeQuestionExist = question.contentControversal == nil ? false : true
        // 2,3-2. 정오변경 지문이 목록선택지에 모두 있는지 확인
        var isAllSelectionListControversalExist = true
        for sel in question.lists {
            if sel.contentControversal == nil {
                isAllSelectionListControversalExist = false
            }
        }
        // 2,3-3. OX를 변경할 문제유형인지 확인
        var isGonnaOXConvert = false
        if question.questionOX == QuestionOX.O || question.questionOX == QuestionOX.X  {
            isGonnaOXConvert = true
        }

        // 2,3-4. 문제와 지문 모두가 OX가 없으면 작업할 수 없음, 문제 타입도 OX타입이어야 함
        if isOppositeQuestionExist, isAllSelectionListControversalExist,
            isGonnaOXConvert {
            
            // 2. 문제와 지문 OX변경을 실행
            if Bool.random() {
                isOXChanged = true
                print("2. 문제와 목록선택지 OX 변경함")
            } else {
                print("2. 문제와 목록선택지 OX 변경안함")
            }

            // 3. 임의로 답변을 변경
            let numberOfListSel = lists.count //5
            let numberOfAnsListSel = question.answerListSelections.count //3
            
            for index in 0...numberOfAnsListSel-1 {
                var cont = true
                while cont {
                    let randomNumber = Int(arc4random_uniform(UInt32(numberOfListSel)))
                    let randomListSel = lists[randomNumber]
                    if let _ = answerListSelectionModifed.index(where: {$0 === randomListSel}) {
                    } else {
                        answerListSelectionModifed.append(randomListSel)
                        originalShuffleMap.append((question.answerListSelections[index], randomListSel))
                        cont = false
                    }
                }
            }
            
            var tempListSelections = question.lists
            var tempListSelectionsShuffled = lists
            for ansSel in question.answerListSelections {
                if let ix = tempListSelections.index(where: {$0 === ansSel}) {
                    tempListSelections.remove(at: ix)
                }
            }
            for ansSel in answerListSelectionModifed {
                if let ix = tempListSelectionsShuffled.index(where: {$0 === ansSel}) {
                    tempListSelectionsShuffled.remove(at: ix)
                }
            }
            for index in 0...tempListSelectionsShuffled.count-1 {
                originalShuffleMap.append((tempListSelections[index], tempListSelectionsShuffled[index]))
            }
            print("3. 목록선택지 정답을 아래와 같이 변경")
            for (oriSel, shuSel) in originalShuffleMap {
                print("    원래 목록선택지:",oriSel.getListString(), " -> 변경:", shuSel.getListString())
            }
            isAnswerChanged = true
            // 3. 임의로 답변을 변경 끝
            // Array를 멋지게 이용해서 코드를 대폭 줄일 수 있는 방안을 연구해야 한다 (+) 2017. 4. 30.
        }
        
        return isSuccess
    }
    
//    func publish2() {
//        print("")
//        //1. 문제 출력
//        prtQuestion()
//        print("")
//        
////        //2-0. 선택지 출력
////        prtListSelection()
////        print("")
//        
//        //2. 답안지 출력
//        prtSelection()
//        print("")
//        
//        //3. 정답 출력
//        prtAnswer()
//        print("")
//    }

//    func prtListSelection() {
//        for (index,listSel) in listSelectionShuffled.enumerated() {
//            if index == 0 {
//                print("---------------------------------------------------------------------------------------------------------")
//            }
//            let listSelContent = getListSelectContent(listSelection: listSel)
//            print(listSel.getListString(int : index+1)+". "+listSelContent.content)
//            print("-\(listSel.getListString())-"," ",listSelContent.iscOrrect ?? "not sure")
//            if index == listSelectionShuffled.count-1 {
//                print("---------------------------------------------------------------------------------------------------------")
//            }
//        }
//    }
    
    
    
//    //1. 문제 출력
//    func prtQuestion() {
//        let questionModifed = getModifedQuestion()
//        print("[\(question.test.subject) \(question.test.date.yyyymmdd) \(question.test.category)] "+questionModifed.content, terminator : "")
//        if let contNote = question.contentNote {
//            print(" "+contNote)
//        } else {
//            print("")
//        }
//        print("\(question.questionType) \(questionModifed.questionOX)")
//    }
//    
//    func prtList() {
//        for (index,sel) in selections.enumerated() {
//            // isOXChanged을 확인하여 OX를 변경할 경우에 선택지출력할 때 변경할 내용들 확정
//            printSelect(select: sel, modifedNumber: index+1)
//        }
//        print("")
//    }
//    
//    func prtSelection() {
//        for (index,sel) in selections.enumerated() {
//            // isOXChanged을 확인하여 OX를 변경할 경우에 선택지출력할 때 변경할 내용들 확정
//            printSelect(select: sel, modifedNumber: index+1)
//        }
//        print("")
//    }
//    
//    func prtAnswer() {
//        print("<정답>")
//        printSelect(select: answerSelectionModifed, modifedNumber: getAnswerNumber() + 1)
//    }
//    
//    //선택지를 출력하는 함수, 선택지와 변경된 선택지를 입력받아 선택지를 문제의 논리에 맞게 변경한 값을 출력
//    func printSelect(select : Selection, modifedNumber : Int) {
//        let selction = getModfiedStatement(statement: select)
//        print("\((modifedNumber).roundInt) \(selction.content)")
//        print("-\(select.selectNumber)- ", terminator : "")
//        print(selction.iscOrrect ?? "not sure")
//    }
}
