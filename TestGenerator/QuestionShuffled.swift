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
    
    var selections = [Selection]() //출력
    var lists = [List]() //출력
    
    
    //공통, 초기화 단계에서 꼭 정답의 존재를 확인해야 함
    var answerSelectionModifed : Selection  //출력
    var isOXChanged = false  //출력
    var isAnswerChanged = false  //출력
    
    //Find유형 문제용
    var originalShuffleMap = [(original : List, shuffled : List)]()
    var answerListSelectionModifed = [List]()
    
    
    init?(question : Question) {
        // http://stackoverflow.com/questions/34560768/can-i-throw-from-class-init-in-swift-with-constant-string-loaded-from-file
        // Can I throw from class init() in Swift with constant string loaded from file?, 초기화 단계에서 정답의 존재가 없다면 에러를 발생하다록 추후 수정(-) 2017. 4. 26.
        //http://stackoverflow.com/questions/31038759/conditional-binding-if-let-error-initializer-for-conditional-binding-must-hav
        //conditional binding에 관하여

        // 주어진 문제에 답이 있는지 확인
        guard let ansSel = question.answerSelection else {
            print("\(question.key) Shuffling하려하니 문제 정답이 없음")
            return nil
        }
        // 완성 2017. 4. 26.

        guard question.selections.count != 0 else {
            print("\(question.key) Shuffling하려하니 문제 선택지가 없음")
            return nil
        }

        // 0. 문제, 목록, 선택지, 정답의 주소를 저장
        self.question = question
        self.lists = question.lists //하나도 없어도 셔플링은 가능할 것, Find 유형 문제일 때 에러체크를 하는게 좋을까?
        self.selections = question.selections
        self.answerSelectionModifed = ansSel
        
        // 추후 계속 초기화 단계의 에러체크를 추가합시다. (+) 2017. 5. 4.

        // 문제를 섞는 가장 중요한 함수
        _ = _shufflingAndOXChangingAndChangingAnswerOfSelection()
    }
    
    // 문제를 논리에 맞게 변경하여 반환
    func getModifedQuestion() -> (questionOX : QuestionOX, content : String) {
        var questionShuffledOX = question.questionOX
        var questionContent = question.content
        
        // isOXChanged을 확인하여 OX를 변경할 경우에 선택지출력할 때 변경할 내용들 확정
        if isOXChanged {
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
    // 필요한 입력 - 반환해서 돌려줄 선택지(함수입력), OX를 변환한 문제인지(isOXChanged, 클래스의 프로퍼티), 변경한 정답(answerSelectionModifed, 클래스의 프로퍼티)
    
//    func getModfiedStatement(statement : Statement) -> (content :String, iscOrrect : Bool?, isAnswer : Bool?) {
//        guard let selection = statement as? Selection else {
//            fatalError("\(statement.question.key) 문제는 선택지 내용을 변환할 수 없기 때문에 섞을 수 없음")
//        }
//        return getModfiedStatement(statement : selection)
//    }
    
    func getModfiedStatement(statement : Statement) -> (content :String, iscOrrect : Bool?, isAnswer : Bool?) {
        
        // 1. 기본
        var selectionContentShuffled = statement.content
        var iscOrrectShuffled = statement.iscOrrect
        
        // 정답출력에 대해서 좀더 고민 필요 2017. 5. 5. (+), 
        // 고민중..일단 정답이 nil이면 이는 내용을 변경할 여지가 없는 것이니 원래 내용을 반환하도록 짜보고 있음
        // 문제의 ox를 바꾸거나 정답을 바꿀 때 선택지들의 isAnswer가 존재하는지를 체크하는게 필요할 듯
        if statement.isAnswer == nil {
            return (selectionContentShuffled, iscOrrectShuffled, nil)
        }
        var isAnswerShuffled = statement.isAnswer!
        
        // 2. 질문의 OX를 변경을 확인
        if isOXChanged {
            selectionContentShuffled = _toggleStatementContent(selectionContentShuffled: selectionContentShuffled, selection: statement)
            iscOrrectShuffled = _toggleIsCorrect(iscOrrectShuffled: iscOrrectShuffled)
        }
        
        // 3. 랜덤하게 변경된 정답에 맞춰 수정
        if isAnswerChanged {
            if isAnswerShuffled {
                // 3-1. 출력하려는 선택지나 목록이 답이고(statement.isAnswer = true) 랜덤으로 선정된 정답포인터가 아니면(self <> answerStatement) T/F를 반전
                // 3-2. 출력하려는 선택지가 답이고(statement.isAnswer.isAnswer = true) 랜덤으로 선정된 정답포인터면(self = answerStatement) T/F를 유지
                //      정답포인터와의 비교는 statement가 list인가 selection인가에 따라 다르므로 그에 맞게 statementIsAnswer 함수로 비교함
                if !statementIsAnswer(statement) {
                    selectionContentShuffled = _toggleStatementContent(selectionContentShuffled: selectionContentShuffled, selection: statement)
                    iscOrrectShuffled = _toggleIsCorrect(iscOrrectShuffled: iscOrrectShuffled)
                    isAnswerShuffled = !isAnswerShuffled
                } else {
                }
            } else {
                // 3-3. 출력하려는 선택지가 답이아니고(statement.isAnswer = true) 랜덤으로 선정된 정답포인터면(self = answerSelectionModifed) T/F를 변경
                // 3-4. 출력하려는 선택지가 답이아니고(statement.isAnswer = true) 랜덤으로 선정된 정답포인터가 아니면(self <> answerSelectionModifed) T/F를 유지
                if statementIsAnswer(statement) {
                    selectionContentShuffled = _toggleStatementContent(selectionContentShuffled: selectionContentShuffled, selection: statement)
                    iscOrrectShuffled = _toggleIsCorrect(iscOrrectShuffled: iscOrrectShuffled)
                    isAnswerShuffled = !isAnswerShuffled
                } else {
                }
            }

        }
        return (selectionContentShuffled, iscOrrectShuffled, isAnswerShuffled)
    }
    
    // getModfiedStatement에서 사용하는 statement가 정답인지 아닌지를 확인하는 함수
    // 하나라도 있기만 하면 true반환이니 병렬적으로 체크하나 좀 찝찝하긴 하나 크게 상관 없을 듯
    func statementIsAnswer(_ statement: Statement) -> Bool {
        var isSame = false
        
        if answerSelectionModifed === statement {
            isSame = true
        }
        if let _ = answerListSelectionModifed.index(where: {$0 === statement}) {
            isSame = true
        }
        
        return isSame
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
    
    func _toggleStatementContent(selectionContentShuffled : String, selection : Statement) -> String {
        if selectionContentShuffled == selection.contentControversal  {
            return selection.content
        } else {
            return selection.contentControversal!
        }
    }
    
    // selections 배열 안에서 정답의 Index(정답번호-1)을 반환
    func getAnswerNumber() -> Int {
        //http://stackoverflow.com/questions/24028860/how-to-find-index-of-list-item-in-swift
        //How to find index of list item in Swift?, index의 출력 형식 공부해야함 2017. 4. 25.
        guard let ansNumber = selections.index(where: {$0 === answerSelectionModifed}) else {
            fatalError("error>>getAnswerNumber 실패함")
        }
        return ansNumber
    }
    
    func getListContent(selection : Selection) -> (content :String, iscOrrect : Bool?, isAnswer : Bool?) {
        // 1. 기본
        var selectionContentShuffled = ""
        var selectionContentShuffledArray = [String]()
        var listSelInSelectionContentShuffled = [List]()
        let iscOrrectShuffled : Bool? = nil
        
        // 조금더 정밀하게 고민 필요 2017. 5. 5.
        let isAnswerShuffled : Bool? = true
        
        for listSel in selection.listInContentOfSelection {
            if originalShuffleMap.count > 0 {
                for (ori, shu) in originalShuffleMap {
                    if ori === listSel {
                        listSelInSelectionContentShuffled.append(shu)
                    }
                }
            } else {
                listSelInSelectionContentShuffled.append(listSel)
            }
        }
        for listSel in listSelInSelectionContentShuffled {
            //            print("listSel.getListString()",listSel.getListString())
            if let index = lists.index(where: {$0 === listSel}) {
                selectionContentShuffledArray.append(listSel.getListString(int: index + 1))
            }
        }
        selectionContentShuffledArray.sort()
        for (index, selCon) in selectionContentShuffledArray.enumerated() {
            if index == 0 {
                selectionContentShuffled = selCon
            } else {
                selectionContentShuffled = "\(selectionContentShuffled), \(selCon)"
            }
        }
        return (selectionContentShuffled, iscOrrectShuffled, isAnswerShuffled)
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

//Select 유형 문제에서 사용하는 함수
extension QuestionShuffled {
    func _shufflingAndOXChangingAndChangingAnswerOfSelection() -> Bool {
        let isSuccess = true
        // 1. 선택지의 순서를 변경
        selections.shuffle()
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
                isOXChanged = true
                print("2. 문제와 선택지 OX 변경함")
            } else {
                print("2. 문제와 선택지 OX 변경안함")
            }
            
            // 3. 임의로 답변을 변경
            // 3-1. 랜덤답안의 포인터를 선정
            
            isAnswerChanged = true
            let _randomSelectionNumber = Int(arc4random_uniform(UInt32(selections.count)))
            answerSelectionModifed = selections[_randomSelectionNumber]
            print("3. 정답을 \(answerSelectionModifed.selectNumber)(원본 문제기준), \(getAnswerNumber()+1)(섞인 문제기준)으로 변경함")
        }
        return isSuccess
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





