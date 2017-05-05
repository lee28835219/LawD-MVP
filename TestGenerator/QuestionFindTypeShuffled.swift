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
//        _ = _shufflingAndOXChangingAndChangingAnswerOfSelectionOfFindType()
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
