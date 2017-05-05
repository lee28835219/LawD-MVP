//
//  QShufflingManager.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 4..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class QShufflingManager {
    
//    let question : Question
    let qShuffled : QuestionShuffled
    
    init(qShuffled: QuestionShuffled) {
        self.qShuffled = qShuffled
    }
    
    func publish(showAttribute: Bool = true, showAnswer: Bool = true, showTitle: Bool = true, showOrigSel : Bool = true) {
        let oManager = OutputManager()
        oManager.showAnswer = showAnswer
        oManager.showTitle = showTitle
        oManager.showAttribute = showAttribute
        oManager.showOrigSel = showOrigSel
        
        var listsContent = [String]()
        var listsIscOrrect = [Bool?]()
        var listsIsAnswer = [Bool?]()
        var listsNumberString = [String]()
        var origialListsNumberString = [String]()
        
        for (index, list) in qShuffled.lists.enumerated() {
            let listResult = qShuffled.getModfiedStatementOfCommonStatement(statement: list)
            listsContent.append(listResult.content)
            listsIscOrrect.append(listResult.iscOrrect)
            listsIsAnswer.append(listResult.isAnswer)
            listsNumberString.append(list.getListString(int: index+1))
            origialListsNumberString.append(list.getListString())
        }
        
        print(origialListsNumberString)
        
        var selectionsContent = [String]()
        var selsIscOrrect = [Bool?]()
        var selsIsAnswer = [Bool?]()
        var originalSelectionsNumber = [String]()
        
        for sel in qShuffled.selections {
            var selResult = qShuffled.getModfiedStatementOfCommonStatement(statement: sel)
            if qShuffled.question.questionType == QuestionType.Find {
                selResult = qShuffled.getModifedListContentStatementInSelectionOfFindTypeQuestion(selection: sel)
            }
            selectionsContent.append(selResult.content)
            selsIscOrrect.append(selResult.iscOrrect)
            selsIsAnswer.append(selResult.isAnswer)
            originalSelectionsNumber.append(sel.selectNumber.roundInt)
        }
        
        
        let questionModifed = qShuffled.getModifedQuestion()
        var ansSel = qShuffled.getModfiedStatementOfCommonStatement(statement: qShuffled.answerSelectionModifed)
        if qShuffled.question.questionType == .Find {
            ansSel = qShuffled.getModifedListContentStatementInSelectionOfFindTypeQuestion(selection: qShuffled.answerSelectionModifed)
        }
        
        
        oManager.questionPublish(
            testCategroy: qShuffled.question.test.category,
            testNumber: qShuffled.question.test.number,
            testSubject: qShuffled.question.test.subject,
            isPublished: false, // 변형한 문제이므로 false로 항상 입력
            
            questionNumber: qShuffled.question.number,
            questionContent: questionModifed.content,  // 셔플하면 변경
            questionContentNote: qShuffled.question.testQuestionNote,
            questionType: qShuffled.question.questionType,
            questionOX: questionModifed.questionOX ,   // 셔플하면 변경
            
            listsContents : listsContent, // 셔플하면 변경
            listsIscOrrect : listsIscOrrect, // 셔플하면 변경
            listsNumberString : listsNumberString, // 셔플하면 변경
            origialListsNumberString : origialListsNumberString, // 셔플하면 변경
            
            selectionsContent : selectionsContent,  // 셔플하면 변경
            selsIscOrrect : selsIscOrrect,  // 셔플하면 변경
            selsIsAnswer : selsIsAnswer,  // 셔플하면 변경
            originalSelectionsNumber : originalSelectionsNumber, // 셔플하면 변경,
            
            ansSelContent: ansSel.content,  // 셔플하면 변경
            ansSelIscOrrect: ansSel.iscOrrect,  // 셔플하면 변경
            ansSelIsAnswer: ansSel.isAnswer,  // 셔플하면 변경
            questionAnswer: (qShuffled.getAnswerNumber() + 1),
            originalAnsSelectionNumber: qShuffled.answerSelectionModifed.selectNumber.roundInt // 셔플하면 변경
        )
    }
}
