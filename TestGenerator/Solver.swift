//
//  Solver.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 4. 10..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class Solver : DataStructure {
    var log = ""
    
    var question : Question
    
    var selections = [Selection]()
    var lists = [List]()
    
    
    //공통, 초기화 단계에서 꼭 정답의 존재를 확인해야 함
    var answerSelectionModifed : Selection?
    var isOXChanged = false
    var isAnswerChanged = false
    var isOXChangable = false
    
    //Find유형 문제용
    var originalShuffleMap = [(original : List, shuffled : List)]()
    var answerListSelectionModifed = [List]()
    
    
    // 문제를 푼 뒤에 입력하는 항목
    var date : Date? = nil
    var isRight : Bool? = nil
    var comment : String = ""
    
    // hirechy 참고용
    let generator : Generator? = nil
    
    
    // Restore용 초기화함수
    init(_ question: Question, selections: [Selection], lists: [List], answerSelectionModifed: Selection?, isOXChanged: Bool, isAnswerChanged: Bool, originalShuffleMap: [(List,List)], answerListSelectionModifed : [List]) {
        self.question = question
        self.selections = selections
        self.lists = lists
        self.answerSelectionModifed = answerSelectionModifed
        self.isOXChanged = isOXChanged
        self.isAnswerChanged = isAnswerChanged
        self.originalShuffleMap = originalShuffleMap
        self.answerListSelectionModifed = answerListSelectionModifed
        
        super.init("hey")
    }
    
    
    // shuffle 및 bypass용 초기화함수
    init(_ question : Question, gonnaShuffle : Bool = true) {
        let key = "key"
        
        log = ConsoleIO.newLog("\(#file)")
        
        // http://stackoverflow.com/questions/34560768/can-i-throw-from-class-init-in-swift-with-constant-string-loaded-from-file
        // Can I throw from class init() in Swift with constant string loaded from file?, 초기화 단계에서 정답의 존재가 없다면 에러를 발생하다록 추후 수정(-) 2017. 4. 26.
        //http://stackoverflow.com/questions/31038759/conditional-binding-if-let-error-initializer-for-conditional-binding-must-hav
        //conditional binding에 관하여

        
        // 0. 문제를 저장하여 초기화 완료
        self.question = question
        // 주어진 문제에 답이 있는지 확인
        guard let ansSel = question.answerSelection else {
            log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "\(question.key) Shuffling하려하니 문제 정답이 없음")
            log = ConsoleIO.closeLog(log, file: "\(#file)")
            super.init(key)
            return
        }
        
        // 완성 2017. 4. 26.  -> 정답은 없을 수 없도록 questiondㅔ서 체크하므로 이 에러체크를 그냥 nil반환에서 리턴으로 수정함 2017. 5. 19.
        // 그러나 선택지가 없는 것은 가능할 것임 이때에는 그냥 nil말고 질문만 반환하면 될것, 어짜피 selections는 []으로 초기화 되 있으므로 논리에 어긋나지 않음
        // 가드 구문에서 if문으로 수정해서 로그 찍는 걸로만 끝냄
        if question.selections.count == 0 {
            log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "\(question.key) Shuffling하려하니 문제 선택지가 없음")
            log = ConsoleIO.closeLog(log, file: "\(#file)")
            super.init(key)
            return
        }
        
        
        // 0. 에러체크 끝났으니 목록, 선택지, 정답의 주소를 저장
        self.lists = question.lists //하나도 없어도 셔플링은 가능할 것, Find 유형 문제일 때 에러체크를 하는게 좋을까?
        self.selections = question.selections
        self.answerSelectionModifed = ansSel
        super.init(key)
        
        // 추후 계속 초기화 단계의 에러체크를 추가합시다. (+) 2017. 5. 4.

        
        if !gonnaShuffle {
            self.answerListSelectionModifed = question.answerLists
            
            for list in lists {
                self.originalShuffleMap.append((list,list))
            }
            
            log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "\(question.key) 문제를 온전하게 보존하여 초기화함")
            log = ConsoleIO.closeLog(log, file: "\(#file)")
            return
        }
        

        log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "-\(question.key) 문제 변경을 시작함")
        
        
        // 문제를 섞는 가장 중요한 함수
        switch question.questionType {
            
        case .Find:
            let result = changeFindTypeQuestion()
            self.selections = result.selections
            self.isOXChanged = result.isOXChanged
            self.answerListSelectionModifed = result.answerListSelectionModifed
            self.originalShuffleMap = result.originalShuffleMap
            self.isAnswerChanged = result.isAnswerChanged
            
        case .Select:
            let result = changeSelectTypeQuestion()
            self.selections = result.selections
            self.isOXChanged = result.isOXChanged
            self.isAnswerChanged = result.isAnswerChanged
            self.answerSelectionModifed = result.answerSelectionModifed
            
        case .Unknown:
            self.selections = changeCommonTypeQuestion() // 선택지 순서만 변경하고 끝나게 됨
        }
        
        let logstr1 = self.isOXChanged ? "변경하고" : "변경하지 않고"
        let logstr2 = self.isAnswerChanged ? "변경하였음" : "변경하지 않았음"
        log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "문제OX를 \(logstr1) 정답을 \(logstr2)")
        if question.answer == self.answerSelectionModifed!.number {
            log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "정답은 \(question.answer)에서 변경하지 않음")
        } else {
            log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "정답은 \(question.answer)에서 \(self.answerSelectionModifed!.number)로 변경함")
        }
        
        log = ConsoleIO.closeLog(log, file: "\(#file)")
        
        return
    }
    
    
    
    // 공통 변경사항
    func changeCommonTypeQuestion() -> [Selection] {
        // 1. 선택지의 순서를 변경
        log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "--1. 선택지 순서 변경함")
        return selections.shuffled()
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
            questionContent = question.notContent!
        }
        return (questionShuffledOX,questionContent)
    }
    
    
    
    
    
    // 선택지를 문제의 논리에 맞게 변경하여 반환
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
                if !statementIsAnswer(statement) {
                    statementContentShuffled = _toggleStatementContent(statementContentShuffled: statementContentShuffled, selection: statement)
                    iscOrrectShuffled = _toggleIsCorrect(iscOrrectShuffled: iscOrrectShuffled)
                    isAnswerShuffled = !isAnswerShuffled
                } else {
                }
            } else {
                // 3-3. 출력하려는 선택지가 답이아니고(statement.isAnswer = true) 랜덤으로 선정된 정답포인터면(self = answerSelectionModifed) T/F를 변경
                // 3-4. 출력하려는 선택지가 답이아니고(statement.isAnswer = true) 랜덤으로 선정된 정답포인터가 아니면(self <> answerSelectionModifed) T/F를 유지
                if statementIsAnswer(statement) {
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
        var listSelInSelectionContentShuffled = [List]()
        let iscOrrectShuffled : Bool? = nil
        
        // 조금더 정밀하게 고민 필요 2017. 5. 5. 일단 정답에다가 참을 찍어주도록 하였음
        var isAnswerShuffled : Bool?
        if statementIsAnswer(selection) {
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
    private func statementIsAnswer(_ statement: Statement) -> Bool {
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
    
    private func changeSelectTypeQuestion() -> (selections : [Selection], isOXChanged : Bool, isAnswerChanged : Bool, answerSelectionModifed : Selection) {
        
        let selections = changeCommonTypeQuestion()
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
    
    // selections 배열 안에서 정답의 Index에서 +1을 반환(정답번호)
    func getAnswerNumber() -> Int {
        //http://stackoverflow.com/questions/24028860/how-to-find-index-of-list-item-in-swift
        //How to find index of list item in Swift?, index의 출력 형식 공부해야함 2017. 4. 25.
        guard let ansNumber = selections.index(where: {$0 === answerSelectionModifed}) else {
            fatalError("error>>getAnswerNumber 실패함")
        }
        return ansNumber + 1
    }
    
    private func changeFindTypeQuestion() -> (selections : [Selection], isOXChanged : Bool, answerListSelectionModifed : [List], originalShuffleMap : [(List, List)], isAnswerChanged : Bool){
        
        let selections = changeCommonTypeQuestion()
        var isOXChanged = false
        var answerListSelectionModifed = [List]()
        var originalShuffleMap = [(List, List)]()
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
    
    
    
    
    
    
    func publish(om: OutputManager,
                 type: QuestionPublishType,
                 showTitle: Bool, showQuestion : Bool, showAnswer: Bool, showTags : Bool, showHistory : Bool,
                 showAttribute: Bool = true, showOrigSel : Bool = true)
    {
        
        om.showTitle = showTitle
        om.showQuestion = showQuestion
        om.showAnswer = showAnswer
        om.showTags = showTags
        om.showHistory = showHistory
        
        om.showAttribute = showAttribute
        om.showOrigSel = showOrigSel
        
        // publish
        var isPublished = false
        
        // 문제
        var questionContent = ""
        var questionOX : QuestionOX = .Unknown
        
        
        //목록지
        var listsContent = [String]()
        var listsIscOrrect = [Bool?]()
        var listsIsAnswer = [Bool?]()
        var listsNumberString = [String]()
        var origialListsNumberString = [String]()
        
        //선택지와 정답
        var selectionsContent = [String]()
        var selsIscOrrect = [Bool?]()
        var selsIsAnswer = [Bool?]()
        var originalSelectionsNumber = [String]()
        
        var ansSelContent: String = ""
        var ansSelIscOrrect: Bool?
        var ansSelIsAnswer: Bool?
        var questionAnswer: Int = 0
        var originalAnsSelectionNumber: String = ""
        
        
        
        // isPublish에 따라 question에서 혹은 solver에서 값을 가져오게 됨
        switch type {
            
        case .original:
            //publish
            isPublished = true
            
            //질문
            questionContent = self.question.content  // (questionOX: QuestionOX, content: String)
            questionOX = self.question.questionOX
            
            //목록
            for (_, list) in self.question.lists.enumerated() {
                listsContent.append(list.content)
                listsIscOrrect.append(list.iscOrrect)
                listsIsAnswer.append(list.isAnswer)
                listsNumberString.append(list.getListString())
                origialListsNumberString.append(list.getListString())
            }
            
            //선택지
            for (index,sel) in self.question.selections.enumerated() {
                
                selectionsContent.append(sel.content)
                selsIscOrrect.append(sel.iscOrrect)
                selsIsAnswer.append(sel.isAnswer)
                originalSelectionsNumber.append(sel.number.roundInt)
                
                if sel === self.question.answerSelection {
                    ansSelContent = sel.content
                    ansSelIscOrrect = sel.iscOrrect
                    ansSelIsAnswer = sel.isAnswer
                    questionAnswer = (index + 1)
                    originalAnsSelectionNumber = sel.number.roundInt
                }
            }
            
        case .originalNot:
            
            // publish
            isPublished = true
            
            //질문
            questionContent = Solver.getWrappedContent(self.question.notContent)
            questionOX = Solver.getNotQuestionOX(self.question.questionOX)
            
            //목록
            for (_, list) in self.question.lists.enumerated() {
                listsContent.append(Solver.getWrappedContent(list.notContent))
                listsIscOrrect.append(Solver.getNotWrappedBool(list.iscOrrect))
                listsIsAnswer.append(list.isAnswer)
                listsNumberString.append(list.getListString())
                origialListsNumberString.append(list.getListString())
            }
            
            
            //선택지
            for (index,sel) in self.question.selections.enumerated() {
                
                selectionsContent.append(Solver.getWrappedContent(sel.notContent))
                selsIscOrrect.append(Solver.getNotWrappedBool(sel.iscOrrect))
                selsIsAnswer.append(sel.isAnswer)
                originalSelectionsNumber.append(sel.number.roundInt)
                
                if sel === self.question.answerSelection {
                    ansSelContent = Solver.getWrappedContent(sel.notContent)
                    ansSelIscOrrect = Solver.getNotWrappedBool(sel.iscOrrect)
                    ansSelIsAnswer = sel.isAnswer
                    questionAnswer = (index + 1)
                    originalAnsSelectionNumber = sel.number.roundInt
                }
            }

            
        case .solver:
            
            // publish
            isPublished = true
            
            //질문
            let (OX, content) = self.getModifedQuestion()
            
            questionContent = content
            questionOX = OX
            
            //목록
            for (index, list) in self.lists.enumerated() {
                let listResult = self.getModfiedStatementOfCommonStatement(statement: list)
                // (content: String, iscOrrect: Bool?, isAnswer: Bool?)
                listsContent.append(listResult.content)
                listsIscOrrect.append(listResult.iscOrrect)
                listsIsAnswer.append(listResult.isAnswer)
                listsNumberString.append(list.getListString(int: index+1))
                origialListsNumberString.append(list.getListString())
            }
            
            //선택지와 정답
            for (index,sel) in self.selections.enumerated() {
                // 컴퓨팅 능력을 낭비하는 것이어서 찝찝 다른 방법으로 할 방법은? 출력이 튜플이라서 lazy var도 안된다. 2017. 5. 6. (-)
                // var selResult = self.getModfiedStatementOfCommonStatement(statement: sel)
                
                // let (,,)형식으로 해결 2017. 5. 21.
                var selResult : (content: String, iscOrrect: Bool?, isAnswer: Bool?) = ("", nil, nil)
                
                switch self.question.questionType {
                case .Find:
                    switch self.question.questionOX {
                    case .O:
                        selResult = self.getModifedListContentStatementInSelectionOfFindTypeQuestion(selection: sel)
                    case .X:
                        selResult = self.getModifedListContentStatementInSelectionOfFindTypeQuestion(selection: sel)
                    case .Correct:
                        selResult = self.getModfiedStatementOfCommonStatement(statement: sel)
                    case .Unknown:
                        selResult = self.getModfiedStatementOfCommonStatement(statement: sel)
                    }
                case .Select:
                    selResult = self.getModfiedStatementOfCommonStatement(statement: sel)
                case .Unknown:
                    selResult = self.getModfiedStatementOfCommonStatement(statement: sel)
                }
                
                selectionsContent.append(selResult.content)
                selsIscOrrect.append(selResult.iscOrrect)
                selsIsAnswer.append(selResult.isAnswer)
                originalSelectionsNumber.append(sel.number.roundInt)
                
                if sel === self.answerSelectionModifed {
                    ansSelContent = selResult.content
                    ansSelIscOrrect = selResult.iscOrrect
                    ansSelIsAnswer = selResult.isAnswer
                    questionAnswer = (index + 1)
                    originalAnsSelectionNumber = sel.number.roundInt
                }
            }
        }
        
        //정답
        // 직접 가져오는 것보다 위의 선택지에서 확인하는 것이 더 쉬우므로 없애버림 2017. 5. 18.
        //        var ansSel = self.getModfiedStatementOfCommonStatement(statement: self.answerSelectionModifed)
        //                     // (content: String, iscOrrect: Bool?, isAnswer: Bool?)
        //        if self.question.questionType == .Find {
        //            ansSel = self.getModifedListContentStatementInSelectionOfFindTypeQuestion(selection: self.answerSelectionModifed)
        //        }
        
        let generator = Generator()
        generator.solvers = question.solvers
        let (c,w) = generator.seperateWorngSolve()
        let totalNumber = c.count + w.count
        let rightNumber = c.count
        
        
        
        om.questionPublish(
            //            testCategroy: self.question.test.testSubject.testCategory.category,
            //            testCategoryHelper: self.question.test.testSubject.testCategory.catHelper,
            //            testSubject: self.question.test.testSubject.subject,
            isPublished: isPublished, // 변형한 문제이므로 false로 항상 입력 -> solver안으로 question 도 들어와서 이제는 아니다 수정함 2017. 5. 21.
            
            testKey: self.question.test.key,
            
            //            testNumber: self.question.test.number,
            
            questionNumber: self.question.number,
            questionContent: questionContent,  // 셔플하면 변경
            questionContentNote: self.question.contentNote,
            questionPassage:  self.question.passage,
            questionPassageSuffix:  self.question.passageSuffix,
            questionType: self.question.questionType,
            questionOX: questionOX ,   // 셔플하면 변경
            
            listsContents : listsContent, // 셔플하면 변경
            listsIscOrrect : listsIscOrrect, // 셔플하면 변경
            listsNumberString : listsNumberString, // 셔플하면 변경
            origialListsNumberString : origialListsNumberString, // 셔플하면 변경
            
            questionSuffix:  self.question.questionSuffix,
            
            selectionsContent : selectionsContent,  // 셔플하면 변경
            selsIscOrrect : selsIscOrrect,  // 셔플하면 변경
            selsIsAnswer : selsIsAnswer,  // 셔플하면 변경
            originalSelectionsNumber : originalSelectionsNumber, // 셔플하면 변경,
            
            ansSelContent: ansSelContent,  // 셔플하면 변경
            ansSelIscOrrect: ansSelIscOrrect,  // 셔플하면 변경
            ansSelIsAnswer: ansSelIsAnswer,  // 셔플하면 변경
            questionAnswer: questionAnswer,
            originalAnsSelectionNumber: originalAnsSelectionNumber,
            
            tags: question.tags,
            
            solveDate: question.solvers.map {$0.date},
            isRight: question.solvers.map {$0.isRight},
            comment: question.solvers.map {$0.comment},
            
            answerRate: Float(rightNumber)/Float(totalNumber)*100,
            totalNumber: totalNumber,
            rightNumber: rightNumber
        )
        
    }
    
    class func getWrappedContent(_ contentUnwrapped : String?) -> String {
        if contentUnwrapped == nil {
            return "(없음)"
        } else {
            return contentUnwrapped!
        }
        
    }
    
    class func getNotWrappedBool(_ unwrappedBool : Bool?) -> Bool? {
        if unwrappedBool == nil {
            return nil
        } else {
            return unwrappedBool!
        }
    }
    
    class func getNotQuestionOX(_ oriQuestionOX : QuestionOX) -> QuestionOX {
        if oriQuestionOX == .O {
            return .X
        } else {
            if oriQuestionOX == .O {
                return .X
            } else {
            return oriQuestionOX
            }
        }
    }
}


enum QuestionPublishType {
    case original
    case originalNot
    case solver
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





