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
    var path : URL? {
        let path : URL?
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            path = dir.appendingPathComponent("Test").appendingPathComponent("TestGeneratorStorage")
        } else {
            path = nil
        }
        return path
    }
    
    init() {
    }
    
    func questionPublish(
            //시험
            testCategroy : String,testCategoryHelper : String?, testNumber : Int, testSubject : String, isPublished : Bool,
            //질문
            questionNumber : Int, questionContent : String, questionContentNote : String?, questionType : QuestionType, questionOX : QuestionOX,
            //목록
            listsContents : [String], listsIscOrrect : [Bool?], listsNumberString : [String], origialListsNumberString : [String],
            //선택지
            selectionsContent : [String],selsIscOrrect : [Bool?],selsIsAnswer : [Bool?],originalSelectionsNumber : [String],
            //정답
            ansSelContent : String?, ansSelIscOrrect : Bool?,ansSelIsAnswer : Bool?, questionAnswer : Int, originalAnsSelectionNumber : String
            ) {
        
        //문제
        print("")
        if showTitle {
            let catHelp = testCategoryHelper ?? ""
            let testTitle = (isPublished ? "[기출] " : "[변형] ") + testCategroy + catHelp + "\(testNumber)회 \(testSubject) "
            print(testTitle)
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
        if listsContents.count > 0 {
            for (index,listSelCont) in listsContents.enumerated() {
                var selectionStr = listSelCont
                if showOrigSel {
                    selectionStr = "[\(origialListsNumberString[index])] " + selectionStr
                }
                if showAttribute {
                    if let OX = listsIscOrrect[index] {
                        selectionStr = selectionStr + (OX ? " (O)" : " (X)")
                    } else {
                        selectionStr = selectionStr + " (O?,X?)"
                    }
                }
                print(" "+listsNumberString[index]+". "+selectionStr.spacing(4))
            }
            print()
        }
        
        //선택지
        for (index,selCont) in selectionsContent.enumerated() {
            print("  "+(index+1).roundInt+"  "+_getSelectionStringForPrinting(selContent : selCont, selIscOrrect : selsIscOrrect[index], selIsAnswer : selsIsAnswer[index], showAttribute : showAttribute, questionType : questionType, originalSelectionNumber : originalSelectionsNumber[index]).spacing(5))
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
                _getSelectionStringForPrinting(selContent : ansSCon, selIscOrrect : ansSelIscOrrect, selIsAnswer : ansSelIsAnswer, showAttribute : showAttribute, questionType : questionType, originalSelectionNumber : originalAnsSelectionNumber).spacing(5))
        }
        print()
    }
    
    // How to check if a file exists in the Documents directory in Swift?
    // http://stackoverflow.com/questions/24181699/how-to-check-if-a-file-exists-in-the-documents-directory-in-swift
    // How to save an array as a json file in Swift?
    // http://stackoverflow.com/questions/28768015/how-to-save-an-array-as-a-json-file-in-swift
    func saveFile(fileName: String, data: Data) -> Bool {
        let savePath = self.path?.appendingPathComponent(fileName)
        guard let savePathWrapped = savePath else {
            print("저장할 디렉토리를 찾치 못해서 \(fileName)을 저장하는데 실패하였음)")
            return false
        }
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: savePathWrapped.path) {
            print("\(fileName)이 \(savePathWrapped)에 존재함 계속진행?(y)>".spacing(1), terminator : "")
            let input = readLine()
            if input != "y" && input != "Y" && input != "ㅛ" {
                print("\(fileName) 저장 안하고 종료".spacing(1))
                return false
            }
        }
        
        do {
            try data.write(to: savePathWrapped)
            print("\(fileName) 저장 성공".spacing(1))
            return true
        } catch {
            print("\(fileName)을 저장하는데 실패하였음 - \(error)".spacing(1))
            return false
        }
    }
    
    private func _getSelectionStringForPrinting(selContent : String, selIscOrrect : Bool?, selIsAnswer : Bool?, showAttribute : Bool, questionType : QuestionType, originalSelectionNumber : String) -> String {
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

protocol Publishable {
    func publish(showAttribute: Bool, showAnswer: Bool, showTitle: Bool, showOrigSel : Bool)
}

protocol JSONoutable {
    func createJsonObject() -> Data?
}
