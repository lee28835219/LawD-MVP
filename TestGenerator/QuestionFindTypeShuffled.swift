//
//  QuestionFindTypeShuffled.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 4. 30..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Cocoa

class QuestionFindTypeShuffled: QuestionShuffled {
    var listSelectionShuffled = [Selection]()
    var answerListSelectionModifed = [Selection]()
    
    override init?(question: Question) {
        super.init(question: question)
        if question.listSelections.count == 0 {
            print("error>> 목록선택지가 없음")
            return nil
        }
        if question.answerListSelections.count == 0 {
            print("error>> 목록선택지의 정답이 없음")
            return nil
        }
        self.listSelectionShuffled = question.listSelections
        self.answerListSelectionModifed = question.answerListSelections
        
        _ = _shufflingAndOXChangingAndChangingAnswerOfListSelection()
    }
    
    override func publish() {
        print("")
        //1. 문제 출력
        prtQuestion()
        print("")
        
        //2-0. 선택지 출력
        prtListSelection()
        print("")
        
        //2. 답안지 출력
        prtSelection()
        print("")
        
        //3. 정답 출력
        prtAnswer()
        print("")
    }
    
    func prtListSelection() {
        for (index,listSel) in listSelectionShuffled.enumerated() {
            if index == 0 {
                print("------------------------------------------------------------------------------")
            }
            print(listSel.getListString(int : index+1)+". "+listSel.content)
            print("-\(listSel.getListString())-"," ",listSel.iscOrrect ?? "not sure")
            if index == listSelectionShuffled.count-1 {
                print("------------------------------------------------------------------------------")
            }
        }
    }
    
    func _shufflingAndOXChangingAndChangingAnswerOfListSelection() -> Bool {
        let isSuccess = true
        listSelectionShuffled.shuffle()
        print("")
        print("1. 목록선택지 순서 변경함")
        
        return isSuccess
    }

}
