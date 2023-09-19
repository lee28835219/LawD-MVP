//
//  OutputManager.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 5..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class OutputManager {
    let io = ConsoleIO()
    var log = ""
    
    let fileManager = FileManager.default

    var showTitle : Bool = true
    var showQuestion : Bool = true
    var showAnswer : Bool = false
    var showTags : Bool = false
    var showHistory : Bool = false
    var showAttribute : Bool = false
    var showOrigSel : Bool = false
    
    // 2023. 9. 13. 저장위치 변경합니다. 영향도 검토요합니다 (-)
//    var url : URL? {
//        let path : URL?
//        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//            path = dir.appendingPathComponent("TestGenerator").appendingPathComponent("Data").appendingPathComponent("Storage")
//        } else {
//            path = nil
//        }
//        return path
//    }
    var url : URL? {
        // 작업환경이 드롭박스로 바뀌어서 수정함. 이는 개발환경에서만 작동가능하므로, 이를 앱에서 실행할 때 수정해야 함 (-) ★★★
        let pathString = "/Users/lee/Library/CloudStorage/Dropbox/DropDocument/ LawD MVP/Data/Storage"
        return URL(fileURLWithPath: pathString)
            
//
//        let path : URL?
//        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//            path = dir.appendingPathComponent("TestGenerator").appendingPathComponent("Data").appendingPathComponent("Storage")
//        } else {
//            path = nil
//        }
//        return path
    }

    
    init() {
        log = ConsoleIO.newLog("\(#file)")
    }
    
    
    func questionPublish(
            isPublished : Bool,
            
            //시험키
            testKey : String,
            //질문
            questionNumber : Int, questionContent : String, questionContentNote : String?,
            questionPassage : String?, questionPassageSuffix : String?, questionType : QuestionType, questionOX : QuestionOX,
            //목록
            listsContents : [String], listsIscOrrect : [Bool?], listsNumberString : [String], origialListsNumberString : [String],
            //질문 Suffix
            questionSuffix : String?,
            //선택지
            selectionsContent : [String],selsIscOrrect : [Bool?],selsIsAnswer : [Bool?],originalSelectionsNumber : [String],
            //정답
            ansSelContent : String?, ansSelIscOrrect : Bool?,ansSelIsAnswer : Bool?, questionAnswer : Int, originalAnsSelectionNumber : String,
            //태그
            tags : Set<String>,
            //풀이이력
            solveDate: [Date?], isRight : [Bool?], comment : [String], answerRate : Float, totalNumber : Int, rightNumber : Int
            ) {
        
        io.writeMessage("")
        
        //제목
        if showTitle {
            let testTitle = (isPublished ? "[기출] " : "[변형] ") + testKey
            io.writeMessage(to: .title, testTitle)
            io.writeMessage("")
        }
        
        //문제와 선택지 - 향후 statementPublish 개발필요 왜냐? OX문제 생성을 위함~ 2017. 5. 20.
        if showQuestion {
            io.writeMessage(to: .title, "문 "+questionNumber.description+". ")
            var queCont = questionContent
            if let contNote = questionContentNote {
                queCont = queCont + " " + contNote
            }
            if showAttribute {
                queCont = queCont + " (문제유형 : \(questionType)\(questionOX))"
            }
             io.writeMessage(to: .publish, "  "+queCont.spacing(2, 44))
             io.writeMessage("")
            
            //지문
            if questionPassage != nil {
                // How to split a string by new lines in Swift
                // http://stackoverflow.com/questions/32021712/how-to-split-a-string-by-new-lines-in-swift
                let array = questionPassage!.components(separatedBy: .newlines)
                for st in array {
                     io.writeMessage(to: .publish, st.spacing(3))
                }
                 io.writeMessage("")
                if questionPassageSuffix != nil {
                     io.writeMessage(to: .publish, questionPassageSuffix!.spacing(3))
                     io.writeMessage("")
                }
            }

            
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
                     io.writeMessage(to: .publish, " "+listsNumberString[index]+". "+selectionStr.spacing(4))
                }
                 io.writeMessage("")
            }
            
            if questionSuffix != nil {
                 io.writeMessage(to: .publish, questionSuffix!.spacing(2))
                 io.writeMessage("")
            }
            
            //선택지
            for (index,selCont) in selectionsContent.enumerated() {
                 io.writeMessage(to: .publish,
                                 "  "+(index+1).roundInt+"  "+_getSelectionStringForPrinting(
                                                                                            selContent : selCont,
                                                                                            selIscOrrect : selsIscOrrect[index],
                                                                                            selIsAnswer : selsIsAnswer[index],
                                                                                            showAttribute : showAttribute,
                                                                                            questionType : questionType,
                                                                                            originalSelectionNumber : originalSelectionsNumber[index]
                                                                                            ).spacing(5))
            }
             io.writeMessage("")
        }
        
        //정답
        if showAnswer {
            io.writeMessage(to: .title, "<정답>")
            guard let ansSCon = ansSelContent
                else {
                    io.writeMessage(to: .error, "정답이 입력되지 않음")
                    return
            }
             io.writeMessage(to: .publish, "  " + questionAnswer.roundInt + "  " +
                _getSelectionStringForPrinting(selContent : ansSCon, selIscOrrect : ansSelIscOrrect, selIsAnswer : ansSelIsAnswer, showAttribute : showAttribute, questionType : questionType, originalSelectionNumber : originalAnsSelectionNumber).spacing(5))
            io.writeMessage("")
        }
        
        // 태그
        if showTags {
            var str : String? = nil
            for (index,tag) in tags.enumerated() {
                if index == 0 {
                    str = tag
                } else {
                    str = str! + ", " + tag
                }
            }
            
            io.writeMessage(to: .title, "[태그]" + (tags.count == 0 ? "없음" : ""))
            if str != nil {
                io.writeMessage(to: .publish, str!)
            }
            io.writeMessage("")
        }
        
        
        //이력
        if showHistory {
            io.writeMessage(to: .title, "[풀이이력] " + (totalNumber ==  0 ? "없음" : "정답율 \(String(format: "%.1f", answerRate))%, (\(rightNumber) / \(totalNumber))"))
            io.writeMessage()
            for (index,date) in solveDate.enumerated() {
                if date == nil || isRight[index] == nil {
                    continue
                }
                let str = isRight[index]! ? "(O)" : "(X)"
                io.writeMessage(to: .title, (" " + date!.HHmmss + " " + str))
                io.writeMessage(to: .publish, "   " + comment[index].spacing(3, 60))
            }
            io.writeMessage()
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

    
    
    
    // How to check if a file exists in the Documents directory in Swift?
    // http://stackoverflow.com/questions/24181699/how-to-check-if-a-file-exists-in-the-documents-directory-in-swift
    // How to save an array as a json file in Swift?
    // http://stackoverflow.com/questions/28768015/how-to-save-an-array-as-a-json-file-in-swift
    
    
    // 아주 중요한 json 파일을 "콘솔"에서 저장하는 함수, 벡엔드 구축 관련하여 반드시 소화해서 개선해 내야 합니다. 2023. 9. 12. (-)
    func saveFile(fileDirectories: [String], fileName: String, data: Data) -> Bool {
        
        guard let doucmentPathWrapped = url else {
            
            log = ConsoleIO.writeLog(log, funcName: ("\(#function)"), outPut: "저장할 디렉토리를 찾지 못해서 \(fileName)을 저장하는데 실패하였음")
            return false
        }
        
        var isDir : ObjCBool = false
        var savePath = doucmentPathWrapped
        
        for fileDirectory in fileDirectories {
            savePath = savePath.appendingPathComponent(fileDirectory)
            
            // NSFileManager fileExistsAtPath:isDirectory and swift
            // http://stackoverflow.com/questions/24696044/nsfilemanager-fileexistsatpathisdirectory-and-swift
            
            if fileManager.fileExists(atPath: savePath.path, isDirectory: &isDir) {
                if isDir.boolValue {
                    log = ConsoleIO.writeLog(log, funcName: ("\(#function)"), outPut: "\(savePath.path) 디렉토리가 존재함.. 계속진행")
                    continue
                } else {
                    //fatalError("\(savePath.path) 디렉토리가 존재하지 않는데 filepath가 존재함 뭐지?")
                }
            } else {
                //print("\(savePath.path) 디렉토리가 존재하지 않음 어떻게 할까?")
                do {
                    try fileManager.createDirectory(at: savePath, withIntermediateDirectories: false, attributes: nil)
                    log = ConsoleIO.writeLog(log, funcName: ("\(#function)"), outPut: "\(savePath.path) 디렉토리를 생성함")
                } catch let error as NSError {
                    io.writeMessage(to: .error, error.description)
                }
            }
        }
        
        savePath = savePath.appendingPathComponent(fileName)
        
        // 파일저장이 일시를 초단위로 명시해서 진행함로 거의 사용될리가 없을것, 아래 분기
        if fileManager.fileExists(atPath: savePath.path) {
            let input = io.getInput("\(fileName)이 \(savePath)에 존재함 계속진행?(y)")
            if input != "y" && input != "Y" && input != "ㅛ" {
                io.writeMessage(to: .error, "\(fileName) 저장 안하고 종료")
                return false
            }
        }
        
        do {
            try data.write(to: savePath)
            io.writeMessage(to: .notice, "\(fileName)을 \(savePath.deletingLastPathComponent())에 저장 성공")
            return true
        } catch {
            io.writeMessage(to: .error, "\(fileName)을 저장하는데 실패하였음 - \(error)")
            return false
        }
    }
    
    func saveTest(_ test : Test) -> Bool {
        
        let data = test.createJsonObject()
        
        var testNumber : String = ""
        if let numHeplerWrapped = test.numHelper {
            testNumber = testNumber + String(format: "%04d",numHeplerWrapped) + "-" + String(format: "%03d", test.number)
        } else {
            testNumber = testNumber + String(format: "%03d", test.number)
        }
        
        if self.saveFile(
            fileDirectories: [test.testSubject.testCategory.testDatabase.key,  //DB
                test.testSubject.testCategory.category,    //시험명
                test.testSubject.subject,   //과목
                testNumber //회차
            ],
            fileName: "[\(Date().HHmmSS)]\(test.testSubject.testCategory.testDatabase.key)=\(test.key).json",
            data: data) {
            return true
        } else {
            return false
        }
    }
    
    
}

protocol Publishable {
    func publish(showAttribute: Bool, showAnswer: Bool, showTitle: Bool, showOrigSel : Bool)
}

protocol JSONoutable {
    func createJsonObject() -> Data?
}


extension String {
    var jsonDateFormat : Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: self)
        if let dateWrapped = date {
            return dateWrapped
        } else {
            return Date(timeIntervalSince1970: 0)
        }
    }
}


extension Date {
    
    var yyyymmdd : String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd."
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")!
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
    
    
    var HHmm : String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd. HH시 mm분"
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")!
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
    
    var HHmm2 : String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. M. d. H:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")!
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
    
    var HHmmss : String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd. HH시 mm분 ss초"
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")!
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
    
    var HHmmSS : String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd. HH시 mm분 ss.SS초"
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")!
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
    
    /// 2023.09.19.부터
    /// 이 포맷으로"만" 날짜를 표현하려 합니다.
    var myDateStirng : String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd._HH시mm분ss.SS초"
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")!
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
    
    
    var jsonFormat : String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
    
}

