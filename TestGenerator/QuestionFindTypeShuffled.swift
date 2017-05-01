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
    var originalShuffleMap = [(original : Selection, shuffled : Selection)]()
    var answerListSelectionModifed = [Selection]()
    
    override init?(question: Question) {
        if question.listSelections.count == 0 {
            print("error>> 목록선택지가 없음")
            return nil
        }
        if question.answerListSelections.count == 0 {
            print("error>> 목록선택지의 정답이 없음")
            return nil
        }
        self.listSelectionShuffled = question.listSelections
        
        super.init(question: question)
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
        if showSolution {
            prtAnswer()
            print("")
        }
    }
    
    
    
    func prtListSelection() {
        for (index,listSel) in listSelectionShuffled.enumerated() {
            if index == 0 {
                print("---------------------------------------------------------------------------------------------------------")
            }
            let listSelContent = getListSelectContent(listSelection: listSel)
            print(listSel.getListString(int : index+1)+". "+listSelContent.content)
            if showSolution {
                print("-\(listSel.getListString())-"," ",listSelContent.iscOrrect ?? "not sure")
            }
            if index == listSelectionShuffled.count-1 {
                print("---------------------------------------------------------------------------------------------------------")
            }
        }
    }
    
    override func _shufflingAndOXChangingAndChangingAnswerOfSelection() -> Bool {
        let isSuccess = true
        listSelectionShuffled.shuffle()
        selectionsShuffled.shuffle()
        
        print("")
        print("1. 목록선택지와 선택지 순서 변경함")
        
        // 2,3-1. 정오변경 지문이 문제에 있는지 확인
        let isOppositeQuestionExist = question.contentControversal == nil ? false : true
        // 2,3-2. 정오변경 지문이 목록선택지에 모두 있는지 확인
        var isAllSelectionListControversalExist = true
        for sel in question.listSelections {
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
                doesQuestionOXChanged = true
                print("2. 문제와 목록선택지 OX 변경함")
            } else {
                print("2. 문제와 목록선택지 OX 변경안함")
            }
            
            // 3. 임의로 답변을 변경
            let numberOfListSel = listSelectionShuffled.count //5
            let numberOfAnsListSel = question.answerListSelections.count //3
            
            for index in 0...numberOfAnsListSel-1 {
                var cont = true
                while cont {
                    let randomNumber = Int(arc4random_uniform(UInt32(numberOfListSel)))
                    let randomListSel = listSelectionShuffled[randomNumber]
                    if let _ = answerListSelectionModifed.index(where: {$0 === randomListSel}) {
                    } else {
                        answerListSelectionModifed.append(randomListSel)
                        originalShuffleMap.append((question.answerListSelections[index], randomListSel))
                        cont = false
                    }
                }
            }
            
            var tempListSelections = question.listSelections
            var tempListSelectionsShuffled = listSelectionShuffled
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
            doesQuestionAnswerChanged = true
            // 3. 임의로 답변을 변경 끝
            // Array를 멋지게 이용해서 코드를 대폭 줄일 수 있는 방안을 연구해야 한다 (+) 2017. 4. 30.
        }
        
        return isSuccess
    }
    
    override func getSelectContent(selection : Selection) -> (content :String, iscOrrect : Bool?) {
        // 1. 기본
        var selectionContentShuffled = ""
        var selectionContentShuffledArray = [String]()
        var listSelInSelectionContentShuffled = [Selection]()
        let iscOrrectShuffled : Bool? = nil
        
        for listSel in selection.contentSelectionsList {
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
            if let index = listSelectionShuffled.index(where: {$0 === listSel}) {
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
        return (selectionContentShuffled, iscOrrectShuffled)
    }
    
    func getListSelectContent(listSelection : Selection) -> (content : String, iscOrrect : Bool?) {
        // 1. 기본
        var listSelContentShuffled = listSelection.content
        var iscOrrectShuffled = listSelection.iscOrrect
        
        // 2. 질문의 OX를 변경을 확인
        if doesQuestionOXChanged {
            listSelContentShuffled = _toggleSelectionContent(selectionContentShuffled: listSelContentShuffled, selection: listSelection)
            iscOrrectShuffled = _toggleIsCorrect(iscOrrectShuffled: iscOrrectShuffled)
        }
        
        // 3. 랜덤하게 변경된 정답에 맞춰 수정
        if doesQuestionAnswerChanged{
            if listSelection.isAnswer {
                // 3-1. 출력하려는 선택지가 답이고(selection.isAnswer = true) 랜덤으로 선정된 정답포인터가 아니면(self <> answerSelectionModifed) T/F를 반전
                // 3-2. 출력하려는 선택지가 답이고(selction.isAnswer = true) 랜덤으로 선정된 정답포인터면(self = answerSelectionModifed) T/F를 유지
                if let _ = answerListSelectionModifed.index(where: {$0 === listSelection}) {
                } else {
                    listSelContentShuffled = _toggleSelectionContent(selectionContentShuffled: listSelContentShuffled, selection: listSelection)
                    iscOrrectShuffled = _toggleIsCorrect(iscOrrectShuffled: iscOrrectShuffled)
                }
            } else {
                // 3-3. 출력하려는 선택지가 답이아니고(selection.isAnswer = true) 랜덤으로 선정된 정답포인터면(self = answerSelectionModifed) T/F를 변경
                // 3-4. 출력하려는 선택지가 답이아니고(selection.isAnswer = true) 랜덤으로 선정된 정답포인터가 아니면(self <> answerSelectionModifed) T/F를 유지
                if let _ = answerListSelectionModifed.index(where: {$0 === listSelection}) {
                    listSelContentShuffled = _toggleSelectionContent(selectionContentShuffled: listSelContentShuffled, selection: listSelection)
                    iscOrrectShuffled = _toggleIsCorrect(iscOrrectShuffled: iscOrrectShuffled)
                } else {
                }
            }
        }
        return (listSelContentShuffled, iscOrrectShuffled)
    }

}
