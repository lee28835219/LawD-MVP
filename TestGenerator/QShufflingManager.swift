//
//  QShufflingManager.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 4..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class QShufflingManager {
    
    let question : Question
    //초기화 단계에서 꼭 정답의 존재를 확인해야 함
    var answerSelectionModifed : Selection  //출력
    var selectionsShuffled = [Selection]() //출력
    
    var doesQuestionOXChanged = false  //출력
    var doesQuestionAnswerChanged = false  //출력
    
    
    init?(question: Question) {
        self.question = question
        
        // http://stackoverflow.com/questions/34560768/can-i-throw-from-class-init-in-swift-with-constant-string-loaded-from-file
        // Can I throw from class init() in Swift with constant string loaded from file?, 초기화 단계에서 정답의 존재가 없다면 에러를 발생하다록 추후 수정(-) 2017. 4. 26.
        //http://stackoverflow.com/questions/31038759/conditional-binding-if-let-error-initializer-for-conditional-binding-must-hav
        //conditional binding에 관하여
        
        // 주어진 문제에 답이 있는지 확인
        guard let ansSel = question.answerSelection else {
            print("Failed<<<\(question.test.category) Shuffling하려하니 문제 정답이 없음")
            return nil
        }
        self.answerSelectionModifed = ansSel
        // 완성 2017. 4. 26.
        
        // 0. 문제, 선택지, 정답의 주소를 저장
        guard question.selections.count != 0 else {
            print("Failed<<<\(question.number) Shuffling하려하니 문제 선택지가 없음")
            return nil
        }
        
        self.selectionsShuffled = question.selections
        
        
        // 추후 계속 초기화 단계의 에러체크를 추가합시다. (+) 2017. 5. 4.
    }
    
    func _toggleIsCorrect(iscOrrectShuffled : Bool?) -> Bool?{
        if let iscOr = iscOrrectShuffled {
            if iscOr {
                return false
            } else {
                return true
            }
        } else {
            return nil
        }
        
    }
    
    func _toggleSelectionContent(selectionContentShuffled : String, selection : Selection) -> String {
        if selectionContentShuffled == selection.contentControversal  {
            return selection.content
        } else {
            return selection.contentControversal!
        }
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
    
    // selectionsShuffled 배열 안에서 정답의 Index(정답번호-1)을 반환
    func getAnswerNumber() -> Int {
        //http://stackoverflow.com/questions/24028860/how-to-find-index-of-list-item-in-swift
        //How to find index of list item in Swift?, index의 출력 형식 공부해야함 2017. 4. 25.
        guard let ansNumber = selectionsShuffled.index(where: {$0 === answerSelectionModifed}) else {
            fatalError("error>>getAnswerNumber 실패함")
        }
        return ansNumber
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
