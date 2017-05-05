//
//  QuestionShuffled.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 4. 10..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class QuestionShuffled : QShufflingManager {
    
    
    override init?(question : Question) {
        super.init(question: question)
        // 문제를 섞는 가장 중요한 함수
        _ = _shufflingAndOXChangingAndChangingAnswerOfSelection()
    }
    
    func _shufflingAndOXChangingAndChangingAnswerOfSelection() -> Bool {
        let isSuccess = true
        // 1. 선택지의 순서를 변경
        selectionsShuffled.shuffle()
        print("")
        print("1. 선택지 순서 변경함")
        
        // 2,3-1. 정오변경 지문이 문제에 있는지 확인
        let isOppositeQuestionExist = question.contentControversal == nil ? false : true
        
        // 2,3-2. 정오변경 지문이 선택지에 모두 있는지 확인
        var isAllSelectionControversalExist = true
        for sel in question.selections {
            if sel.contentControversal == nil {
                isAllSelectionControversalExist = false
            }
        }
        // 2,3-3. OX를 변경할 문제유형인지 확인
        var isGonnaOXConvert = false
        if question.questionOX == QuestionOX.O || question.questionOX == QuestionOX.X || question.questionOX == .Unknown {
            isGonnaOXConvert = true
        }
        
        // 2,3-4. 문제와 지문 모두가 OX가 없으면 작업할 수 없음, 문제 타입도 OX타입이어야 함
        if isOppositeQuestionExist, isAllSelectionControversalExist,
            isGonnaOXConvert {
            
            // 2. 문제와 지문 OX변경을 실행
            if Bool.random() {
                doesQuestionOXChanged = true
                print("2. 문제와 선택지 OX 변경함")
            } else {
                print("2. 문제와 선택지 OX 변경안함")
            }
            
            // 3. 임의로 답변을 변경
            // 3-1. 랜덤답안의 포인터를 선정
            
            doesQuestionAnswerChanged = true
            let _randomSelectionNumber = Int(arc4random_uniform(UInt32(selectionsShuffled.count)))
            answerSelectionModifed = selectionsShuffled[_randomSelectionNumber]
            print("3. 정답을 \(answerSelectionModifed.selectNumber)(원본 문제기준), \(getAnswerNumber()+1)(섞인 문제기준)으로 변경함")
        }
        return isSuccess
    }
    
    // 선택지를 문제의 논리에 맞게 변경하여 반환
    // 필요한 입력 - 반환해서 돌려줄 선택지(함수입력), OX를 변환한 문제인지(doesQuestionOXChanged, 클래스의 프로퍼티), 변경한 정답(answerSelectionModifed, 클래스의 프로퍼티)
    override func getStatementContent(statement : Statement) -> (content :String, iscOrrect : Bool?, isAnswer : Bool?) {
        guard let selection = statement as? Selection else {
            fatalError("\(statement.question.key) 문제는 선택지 내용을 변환할 수 없기 때문에 섞을 수 없음")
        }
        return _getStatementContent(statement : selection)
    }
    
    func _getStatementContent(statement : Selection) -> (content :String, iscOrrect : Bool?, isAnswer : Bool?) {
        // 1. 기본
        var selectionContentShuffled = statement.content
        var iscOrrectShuffled = statement.iscOrrect
        // 정답출력에 대해서 좀더 고민 필요 2017. 5. 5. (+)
        var isAnswerShuffled = statement.isAnswer
        
        // 2. 질문의 OX를 변경을 확인
        if doesQuestionOXChanged {
            selectionContentShuffled = _toggleSelectionContent(selectionContentShuffled: selectionContentShuffled, selection: statement)
            iscOrrectShuffled = _toggleIsCorrect(iscOrrectShuffled: iscOrrectShuffled)
        }
        
        // 3. 랜덤하게 변경된 정답에 맞춰 수정
        if doesQuestionAnswerChanged {
            if isAnswerShuffled {
                // 3-1. 출력하려는 선택지가 답이고(selection.isAnswer = true) 랜덤으로 선정된 정답포인터가 아니면(self <> answerSelectionModifed) T/F를 반전
                // 3-2. 출력하려는 선택지가 답이고(selction.isAnswer = true) 랜덤으로 선정된 정답포인터면(self = answerSelectionModifed) T/F를 유지
                if statement !== answerSelectionModifed {
                    selectionContentShuffled = _toggleSelectionContent(selectionContentShuffled: selectionContentShuffled, selection: statement)
                    iscOrrectShuffled = _toggleIsCorrect(iscOrrectShuffled: iscOrrectShuffled)
                    isAnswerShuffled = !isAnswerShuffled
                } else {
                }
            } else {
                // 3-3. 출력하려는 선택지가 답이아니고(selection.isAnswer = true) 랜덤으로 선정된 정답포인터면(self = answerSelectionModifed) T/F를 변경
                // 3-4. 출력하려는 선택지가 답이아니고(selection.isAnswer = true) 랜덤으로 선정된 정답포인터가 아니면(self <> answerSelectionModifed) T/F를 유지
                if statement === answerSelectionModifed {
                    selectionContentShuffled = _toggleSelectionContent(selectionContentShuffled: selectionContentShuffled, selection: statement)
                    iscOrrectShuffled = _toggleIsCorrect(iscOrrectShuffled: iscOrrectShuffled)
                    isAnswerShuffled = !isAnswerShuffled
                } else {
                }
                
            }

        }
        return (selectionContentShuffled, iscOrrectShuffled, isAnswerShuffled)
    }
}




