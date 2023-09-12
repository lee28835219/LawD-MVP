//
//  Solver+Publish.swift
//  TestGenerator
//
//  Created by Masterbuilder on 2023/06/17.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//
// 2023. 6. 17.
// Solver 클래스의 콘솔용 출력 함수이며, 직접 Solver의 파라미터에 접근하여 레이아웃을 짤 수 있는 SwiftUI에서는 필요 없는 함수여서 별도의 파일로 분리함.
// 매우 복잡한 함수이며, 디버깅 필요한 부분 몇 군데 계속 보이나, 시급하지는 않아 아직 진행하지 않고 있음. (-)

import Foundation

extension Solver {
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
                isPublished = false // 바꾼문제니깐
                
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
            
            testKey: self.question.test?.key ?? "",
            
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
}

enum QuestionPublishType {
    case original
    case originalNot
    case solver
}
