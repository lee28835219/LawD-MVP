//
//  QShufflingManager.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 4..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class QShufflingManager : Publishable {
    let qShuffled : QuestionShuffled
    
    init(outputManager: OutputManager, qShuffled: QuestionShuffled) {
        self.qShuffled = qShuffled
    }
    
    func publish(showAttribute: Bool = true, showAnswer: Bool = true, showTitle: Bool = true, showOrigSel : Bool = true) {
        let outputManager = OutputManager()
        outputManager.showAnswer = showAnswer
        outputManager.showTitle = showTitle
        outputManager.showAttribute = showAttribute
        outputManager.showOrigSel = showOrigSel
        
        //질문
        let questionModifed = qShuffled.getModifedQuestion()  // (questionOX: QuestionOX, content: String)
        
        //목록
        var listsContent = [String]()
        var listsIscOrrect = [Bool?]()
        var listsIsAnswer = [Bool?]()
        var listsNumberString = [String]()
        var origialListsNumberString = [String]()
        
        for (index, list) in qShuffled.lists.enumerated() {
            let listResult = qShuffled.getModfiedStatementOfCommonStatement(statement: list)
                            // (content: String, iscOrrect: Bool?, isAnswer: Bool?)
            listsContent.append(listResult.content)
            listsIscOrrect.append(listResult.iscOrrect)
            listsIsAnswer.append(listResult.isAnswer)
            listsNumberString.append(list.getListString(int: index+1))
            origialListsNumberString.append(list.getListString())
        }
        
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
        
        for (index,sel) in qShuffled.selections.enumerated() {
            // 컴퓨팅 능력을 낭비하는 것이어서 찝찝 다른 방법으로 할 방법은? 출력이 튜플이라서 lazy var도 안된다. 2017. 5. 6. (+)
            var selResult = qShuffled.getModfiedStatementOfCommonStatement(statement: sel)
            
            switch qShuffled.question.questionType {
            case .Find:
                switch qShuffled.question.questionOX {
                case .O:
                    selResult = qShuffled.getModifedListContentStatementInSelectionOfFindTypeQuestion(selection: sel)
                case .X:
                    selResult = qShuffled.getModifedListContentStatementInSelectionOfFindTypeQuestion(selection: sel)
                case .Correct:
                    _ = true
                case .Unknown:
                    _ = true
                }
            case .Select:
                _ = true
            case .Unknown:
                _ = true
            }
            
            selectionsContent.append(selResult.content)
            selsIscOrrect.append(selResult.iscOrrect)
            selsIsAnswer.append(selResult.isAnswer)
            originalSelectionsNumber.append(sel.number.roundInt)
            
            if sel === qShuffled.answerSelectionModifed {
                ansSelContent = selResult.content
                ansSelIscOrrect = selResult.iscOrrect
                ansSelIsAnswer = selResult.isAnswer
                questionAnswer = (index + 1)
                originalAnsSelectionNumber = sel.number.roundInt
            }
        }
        
        
        
        
        
        //정답
        // 직접 가져오는 것보다 위의 선택지에서 확인하는 것이 더 쉬우므로 없애버림 2017. 5. 18.
//        var ansSel = qShuffled.getModfiedStatementOfCommonStatement(statement: qShuffled.answerSelectionModifed)
//                     // (content: String, iscOrrect: Bool?, isAnswer: Bool?)
//        if qShuffled.question.questionType == .Find {
//            ansSel = qShuffled.getModifedListContentStatementInSelectionOfFindTypeQuestion(selection: qShuffled.answerSelectionModifed)
//        }
        
        
        outputManager.questionPublish(
//            testCategroy: qShuffled.question.test.testSubject.testCategory.category,
//            testCategoryHelper: qShuffled.question.test.testSubject.testCategory.catHelper,
//            testSubject: qShuffled.question.test.testSubject.subject,
            isPublished: false, // 변형한 문제이므로 false로 항상 입력
            
            testKey: qShuffled.question.test.key,
            
//            testNumber: qShuffled.question.test.number,
            
            questionNumber: qShuffled.question.number,
            questionContent: questionModifed.content,  // 셔플하면 변경
            questionContentNote: qShuffled.question.contentNote,
            questionPassage:  qShuffled.question.passage,
            questionPassageSuffix:  qShuffled.question.passageSuffix,
            questionType: qShuffled.question.questionType,
            questionOX: questionModifed.questionOX ,   // 셔플하면 변경
            
            listsContents : listsContent, // 셔플하면 변경
            listsIscOrrect : listsIscOrrect, // 셔플하면 변경
            listsNumberString : listsNumberString, // 셔플하면 변경
            origialListsNumberString : origialListsNumberString, // 셔플하면 변경
            
            questionSuffix:  qShuffled.question.questionSuffix,
            
            selectionsContent : selectionsContent,  // 셔플하면 변경
            selsIscOrrect : selsIscOrrect,  // 셔플하면 변경
            selsIsAnswer : selsIsAnswer,  // 셔플하면 변경
            originalSelectionsNumber : originalSelectionsNumber, // 셔플하면 변경,
            
            ansSelContent: ansSelContent,  // 셔플하면 변경
            ansSelIscOrrect: ansSelIscOrrect,  // 셔플하면 변경
            ansSelIsAnswer: ansSelIsAnswer,  // 셔플하면 변경
            questionAnswer: questionAnswer,
            originalAnsSelectionNumber: originalAnsSelectionNumber
        )
    }
}
