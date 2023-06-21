//
//  Solver+Essential.swift
//  TestGenerator
//
//  Created by Masterbuilder on 2023/06/17.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import Foundation

extension Solver {
    // 문제변경이 있을 경우, 기본적으로 선택지의 순서를 변경하는 것이 좋으므로, 선택지 순서를 변경하는 함수를 공통으로 정의함.
    // 이 함수는 changeSelectTypeQuestion, changeFindTypeQuestion, init(_ question : Question, gonnaShuffle : Bool = false) 함수에서 사용됨.
    // 이는 각각 question.questionType.Select, question.questionType.Find, question.questionType.Unknown 문제타입에서 사용됨.
    func changeCommonTypeQuestionSelections() -> [Selection] {
        // 1. 선택지의 순서를 변경
        log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "--1. 선택지 순서 변경함")
        return selections.shuffled()
    }

    // 이 앱의 존재이유를 보여주는 함수. ★★★★★★★★★★★★★★★★★
    func changeSelectTypeQuestion() -> (selections : [Selection], isOXChanged : Bool, isAnswerChanged : Bool, answerSelectionModifed : Selection) {
        
        let selections = changeCommonTypeQuestionSelections()
        var isOXChanged = false
        var isAnswerChanged = false
        var answerSelectionModifed : Selection = self.answerSelectionModifed!
        
        // 2,3-1. 정오변경 지문이 문제에 있는지 확인
        let isOppositeQuestionExist = question.notContent == nil ? false : true
        
        // 2,3-2. 정오변경 지문이 선택지에 모두 있는지 확인
        var isAllSelectionControversalExist = true
        for sel in question.selections {
            if sel.notContent == nil {
                isAllSelectionControversalExist = false
            }
        }
        // 2,3-3. OX를 변경할 문제유형인지 확인
        var isGonnaOXConvert = false
        if question.questionOX == QuestionOX.O || question.questionOX == QuestionOX.X {
            isGonnaOXConvert = true
        }
        
        // 2,3-4. 문제와 지문 모두가 OX가 없으면 작업할 수 없음, 문제 타입도 OX타입이어야 함
        // ★★★★★★ 앱에서 가장 중요한 이 함수에서 가장 중요한 작업을 수행하는 부분
        if isOppositeQuestionExist, isAllSelectionControversalExist,
           isGonnaOXConvert {
            isOXChangable = true
            
            // 2. 문제와 지문 OX변경을 실행
            if Bool.random() {
                isOXChanged = true
                log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "--2. 문제와 선택지 OX 변경함")
            } else {
                log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "--2. 문제와 선택지 OX 변경안함")
            }
            
            // 3. 임의로 답변을 변경
            // 3-1. 랜덤답안의 포인터를 선정
            
            isAnswerChanged = true
            let _randomSelectionNumber = Int(arc4random_uniform(UInt32(selections.count)))
            answerSelectionModifed = selections[_randomSelectionNumber]
            //http://stackoverflow.com/questions/24028860/how-to-find-index-of-list-item-in-swift
            //How to find index of list item in Swift?, index의 출력 형식 공부해야함 2017. 4. 25.
            guard let ansNumber = selections.index(where: {$0 === answerSelectionModifed}) else {
                fatalError("--\(question.key) 변형문제의 정답찾기 실패")
            }
            log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "--3. 정답을 \(answerSelectionModifed.number)(원본 문제기준), \(ansNumber+1)(섞인 문제기준)으로 변경함")
        }
        return (selections, isOXChanged, isAnswerChanged, answerSelectionModifed)
    }
    
    // 이 앱의 존재이유를 보여주는 함수 열거타입. ★★★★★★★★★★★★★★★★★
    func changeFindTypeQuestion() -> (selections : [Selection], isOXChanged : Bool, answerListSelectionModifed : [ListSelection], originalShuffleMap : [(ListSelection, ListSelection)], isAnswerChanged : Bool){
        
        let selections = changeCommonTypeQuestionSelections()
        var isOXChanged = false
        var answerListSelectionModifed = [ListSelection]()
        var originalShuffleMap = [(ListSelection, ListSelection)]()
        var isAnswerChanged = false
        
        // 일단 FindCorrect 타입 질문이면 지문을 섞지 않음 향후 예도 정보를 읽어서 섞도록 하면 좋을 것 2017. 5. 12. (+)
        // 최종 업무가 되겠지~
        switch question.questionOX {
        case .O:
            _ = true
        case .X:
            _ = true
        case .Correct:
            return (selections, isOXChanged, answerListSelectionModifed, originalShuffleMap, isAnswerChanged)
        case .Unknown:
            return (selections, isOXChanged, answerListSelectionModifed, originalShuffleMap, isAnswerChanged)
        }
        
        lists.shuffle()
        log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "--1. 선택지 순서 변경함")
        
        // 2,3-1. 정오변경 지문이 문제에 있는지 확인
        let isOppositeQuestionExist = question.notContent == nil ? false : true
        
        // 2,3-2. 정오변경 지문이 목록에 모두 있는지 확인
        var isAllSelectionListControversalExist = true
        for sel in question.lists {
            if sel.notContent == nil {
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
            
            isOXChangable = true
            
            // 2. 문제와 지문 OX변경을 실행
            if Bool.random() {
                isOXChanged = true
                log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "--2. 문제와 목록선택지 OX 변경함")
            } else {
                log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "--2. 문제와 목록선택지 OX 변경안함")
            }
            
            // 3. 임의로 답변을 변경
            let numberOfListSel = lists.count //5
            let numberOfAnsListSel = question.answerLists.count //3
            
            for index in 0..<numberOfAnsListSel {
                var cont = true
                while cont {
                    let randomNumber = Int(arc4random_uniform(UInt32(numberOfListSel)))
                    let randomListSel = lists[randomNumber]
                    if let _ = answerListSelectionModifed.index(where: {$0 === randomListSel}) {
                    } else {
                        answerListSelectionModifed.append(randomListSel)
                        originalShuffleMap.append((question.answerLists[index], randomListSel))
                        cont = false
                    }
                }
            }
            
            var tempListSelections = question.lists
            var tempListSelectionsShuffled = lists
            for ansSel in question.answerLists {
                if let ix = tempListSelections.index(where: {$0 === ansSel}) {
                    tempListSelections.remove(at: ix)
                }
            }
            
            for ansSel in answerListSelectionModifed {
                if let ix = tempListSelectionsShuffled.index(where: {$0 === ansSel}) {
                    tempListSelectionsShuffled.remove(at: ix)
                }
            }
            for index in 0..<tempListSelectionsShuffled.count {
                originalShuffleMap.append((tempListSelections[index], tempListSelectionsShuffled[index]))
            }
            log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "--3. 목록선택지 정답을 아래와 같이 변경")
            
            for (oriSel, shuSel) in originalShuffleMap {
                let logstr = "      원래 목록선택지:  "+oriSel.getListString()+"   -> 변경:  "+shuSel.getListString()
                log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: logstr)
                log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "")
            }
            isAnswerChanged = true
            // 3. 임의로 답변을 변경 끝
            // Array를 멋지게 이용해서 코드를 대폭 줄일 수 있는 방안을 연구해야 한다 (+) 2017. 4. 30.
        }
        return (selections, isOXChanged, answerListSelectionModifed, originalShuffleMap, isAnswerChanged)
    }
    
    // isOXChanged를 기준으로 위 불리안이 참일떄만, 문제의 질문 O/X를 토글하여 출력하도록 도와주는 함수로 논리적 판단을 하지는 않음.
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
            questionContent = question.notContent!
        }
        return (questionShuffledOX,questionContent)
    }
    
    // 이제부터 선택지를 문제의 논리에 맞게 변경하여 반환
    // 필요한 입력 - 반환해서 돌려줄 선택지(함수입력), OX를 변환한 문제인지(isOXChanged, 클래스의 프로퍼티), 변경한 정답(answerSelectionModifed, 클래스의 프로퍼티)
    
    // Find유형의 선택지를 제외한 모든 Statement를 출력하는 함수
    func getModfiedStatementOfCommonStatement(statement : Statement) -> (content :String, iscOrrect : Bool?, isAnswer : Bool?) {
        
        // 1. 기본
        var statementContentShuffled = statement.content
        var iscOrrectShuffled = statement.iscOrrect
        
        // 정답출력에 대해서 좀더 고민 필요 2017. 5. 5. (+),
        // 고민중..일단 정답이 nil이면 이는 내용을 변경할 여지가 없는 것이니 원래 내용을 반환하도록 짜보고 있음
        // 문제의 ox를 바꾸거나 정답을 바꿀 때 선택지들의 isAnswer가 존재하는지를 체크하는게 필요할 듯
        if statement.isAnswer == nil {
            return (statementContentShuffled, iscOrrectShuffled, nil)
        }
        var isAnswerShuffled = statement.isAnswer!
        
        // 2. 질문의 OX를 변경을 확인
        if isOXChanged {
            statementContentShuffled = _toggleStatementContent(statementContentShuffled: statementContentShuffled, selection: statement)
            iscOrrectShuffled = _toggleIsCorrect(iscOrrectShuffled: iscOrrectShuffled)
        }
        
        // 3. 랜덤하게 변경된 정답에 맞춰 수정
        if isAnswerChanged {
            if isAnswerShuffled {
                // 3-1. 출력하려는 선택지나 목록이 답이고(statement.isAnswer = true) 랜덤으로 선정된 정답포인터가 아니면(self <> answerStatement) T/F를 반전
                // 3-2. 출력하려는 선택지가 답이고(statement.isAnswer.isAnswer = true) 랜덤으로 선정된 정답포인터면(self = answerStatement) T/F를 유지
                //      정답포인터와의 비교는 statement가 list인가 selection인가에 따라 다르므로 그에 맞게 statementIsAnswer 함수로 비교함
                if !_statementIsAnswer(statement) {
                    statementContentShuffled = _toggleStatementContent(statementContentShuffled: statementContentShuffled, selection: statement)
                    iscOrrectShuffled = _toggleIsCorrect(iscOrrectShuffled: iscOrrectShuffled)
                    isAnswerShuffled = !isAnswerShuffled
                } else {
                }
            } else {
                // 3-3. 출력하려는 선택지가 답이아니고(statement.isAnswer = true) 랜덤으로 선정된 정답포인터면(self = answerSelectionModifed) T/F를 변경
                // 3-4. 출력하려는 선택지가 답이아니고(statement.isAnswer = true) 랜덤으로 선정된 정답포인터가 아니면(self <> answerSelectionModifed) T/F를 유지
                if _statementIsAnswer(statement) {
                    statementContentShuffled = _toggleStatementContent(statementContentShuffled: statementContentShuffled, selection: statement)
                    iscOrrectShuffled = _toggleIsCorrect(iscOrrectShuffled: iscOrrectShuffled)
                    isAnswerShuffled = !isAnswerShuffled
                } else {
                }
            }

        }
        return (statementContentShuffled, iscOrrectShuffled, isAnswerShuffled)
    }
    
    // Find유형의 문제의 선택지를 출력하는 함수
    func getModifedListContentStatementInSelectionOfFindTypeQuestion(selection : Selection) -> (content :String, iscOrrect : Bool?, isAnswer : Bool?) {
        // 1. 기본
        var selectionContentShuffled = ""
        var selectionContentShuffledArray = [String]()
        var listSelInSelectionContentShuffled = [ListSelection]()
        let iscOrrectShuffled : Bool? = nil
        
        // 조금더 정밀하게 고민 필요 2017. 5. 5. 일단 정답에다가 참을 찍어주도록 하였음
        var isAnswerShuffled : Bool?
        if _statementIsAnswer(selection) {
            isAnswerShuffled = true
        } else {
            isAnswerShuffled = false
        }
        
        
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
    
    // getModfiedStatement에서 사용하는 statement가 정답인지 아닌지를 확인하는 함수
    // 하나라도 있기만 하면 true반환이니 병렬적으로 체크하나 좀 찝찝하긴 하나 크게 상관 없을 듯
    private func _statementIsAnswer(_ statement: Statement) -> Bool {
        var isSame = false
        
        if answerSelectionModifed === statement {
            isSame = true
        }
        if let _ = answerListSelectionModifed.index(where: {$0 === statement}) {
            isSame = true
        }
        
        return isSame
    }
    
    private func _toggleIsCorrect(iscOrrectShuffled : Bool?) -> Bool?{
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
    
    private func _toggleStatementContent(statementContentShuffled : String, selection : Statement) -> String {
        guard let statementCont = selection.notContent else {
            return selection.content
        }
        if statementContentShuffled == statementCont  {
            return selection.content
        } else {
            return statementCont
        }
    }
   
}
