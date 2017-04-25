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
    var selectionsShuffled = [TestSelction]()
    var doesQuestionOXChanged = false
    var answerSelectionModifed : TestSelction?
    
    init(question : Question) {
        self.question = question
        self.selectionsShuffled = question.selections
        self.answerSelectionModifed = question.answerSelection
        
        // 정오변경 지문이 문제에 있는지 확인
        let isOppositeQuestionExist = question.contentControversal == nil ? false : true
        // 정오변경 지문이 선택지에 모두 있는지 확인
        var isAllSelectionControversalExist = true
        for sel in question.selections {
            if sel.contentControversal == nil {
                isAllSelectionControversalExist = false
            }
        }
        
        // OX를 변경할 문제유형인지 확인
        var isGonnaOXConvert = false
        if question.questionOX == QuestionOX.O || question.questionOX == QuestionOX.X  {
            isGonnaOXConvert = true
        }
        
        // 문제와 지문 OX변경을 실행
        if isOppositeQuestionExist, isAllSelectionControversalExist, isGonnaOXConvert { //문제와 지문 모두가 OX가 없으면 작업할 수 없음, 문제 타입도 OX타입이어야 함
            print("")
            print("!!!문제변경가능")
            if Bool.random() {
                doesQuestionOXChanged = true
                print("1. 문제와 선택지 OX 변경함")
            } else {
                print("1. 문제와 선택지 OX 변경안함")
            }
        }
        
        //선택지의 순서를 변경
        selectionsShuffled.shuffle()
        print("2. 선택지 순서 변경함")
        
    }
    
    func shuffling()  {
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
            printSelcect(select: sel, modifedNumber: index+1)
        }
        print("")
        
        /////////////////////
        //3. 정답 출력
        print("<정답>")
        let answerNumber = getAnswerNumber()
        if answerNumber != nil {
            printSelcect(select: answerSelectionModifed!, modifedNumber: answerNumber! + 1)
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
    func getSelectContent(selection : TestSelction) -> (content :String, iscOrrect : Bool?) {
        var selectionContentShuffled = selection.content
        var iscOrrectShuffled = selection.iscOrrect
        if doesQuestionOXChanged {
            selectionContentShuffled = selection.contentControversal!
            if iscOrrectShuffled! {
                iscOrrectShuffled = false
            } else {
                iscOrrectShuffled = true
            }
        }
        return (selectionContentShuffled, iscOrrectShuffled)
    }
    
    //선택지를 출력하는 함수, 선택지와 변경된 선택지를 입력받아 선택지를 문제의 논리에 맞게 변경한 값을 출력
    func printSelcect(select : TestSelction, modifedNumber : Int) {
        let selction = getSelectContent(selection: select)
        print("\((modifedNumber).roundInt) \(selction.content)")
        print("-\(select.selectNumber)- ", terminator : "")
        print(selction.iscOrrect ?? "not sure")
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



