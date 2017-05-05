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
    let qShuffled : QuestionShuffled?
    
    init(question: Question, qShuffled: QuestionShuffled?) {
        self.question = question
        self.qShuffled = qShuffled
        if qShuffled == nil {
            print("\(question.key) 변형문제는 존재하지 않음")
        }
    }
    
    func publish(showAttribute: Bool = true, showAnswer: Bool = true, showTitle: Bool = true, showOrigSel : Bool = true) {
        let oManager = OutputManager()
        oManager.showAnswer = showAnswer
        oManager.showTitle = showTitle
        oManager.showAttribute = showAttribute
        oManager.showOrigSel = showOrigSel
        
        guard let qShuWrapped = qShuffled else {
            question.publish(showAttribute: showAttribute, showAnswer: showAnswer, showTitle: showTitle, showOrigSel: showOrigSel)
            return
        }
        
        var listsContent = [String]()
        var listsIscOrrect = [Bool?]()
        var listsIsAnswer = [Bool?]()
        var listsNumberString = [String]()
        var origialListsNumberString = [String]()
        
        for (index, list) in qShuWrapped.lists.enumerated() {
            let listResult = qShuWrapped.getModfiedStatement(statement: list)
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
        
        
        
        for sel in qShuWrapped.selections {
            let selResult = qShuWrapped.getModfiedStatement(statement: sel)
            selectionsContent.append(selResult.content)
            selsIscOrrect.append(selResult.iscOrrect)
            selsIsAnswer.append(selResult.isAnswer)
            originalSelectionsNumber.append(sel.selectNumber.roundInt)
        }
        
        
        let questionModifed = qShuWrapped.getModifedQuestion()
        let ansSel = qShuWrapped.getModfiedStatement(statement: qShuWrapped.answerSelectionModifed)
        
        
        oManager.questionPublish(
            testCategroy: question.test.category,
            testNumber: question.test.number,
            testSubject: question.test.subject,
            isPublished: false, // 변형한 문제이므로 false로 항상 입력
            
            questionNumber: question.number,
            questionContent: questionModifed.content,  // 셔플하면 변경
            questionContentNote: question.testQuestionNote,
            questionType: question.questionType,
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
            questionAnswer: (qShuWrapped.getAnswerNumber() + 1),
            originalAnsSelectionNumber: qShuWrapped.answerSelectionModifed.selectNumber.roundInt // 셔플하면 변경
        )
    }
}
