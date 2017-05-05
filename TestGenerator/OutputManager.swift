//
//  OutputManager.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 5..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class OutputManager {
    var showAttribute : Bool = false
    var showAnswer : Bool = false
    var showTitle : Bool = true
    var showOrigSel : Bool = false
    
    init() {
    }
    
    func questionPublish(testCategroy : String, testNumber : Int, testSubject : String, isPublished : Bool, questionNumber : Int, questionContent : String, questionContentNote : String?, questionType : QuestionType, questionOX : QuestionOX, listSelsCont : [String], listSelsIscOrrect : [Bool?], listSelsIntString : [String], selectionsContent : [String],selsIscOrrect : [Bool?],selsIsAnswer : [Bool],originalSelectionsNumber : [String], ansSelContent : String?, ansSelIscOrrect : Bool?,ansSelIsAnswer : Bool?, questionAnswer : Int, originalAnsSelectionNumber : String) {
        
        //문제
        print("")
        if showTitle {
            let queTitle = "[\(testCategroy) \(testNumber)회 \(testSubject) "+(isPublished ? "기출]" : "변형]")
            print(queTitle)
        }
        
        print("문 "+questionNumber.description+". ")
        var queCont = questionContent
        if let contNote = questionContentNote {
            queCont = queCont + " " + contNote
        }
        if showAttribute {
            queCont = queCont + " (문제유형 : \(questionType)\(questionOX))"
        }
        print("  "+queCont.spacing(2))
        print()
        
        
        //목록
        if listSelsCont.count > 0 {
            for (index,listSelCont) in listSelsCont.enumerated() {
                var selectionStr = listSelCont
                if showAttribute {
                    if let OX = listSelsIscOrrect[index] {
                        selectionStr = selectionStr + (OX ? " (O)" : " (X)")
                    } else {
                        selectionStr = selectionStr + " (O?,X?)"
                    }
                }
                print(" "+listSelsIntString[index]+". "+selectionStr.spacing(4))
            }
            print()
        }
        
        //선택지
        for (index,selCont) in selectionsContent.enumerated() {
            print("  "+(index+1).roundInt+"  "+_getSelectionStringForPrinting2(selContent : selCont, selIscOrrect : selsIscOrrect[index], selIsAnswer : selsIsAnswer[index], showAttribute : showAttribute, questionType : questionType, originalSelectionNumber : originalSelectionsNumber[index]).spacing(5))
        }
        print()
        
        
        
        //정답
        if showAnswer {
            print("<정답>")
            guard let ansSCon = ansSelContent
                else {
                    print("  정답이 입력되지 않음")
                    return
            }
            print("  " + questionAnswer.roundInt + "  " +
                _getSelectionStringForPrinting2(selContent : ansSCon, selIscOrrect : ansSelIscOrrect, selIsAnswer : ansSelIsAnswer, showAttribute : showAttribute, questionType : questionType, originalSelectionNumber : originalAnsSelectionNumber).spacing(5))
        }
        print()
    }
    
    private func _getSelectionStringForPrinting2(selContent : String, selIscOrrect : Bool?, selIsAnswer : Bool?, showAttribute : Bool, questionType : QuestionType, originalSelectionNumber : String) -> String {
        var selectionStr = ""
        if showOrigSel {
            selectionStr = selectionStr + "[" + originalSelectionNumber + "] "
        }
        selectionStr = selectionStr + selContent
        if showAttribute {
            if let OX = selIscOrrect {
                selectionStr = selectionStr+(OX ? " (O)" : " (X)")
            } else {
                if questionType != .Select {
                    if let ans = selIsAnswer {
                        if ans {
                            selectionStr = selectionStr+" (O)"
                        } else {
                            selectionStr = selectionStr+" (X)"
                        }
                    }
                } else {
                    selectionStr = selectionStr+" (O,X)?"
                }
            }
        }
        return selectionStr
    }

}
