//
//  QuestionShuffled.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 4. 10..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class QuestionShuffled {
    let question : Question
    var selectionsShuffled = [Selection]()
    var listSelectionsShuffled = [Selection]()
    var answerSelectionModifed : Selection //초기화 단계에서 꼭 정답의 존재를 확인해야 함
    var doesQuestionOXChanged = false
    
    init?(question : Question) {
        
        // 0. 문제, 선택지, 정답의 주소를 저장
        self.question = question
        self.selectionsShuffled = question.selections
        self.listSelectionsShuffled = question.listSelections
        
        // http://stackoverflow.com/questions/34560768/can-i-throw-from-class-init-in-swift-with-constant-string-loaded-from-file
        // Can I throw from class init() in Swift with constant string loaded from file?, 초기화 단계에서 정답의 존재가 없다면 에러를 발생하다록 추후 수정(-) 2017. 4. 26.
        //http://stackoverflow.com/questions/31038759/conditional-binding-if-let-error-initializer-for-conditional-binding-must-hav
        //conditional binding에 관하여
        guard let ansSel = question.answerSelection else {
            print("Error!!! 문제에 정답이 없음")
            return nil
        }
        self.answerSelectionModifed = ansSel
        // 완성 2017. 4. 26.

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
        if question.questionOX == QuestionOX.O || question.questionOX == QuestionOX.X  {
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
            
            let _randomSelectionNumber = Int(arc4random_uniform(UInt32(selectionsShuffled.count)))
            answerSelectionModifed = selectionsShuffled[_randomSelectionNumber]
            print("3. 정답을 \(answerSelectionModifed.selectNumber)(원본 문제기준), \(getAnswerNumber()!+1)(섞인 문제기준)으로 변경함")
        }
    }
    
    // 내용 출력
    func publish() {
        print("")
        
        //////////////////////
        //1. 문제 출력
        let questionModifed = getModifedQuestion()
        print("[\(question.testSubject) \(question.testDate) \(question.testCategory)] "+questionModifed.content, terminator : "")
        if let contNote = question.contentNote {
            print(" "+contNote)
        } else {
            print("")
        }
        print("\(question.questionType) \(questionModifed.questionOX)")
        print("")
        
        /////////////////////
        //2. 답안지 출력
        for (index,sel) in selectionsShuffled.enumerated() {
            // doesQuestionOXChanged을 확인하여 OX를 변경할 경우에 선택지출력할 때 변경할 내용들 확정
            printSelect(select: sel, modifedNumber: index+1)
        }
        print("")
        
        /////////////////////
        //3. 정답 출력
        print("<정답>")
        let answerNumber = getAnswerNumber()
        if answerNumber != nil {
            printSelect(select: answerSelectionModifed, modifedNumber: answerNumber! + 1)
        }
    }
    
    // selectionsShuffled 배열 안에서 정답의 Index(정답번호-1)을 반환
    func getAnswerNumber() -> Int? {
        //http://stackoverflow.com/questions/24028860/how-to-find-index-of-list-item-in-swift
        //How to find index of list item in Swift?, index의 출력 형식 공부해야함 2017. 4. 25.
        return selectionsShuffled.index(where: {$0 === answerSelectionModifed})
    }
    
    // 문제를 논리에 맞게 변경하여 반환
    func getModifedQuestion() -> (questionOX : QuestionOX, content : String) {
        var questionShuffledOX = question.questionOX
        var questionContent = question.content
        
        // doesQuestionOXChanged을 확인하여 OX를 변경할 경우에 선택지출력할 때 변경할 내용들 확정
        if doesQuestionOXChanged {
            if questionShuffledOX == QuestionOX.O {
                questionShuffledOX = QuestionOX.X
            } else {
                questionShuffledOX = QuestionOX.O
            }
            questionContent = question.contentControversal!
        }
        return (questionShuffledOX,questionContent)
    }
    
    // 선택지를 문제의 논리에 맞게 변경하여 반환
    // 필요한 입력 - 반환해서 돌려줄 선택지(함수입력), OX를 변환한 문제인지(doesQuestionOXChanged, 클래스의 프로퍼티), 변경한 정답(answerSelectionModifed, 클래스의 프로퍼티)
    func getSelectContent(selection : Selection) -> (content :String, iscOrrect : Bool?) {
        var selectionContentShuffled = selection.content
        var iscOrrectShuffled = selection.iscOrrect
        
        // 2. 질문의 OX를 변경을 확인
        if doesQuestionOXChanged {
            selectionContentShuffled = toggleSelectionContent(selectionContentShuffled: selectionContentShuffled, selection: selection)
            iscOrrectShuffled = toggleIsCorrect(iscOrrectShuffled: iscOrrectShuffled!)
        }
        
        // 3. 랜덤하게 변경된 정답에 맞춰 수정
        if selection.isAnswer {
            // 3-1. 출력하려는 선택지가 답이고(selection.isAnswer = true) 랜덤으로 선정된 정답포인터가 아니면(self <> answerSelectionModifed) T/F를 반전
            // 3-2. 출력하려는 선택지가 답이고(selction.isAnswer = true) 랜덤으로 선정된 정답포인터면(self = answerSelectionModifed) T/F를 유지
            if selection !== answerSelectionModifed {
                selectionContentShuffled = toggleSelectionContent(selectionContentShuffled: selectionContentShuffled, selection: selection)
                iscOrrectShuffled = toggleIsCorrect(iscOrrectShuffled: iscOrrectShuffled!)
            } else {
            }
        } else {
            // 3-3. 출력하려는 선택지가 답이아니고(selection.isAnswer = true) 랜덤으로 선정된 정답포인터면(self = answerSelectionModifed) T/F를 변경
            // 3-4. 출력하려는 선택지가 답이아니고(selection.isAnswer = true) 랜덤으로 선정된 정답포인터가 아니면(self <> answerSelectionModifed) T/F를 유지
            if selection === answerSelectionModifed {
                selectionContentShuffled = toggleSelectionContent(selectionContentShuffled: selectionContentShuffled, selection: selection)
                iscOrrectShuffled = toggleIsCorrect(iscOrrectShuffled: iscOrrectShuffled!)
            } else {
            }
            
        }
        return (selectionContentShuffled, iscOrrectShuffled)
    }
    
    //선택지를 출력하는 함수, 선택지와 변경된 선택지를 입력받아 선택지를 문제의 논리에 맞게 변경한 값을 출력
    func printSelect(select : Selection, modifedNumber : Int) {
        let selction = getSelectContent(selection: select)
        print("\((modifedNumber).roundInt) \(selction.content)")
        print("-\(select.selectNumber)- ", terminator : "")
        print(selction.iscOrrect ?? "not sure")
    }
    
    func toggleIsCorrect(iscOrrectShuffled : Bool) -> Bool{
        if iscOrrectShuffled {
            return false
        } else {
            return true
        }
    }
    
    func toggleSelectionContent(selectionContentShuffled : String, selection : Selection) -> String {
        if selectionContentShuffled == selection.contentControversal  {
            return selection.content
        } else {
            return selection.contentControversal!
        }
    }
}


//http://stackoverflow.com/questions/24026510/how-do-i-shuffle-an-array-in-swift
//How do I shuffle an array in Swift?
//담에 구조를 공부합시다. 2017. 4. 8.

extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}


//http://stackoverflow.com/questions/34240931/creating-random-bool-in-swift-2
//Creating random Bool in Swift 2

extension Bool {
    static func random() -> Bool {
        return arc4random_uniform(2) == 0
    }
}


