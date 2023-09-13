//
//  DataConverter+Essential.swift
//  TestGenerator
//
//  Created by Masterbuilder on 2023/07/08.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import Foundation

extension DataConverter {
    
    // 2017. 5. 10.
    // 첫번째 : json 정답파일에서 시험과 문제, 정답의 원시정보를 가져옴
    // nested Json형태의 입력을 받을 수 있도록 수정되면 좋겠음 2017. 5. 12.
    // ->입력 answerPath 즉 json파일의 URL
    // 출력-> (category: String, subject: String, testNumber: Int, questonNumber: Int, answerNumber: Int)
    func extractTestAndAnswerJson() -> [(category: String, subject: String, testNumber: Int, questonNumber: Int, answerNumber: Int)] {
        
        let path = checkPath(path: answerPath)
        var result : [(category: String, subject: String, testNumber: Int, questonNumber: Int, answerNumber: Int)] = []
        
        // 정답을 파싱
        do {
            if let path = self.answerPath {
                let data = try Data(contentsOf: path)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                if let obj = json as? [Any] {  // [시험명, 과목, 회차, 문번, 정답]
                    
                    for dictionary in obj {  // [시험명, 과목, 회차, 문번, 정답]
                        
                        guard let  dict = dictionary as? [String : Any] else {
                            fatalError("유효하지 않은 JSON입력으로 진행할 수 없음 key-value 패어가 아님")
                        }
                        
                        
                        // 시험명 -> TestCategory
                        guard let 시험명 = dict["시험명"] as? String else {
                            fatalError("유효하지 않은 JSON입력으로 진행할 수 없음, 시험명을 찾을 수 없음")
                        }
                        
                        // 과목 -> TestSubject
                        guard let 과목 = dict["과목"] as? String else {
                            fatalError("유효하지 않은 JSON입력으로 진행할 수 없음, 과목을 찾을 수 없음")
                        }
                        
                        // 회차 -> test
                        guard let 회차 = dict["회차"] as? Int else {
                            fatalError("유효하지 않은 JSON입력으로 진행할 수 없음, 시험회차을 찾을 수 없음")
                        }
                        
                        // 문번 & 정답
                        guard let 문번 = dict["문번"] as? Int else {
                            fatalError("유효하지 않은 JSON입력으로 진행할 수 없음, 문번을 찾을 수 없음")
                        }
                        
                        guard let 정답 = dict["정답"] as? Int else {
                            fatalError("유효하지 않은 JSON입력으로 진행할 수 없음, 정답을 찾을 수 없음")
                        }
                        
                        let newQuestion = (시험명, 과목, 회차, 문번, 정답)
                        result.append(newQuestion)
                    }
                }
            }
        } catch {
            fatalError("josn파싱 중 에러발생")
        }
        
        // http://stackoverflow.com/questions/24048430/logging-method-signature-using-swift
        // Logging Method signature using swift
        log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "\(result.count)개의 문제와 정답을 찾았음")
        log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "\(path.path.precomposedStringWithCompatibilityMapping) 파싱 완료")
        
        return result
    }
    
    // 두번째 : extractTestAndAnswerJson에서 추출한 원시정보를 이용해서 최종 데이터를 정리
    // ->입력 (category: String, subject: String, testNumber: Int, questonNumber: Int, answerNumber: Int)
    // 출력-> self.testCategories 트리 아래에 모든 파싱정보를 담을 Templet.TestCategory의 배열
    //       여기에는 시험의 정보와 각 질문의 정답이 정리되어 메모리에서 가지고 있게됨
    func setTestAndAnswerTemplet(_ testAndAnswerTuple : [(category: String, subject: String, testNumber: Int, questonNumber: Int, answerNumber: Int)]) {
        var index = 0
        var jndex = 0
        var kndex = 0
        
        var catCounter = 0
        var subCounter = 0
        var testCounter = 0
        var answerCounter = 0
        
        for result in testAndAnswerTuple {
            
            
            if let i = self.testCategories.index(where: {$0.category == result.category}) {
                index = i
            } else {
                index  = self.testCategories.count
                self.testCategories.append(Templet.TestCategory(specification: "", category: result.category, catHelper: nil, raw: "", testSubjects: []))
                catCounter = catCounter + 1
            }
            
            
            
            if let i = self.testCategories[index].testSubjects.index(where: {$0.subject == result.subject}) {
                jndex = i
            } else {
                jndex  = self.testCategories[index].testSubjects.count
                self.testCategories[index].testSubjects.append(Templet.TestSubject(specification: "", subject: result.subject, tests: []))
                subCounter = subCounter + 1
            }
            
            
            if let i = self.testCategories[index].testSubjects[jndex].tests.index(where: {$0.number == result.testNumber}) {
                kndex = i
            } else {
                kndex  = self.testCategories[index].testSubjects[jndex].tests.count
                self.testCategories[index].testSubjects[jndex].tests.append(Templet.Test(revision: 0, specification: "", number: result.testNumber, numHelper: nil, date: nil, raw: "", answers: [], questions: []))
                testCounter = testCounter + 1
            }
            
            
            self.testCategories[index].testSubjects[jndex].tests[kndex].answers.append(Templet.Answer(questionNumber: result.questonNumber, answer: result.answerNumber))
            answerCounter = answerCounter + 1
            
        }
        
        for cat in self.testCategories {
            for sub in cat.testSubjects {
                for te in sub.tests {
                    log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "\(cat.category), \(sub.subject) 과목 \(te.number)회 시험에서 \(te.answers.count)개의 정답을 확인함")
                }
            }
            
        }
        
        
        log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "파싱자료를 분석하여 -> \(catCounter)개의 시험명 \(subCounter)개의 과목의 \(testCounter)회의 시험에서 \(answerCounter)개의 정답을 찾았음")
        
    }
    
    // 세번째 : 텍스트 파일에서 문제의 거의 모든 정보를 가져오는 매우 중요한 함수
    // -사용하는 함수 checkPath, getText, matchingStrings, sliceString
    func parseQustionsFromTextFile(testSep: String, queSep: String, selSep: String, numberOfSels: Int?, prefixPattern: String? = nil ) {
        
        
        
        // path를 확인 및 텍스트를 가져오고
        let paths = checkPath(paths: questionPaths)
        
        for path in paths {
            
            // 먼저 모든 텍스트에서 커멘트를 확인하여 제거하는 작업을 getText()함수 안의 commentOut()함수에서 진행한 뒤에 진행할 것이다. 2017. 5. 11.
            var wholeTestString = getText(path: path)
            
            // \r이 들어있는 텍스트는 뒤에서 사용하기 귀찮으므로 이를 의미가 다를바 없는 \n으로 모두 변경할 것이다. 2017. 5. 13.
            wholeTestString = wholeTestString.replacingOccurrences(of: "\r", with: "\n")
            
            // " "와 " "은 차이가 난다고 한다 대체 뭐가다른지 모르겠지만.. 그래서 모두 " "로 변경할 것이다. 2017. 6. 2.
            wholeTestString = wholeTestString.replacingOccurrences(of: " ", with: " ")
            
            // 여기에 추후 <u> </u> 태그 사이의 글을 밑줄로 표시해주는 기능을 추가해야한다.
            
            // 시험별로 쪼개고
            let testStrings = sliceString(regexPattern: testSep, string: wholeTestString)
            log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "\(path.path.precomposedStringWithCompatibilityMapping) 파일을 \(testStrings.count)개의 시험으로 나눠 파싱시작")
            
            
            
            // 시험에 대해서 문제를 쪼개는 작업을 시작함
            for testString in testStrings {
                
                // 문제별로 쪼개었음
                var questionStringsUnsorted = sliceString(regexPattern: queSep, string: testString.value)
                
                // 딕셔너리는 소트란 개념이 없어서 아래와 같은 삽질을 진행하였음 더 좋은 방법은? 2017. 5. 12. (+)
                // 일단 문자로 받던 소팅을 숫자로 바꿔서 진행하도록 수정 2017. 5. 14.
                
                var questionTitlesString = [Int : String]()
                var questionTitles = [Int]()
                
                for queInfo in questionStringsUnsorted {
                    guard let questionNumber = Int(queInfo.key.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) else {
                        fatalError("\(queInfo.key)에서 문제번호를 찾아낼 수 없음")
                    }
                    questionTitles.append(questionNumber)
                    questionTitlesString[questionNumber] = queInfo.key
                }
                
                questionTitles.sort()
                var questionStrings = [String]()
                for quT in questionTitles {
                    questionStrings.append(questionStringsUnsorted[questionTitlesString[quT]!]!)
                }
                
                
                // 시험정보에 대해서 matchingStrings 함수의 regex를 이용해서 분석한뒤 이 시험의 위치가 testCategories의 어디인지 밝혀내는 소중한 함수
                let testInfoArray = testString.key.matchingStrings(regex: testSep)
                if testInfoArray.count != 1 {
                    fatalError("이상한 시험정보 입력 \(testSep)")
                }
                let testInfo = testInfoArray[0]
                
                guard let index = testCategories.index(where: {$0.category == testInfo[1]}) else {
                    fatalError("정답파일에서 추출한 시험명이 없는 이상한 시험정보 입력 \(testSep)")
                }
                guard let jndex = testCategories[index].testSubjects.index(where: {$0.subject == testInfo[2]}) else {
                    fatalError("정답파일에서 추출한 과목명이 없는 이상한 시험정보 입력 \(testSep)")
                }
                
                log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "* \(testInfo[1]) \(testInfo[2])과목 \(testInfo[3])회 시험파싱 시작")
                
                
                // 그리고 이 시험의 위치 포인터 index, jndex를 찾아낸뒤 문제의 정보를 확인하기 시작함
                for (i, questionString) in questionStrings.enumerated() {
                    let questionTitle = questionTitles[i]
                    
                    
                    // 0. 추가할 정보의 정의
                    // 모든정보를 거짓으로 하여 새로운 문제 Templet.Qustion을 만듬
                    // 입력정보는 없어도 되지만 향후 사용 및 전체 문제에 입력할 데이터 조망을 위해 남겨두겠음
                    // 전체 조망을 하기에 가장 좋다. 입력할 항목별로 목록을 정리하였음 아주보기 편해짐 2017. 5. 12.
                    
                    var contentRaw = questionString
                    
                    var newQuestion = Templet.Question(revision: 0, // 최초의 생성이므로
                                                       specification: "",
                                                       number: 0,  //가짜입력
                                                       subjectDetails: [],
                                                       questionType: QuestionType.Unknown, // 6. 질문 그리고 입력값은 Default로 의미를 가짐
                                                       questionOX: QuestionOX.Unknown,   // 6. 질문 그리고 입력값은 Default로 의미를 가짐
                                                       contentPrefix: nil, // ==> 아직구현되지 않음
                                                       content: contentRaw,   // 6. 질문
                                                       notContent: nil, // 6. 질문
                                                       contentNote: nil, // 5. 질문부가사항
                                                       questionSuffix: nil, // 5. 질문부가사항
                                                       passage: nil,  // 1. 지문
                                                       passageSuffix: nil,
                                                       answer: 1,   // 4. 정답
                                                       raw: questionString,  // 0. 정의
                                                       rawSelections: "",   // 2. 선택지
                                                       rawLists: "",     // 3. 목록
                                                       selections: [],  // 2. 선택지
                                                       lists: []  // 3. 목록
                    )
                    
                    
                    
                    
                    
                    // 4. 정답
                    // 문제의 정답을 이미 찾아두었던 메모리상의 값의 리스트에서 찾아가는 과정
                    // regex에서 받은 질문형식에서 찾은 문장을 이용해서 문제번호를 추출하고
                    
                    // 필터는 포인터가 아니라 갚을 반환해줘서 사용이 안된다. 다른 방법은 없느가? 2017. 5. 7. (-)
                    // 아마도 index(where)로 찾아낼 수 있을 것임 2017. 5. 10.
                    guard let kndex = self.testCategories[index].testSubjects[jndex].tests.index(where: {$0.number == Int(testInfo[3])}) else {
                        fatalError("\(self.questionFileNames[0])에서 시험과 정답파일에서 찾은 시험을 찾을 수 없음")
                    }
                    
                    
                    newQuestion.number = questionTitle
                    
                    // 그러한 문제번호가 시험포인터가 가르키는 곳에 있는지 확인해써 있으면 저장하고 없으면 치명적 에러
                    guard let answer = testCategories[index].testSubjects[jndex].tests[kndex].answers.filter({$0.questionNumber == newQuestion.number}).first?.answer else {
                        fatalError("파싱한 문제에 맞는 전에 입력해두었던 문제의 정답이 없음")
                    }
                    newQuestion.answer = answer
                    log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "Q\(newQuestion.number) - 파싱시작 & 정답 \(newQuestion.answer) 입력완료")
                    
                    
                    
                    
                    // 1-1. 지문
                    
                    // 문제의 Passage인 <p> </p>를 처리
                    
                    
                    if let taggedTest = contentRaw.getTaggedText("p").taggedText {
                        newQuestion.passage = taggedTest
                        contentRaw = contentRaw.getTaggedText("p").modifiedText
                        log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: (String(repeating: " ", count: String(newQuestion.number).count) + "  - " + "지문 추가"))
                    }
                    
                    //                    2023. 6. 1. 5.0으로 업그레이
                    //                    if let taggedTest = contentRaw.getTaggedText("p").taggedText {
                    //                        newQuestion.passage = taggedTest
                    //                        contentRaw = contentRaw.getTaggedText("p").modifiedText
                    //                        log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: (String(repeating: " ", count: String(newQuestion.number).characters.count) + "  - " + "지문 추가"))
                    //                    }
                    
                    
                    
                    //                    변경된 사항:
                    
                    //                    String(newQuestion.number).characters.count를 String(newQuestion.number).count로 수정했습니다. Swift 5.0부터 characters 속성이 제거되었으며, 대신에 count 속성을 사용하여 문자열의 길이를 가져올 수 있습니다.
                    //                    getTaggedText("p")를 getTaggedText("p")?로 수정했습니다. Swift 5.0에서 옵셔널 체이닝 문법이 변경되었으며, 메서드 호출 결과가 옵셔널 타입일 때 ?를 사용하여 안전하게 옵셔널 체이닝할 수 있습니다.
                    
                    
                    
                    // 1-2. 지문Suffix
                    
                    if let taggedTest = contentRaw.getTaggedText("d").taggedText {
                        if newQuestion.passage == nil {
                            fatalError("지문도 없는데 지문Suffix가 정의되었음, <d>태그 입력잘못임 \(path.path) 파일 \(testString.key) \(newQuestion.number) 문제")
                        }
                        newQuestion.passageSuffix = taggedTest
                        contentRaw = contentRaw.getTaggedText("d").modifiedText
                        log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: (String(repeating: " ", count: String(newQuestion.number).count) + "  - " + "지문 suffix 추가"))
                    }
                    
                    
                    
                    
                    // 2. 선택지
                    // 먼저 "위 (①|②|③|④|⑤|⑥|⑦|⑧|⑨|⑩)" 형태의 진술이 존재하는지 체크해야 한다.
                    // 체크안하면 선택지 파싱자체가 엉망이 된다.
                    
                    let contentRawTemp = contentRaw
                    contentRaw = anotherSelectionPaser(contentRaw)
                    if contentRawTemp != contentRaw {
                        log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: (String(repeating: " ", count: String(newQuestion.number).count) + "  - " + "선택지에 있는 다른 진술에 관한 정보 태그<anotherStatement>을 반영함"))
                    }
                    
                    
                    // 문제텍스트 중에 선택지는 항상 잇어야 하므로 선택지가 잇는지를 확인하고
                    // 특히 이는 꼭있어야 되니 없으면 치명적 에러
                    // 이 후 선택지텍스트를 찾아냄
                    // ->입력 contentRaw, selectionSeperator (regex)
                    // 출력-> selectionStrings
                    
                    let selectionRange = contentRaw.range(of: selSep, options: .regularExpression)
                    guard let selectionRangeWrapped = selectionRange else {
                        fatalError("\(path.path) 파일 \(testString.key)시험 \(questionTitle)문제 파싱 중 문제의 선택지를 찾을 수 없음")
                    }
                    let selectionStrings = contentRaw.substring(with: selectionRangeWrapped)
                    
                    
                    // 선택지를 파싱하여 selectionStringSliced을 만들고
                    // 이를 분석해서 여러개의 선택지를 만들어냄
                    // que.rawSelections = queCutSelection.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    let selectionStringSliced = sliceString(regexPattern: "①|②|③|④|⑤|⑥|⑦|⑧|⑨|⑩", string: selectionStrings)
                    for selection in selectionStringSliced {
                        
                        var newSelection = Templet.Selection()
                        newSelection.content = selection.value.trimmingCharacters(in: .whitespacesAndNewlines)
                        newSelection.notContent = nil
                        newSelection.number = selection.key.roundInt
                        
                        newQuestion.selections.append(newSelection)
                        
                    }
                    
                    
                    // 선택지가 주어진 갯수와 맞는지 체크하는 함수, 입력이 nil이면 하지않음
                    
                    if let numberOfSelectionsWrapped = numberOfSels {
                        if selectionStringSliced.count != numberOfSelectionsWrapped {
                            log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: (String(repeating: " ", count: String(newQuestion.number).count) + "  - " + "선택지가 필요한 갯수 \(numberOfSelectionsWrapped)와 다른 \(selectionStringSliced.count)개 확인)"))
                            fatalError("\(testString.key) - \(questionTitle) 에는 선택지가 필요한 갯수인 \(numberOfSelectionsWrapped)개와 다른 \(selectionStringSliced.count)개가 있음")
                        }
                        log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: (String(repeating: " ", count: String(newQuestion.number).count) + "  - " + "선택지 \(newQuestion.selections.count)개 확인(필요한 개수와 동일)"))
                    } else {
                        log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: (String(repeating: " ", count: String(newQuestion.number).count) + "  - " + "선택지 \(newQuestion.selections.count)개 확인(시험마다 동일한지 체크안함)"))
                    }
                    
                    // 문제텍스트에서 선택지 텍스트를 제거함, 이게 문제의 content가 될 수 있음
                    // 만약 선택지 뒤에 잡다한 텍스트가 잇다면 어그러질 것 그치만 그런 형식의 텍스트가 입력되는 일은 없겠지?
                    // 문제를 정확하게 자르지 못하지 않는한 그런일 없다.
                    contentRaw = contentRaw.substring(with: contentRaw.startIndex..<selectionRangeWrapped.lowerBound)
                    
                    
                    
                    
                    
                    
                    // 3. 목록
                    
                    // 각각 가나다 형태와 ㄱㄴㄷ 목록이 있는지 확인해서 문제텍스트를 잘라 가지고 있음
                    // queCutListSelWord와 queCutListSelLetter
                    // ->입력 contentRaw
                    var contentSuffix : String? = nil
                    let listStringResult = getListString(contentRaw: contentRaw, contentSuffix: contentSuffix)
                    contentRaw = listStringResult.contentRaw
                    contentSuffix = listStringResult.contentSuffix
                    let listsString = listStringResult.lists
                    let listType = listStringResult.listType
                    
                    
                    
                    
                    
                    // 잘라낸 가나다 혹은 ㄱㄴㄷ 문장들을 각각 파싱
                    let listParserResult = listParser(listString: listsString, listType: listType)
                    newQuestion.rawLists = listParserResult.rawLists
                    newQuestion.lists = listParserResult.lists
                    if listsString != nil {
                        newQuestion.questionType = .Find
                        log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: (String(repeating: " ", count: String(newQuestion.number).count) + "  - " + "목록 선택지 \(newQuestion.lists.count)개 확인"))
                    }
                    
                    
                    
                    
                    //5. 질문부가사항
                    // 위치에 대해서 생각해봐야 함, 맨앞? 컨텐트 입력직전?
                    // => 이는 질문 Suffix이고 따라서 질문 앞에서 검토,
                    // 추가로 지문의 suffix 태그 <d>를 정의햇는데 이는 패시지 앞에서 검토할 것임
                    
                    
                    if let taggedTest = contentRaw.getTaggedText("s").taggedText {
                        newQuestion.questionSuffix = taggedTest
                        contentRaw = contentRaw.getTaggedText("s").modifiedText
                    } else {
                        newQuestion.questionSuffix = contentSuffix?.trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                    if newQuestion.questionSuffix != nil {
                        log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: (String(repeating: " ", count: String(newQuestion.number).count) + "  - " + "질문 suffix 추가"))
                    }
                    
                    
                    //5-2. 질문 prefix 사항
                    if let prefixPatternUnwrapped = prefixPattern {
                        let range = contentRaw.range(of: prefixPatternUnwrapped, options: .regularExpression)
                        if range != nil {
                            newQuestion.contentPrefix = contentRaw.substring(with: range!)
                            contentRaw = contentRaw.substring(with: range!.upperBound..<contentRaw.endIndex)
                            log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: (String(repeating: " ", count: String(newQuestion.number).count) + "  - " + "질문 prefix 추가 : \(newQuestion.contentPrefix!)"))
                        } else {
                            log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: (String(repeating: " ", count: String(newQuestion.number).count) + "  - " + "질문 prefix 찾을 수 없음"))
                        }
                        
                    }
                    
                    
                    
                    
                    //6. 질문
                    
                    
                    
                    
                    // 가) contentNote
                    
                    // contentNote를 검토할 Regex표현의 배열
                    let contNotesRegexDB = ["\\(다툼이 있는 경우 판례에 의함\\)"
                                            , "\\(다툼이 있는 경우 헌법재판소 판례에 의함\\)"
                                            , "\\(다툼이 있는 경우에는 판례에 의함\\)"
                                            , "\\(각 지문은 독립적이며, 다툼이 있는 경우 판례에 의함\\)"
                                            , "\\(각 지문은 독립적이고, 다툼이 있는 경우에는 판례에 의함\\)"
                                            , "\\(다툼이 있는 경우에는 판례에 의하고, 각 지문은 모두 독립적이다\\)"
                    ]
                    for contNote in contNotesRegexDB {
                        let result = contentRaw.getElimatedText(contNote)
                        if result.textToElimate != nil {
                            if newQuestion.contentNote == nil {
                                newQuestion.contentNote = result.textToElimate!
                                contentRaw = result.elimatedText
                                log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: (String(repeating: " ", count: String(newQuestion.number).count) + "  - " + "질문에 Note \"\(newQuestion.contentNote!)\" 추출"))
                            } else {
                                fatalError("\(path.path) 파일 \(testString.key) \(newQuestion.number) 질문에 질문노트가 여러개 발견되었음")
                            }
                        }
                    }
                    
                    
                    
                    
                    
                    
                    
                    // 최종정리
                    
                    
                    // 질문의 앞뒤 새줄 트리밍
                    
                    newQuestion.content = contentRaw.trimmingCharacters(in: .whitespacesAndNewlines)
                    if newQuestion.content == "" {
                        fatalError("\(path.path) \(testString.key) \(newQuestion.number) 문제에 질문이 없음")
                    }
                    
                    
                    // 질문을 분석하여 문제타입 검토
                    
                    // content를 잘 분석하면 많은 정보를 얻을 수 잇을 가능성이 많다. 향후 경우의 수를 최대한 많이 생각해서
                    // 시간 날때마다 틈틈히 추가해 나가는 것이 필요하다 (+) 2017. 5. 11.
                    
                    // 여기서 newQuestion.content를 검토하는데 사실 raw데이터이다. 편리하기는하나 위험할 수 있다 위험점에 대허서 미리 생각해야 한다.
                    
                    
                    
                    let questionContentPairs = DataConverterData().questionContentPair
                    
                    
                    
                    
                    // 문제의논리에 매우 중요한 함수이므로 오류가 없는지 다시 확인
                    for qPair in questionContentPairs {
                        
                        if newQuestion.content.contains(qPair.content) {
                            
                            newQuestion.questionType = qPair.type
                            newQuestion.questionOX = qPair.OX
                            
                            if newQuestion.questionOX != .Correct {
                                guard let qPairContCont = qPair.notContent else {
                                    fatalError("질문지 페어의 맞는 상대편이 없음")
                                }
                                newQuestion.notContent = newQuestion.content.replacingOccurrences(of: qPair.content, with: qPairContCont)
                            }
                        }
                        
                        if let conControversal = qPair.notContent {
                            
                            if newQuestion.content.contains(conControversal) {
                                
                                newQuestion.questionType = qPair.type
                                newQuestion.questionOX = .X
                                
                                newQuestion.notContent = newQuestion.content.replacingOccurrences(of: conControversal, with: qPair.content)
                                
                            }
                        }
                    }
                    // Find타입은 목록을 반전하지 선택지를 반전하지 않으므로(맞나?) 반전지문이 원래지문과 동일
                    if newQuestion.questionType == .Find {
                        for (index,sel) in newQuestion.selections.enumerated() {
                            newQuestion.selections[index].notContent = sel.content
                        }
                    }
                    
                    log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: (String(repeating: " ", count: String(newQuestion.number).count) + "  - " + "문제 타입은 \(newQuestion.questionType) \(newQuestion.questionOX)"))
                    
                    
                    
                    
                    // 질문 로깅
                    log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: " 질문 : \""+newQuestion.content+"\"")
                    log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: " 반전 : \""+(newQuestion.notContent != nil ? newQuestion.notContent! : "없음")+"\"")
                    
                    testCategories[index].testSubjects[jndex].tests[kndex].questions.append(newQuestion)
                    // question 정보중에 추가할게 없는지 확인필요 2017. 5. 7.
                    // 지문과 contentSuffix를 추가함 contentPrefix와 도표 추가 필요? 2017. 5. 11.
                    
                    
                }
                log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "* \(testInfo[1]) \(testInfo[2])과목 \(testInfo[3])회 시험파싱 시작 \(questionStrings.count)개 문제로 나누어 정보를 얻는데 성공")
            }
        }
    }
    
    // 네번째 : 파싱한 시험과 질문데이터를 소팅해주는 함수
    //         저장전에 불러주면 좋을 듯
    func sortTestAndQuestion() {
        
        
        // How do you sort an array of structs in swift
        // http://stackoverflow.com/questions/24781027/how-do-you-sort-an-array-of-structs-in-swift
        
        
        
        for (index,_) in self.testCategories.enumerated() {
            
            testCategories[index].testSubjects.sort{$0.subject < $1.subject}
            
            for (jndex,_) in testCategories[index].testSubjects.enumerated() {
                
                testCategories[index].testSubjects[jndex].tests.sort{$0.number < $1.number}
                
                for (kndex, _) in testCategories[index].testSubjects[jndex].tests.enumerated() {
                    
                    
                    testCategories[index].testSubjects[jndex].tests[kndex].questions.sort{$0.number < $1.number}
                    
                    
                    for (lndex, _) in testCategories[index].testSubjects[jndex].tests[kndex].questions.enumerated() {
                        
                        testCategories[index].testSubjects[jndex].tests[kndex].questions[lndex].selections.sort{$0.number < $1.number}
                        testCategories[index].testSubjects[jndex].tests[kndex].questions[lndex].lists.sort{$0.number < $1.number}
                        
                    }
                }
            }
        }
    }
    
    // ??
    func uploadTests() -> Bool {
        
        sortTestAndQuestion()
        
        var catCounter = 0
        var subCounter = 0
        var testCounter = 0
        var queCounter = 0
        var listCounter = 0
        var selCounter = 0
        
        
        for testCategory in testCategories {
            
            let newTestCategory = TestCategory(testDatabase: self.testDatabase, category: testCategory.category, catHelper: testCategory.catHelper)
            newTestCategory.specification = testCategory.specification
            catCounter = catCounter + 1
            
            for testSubject in testCategory.testSubjects {
                let newTestSubject = TestSubject(testCategory: newTestCategory, subject: testSubject.subject)
                newTestSubject.specification = testSubject.specification
                subCounter = subCounter + 1
                // 다른 저장할 것들은 없으려나?
                
                for test in testSubject.tests {
                    
                    let newTest = Test(createDate: Date(), testSubject: newTestSubject, revision: test.revision, isPublished: true, number: test.number, numHelper: test.numHelper)
                    newTest.specification = test.specification
                    testCounter = testCounter + 1
                    
                    for question in test.questions {
                        // 2023. 9. 13. UUID로 문제를 식별하는 기술을 도입하기 시작했습니다. 혁명적 변화로 그 영향도를 계속 검토해야 합니다. (-)
                        // ★★★★★ 아마도 이 부분이 앞으로의 문제 아이디를 정의하게 되는 부분으로 보입니다. 오직 이곳에서만 문제의 id를 uuid()로 초기화해야 할 듯하니 확인요합니다. (-)
                        let newQuestion = Question(id: UUID(), revision: question.revision, test: newTest, number: question.number, questionType: question.questionType, questionOX: question.questionOX, content: question.content, answer: question.answer)
                        queCounter = queCounter + 1
                        
                        newQuestion.contentPrefix = question.contentPrefix
                        
                        newQuestion.notContent = question.notContent
                        newQuestion.contentNote = question.contentNote
                        newQuestion.questionSuffix = question.questionSuffix
                        newQuestion.passage =  question.passage
                        newQuestion.passageSuffix =  question.passageSuffix
                        newQuestion.specification =  question.specification
                        
                        newQuestion.raw =  question.raw
                        newQuestion.rawLists = question.rawLists
                        newQuestion.rawSelections =  question.rawSelections
                        // 다 저장한 것 맞은건가? 항상 확인해야 하는 곳임
                        // 2017. 5. 13.
                        
                        for selection in question.selections {
                            let newSelection = Selection(revision: selection.revision, question: newQuestion, number: selection.number, content: selection.content)
                            newSelection.notContent = selection.notContent
                            newSelection.specification = selection.specification
                            selCounter = selCounter + 1
                        }
                        for list in question.lists {
                            
                            var listCharacter : String
                            switch list.listStringType {
                            case .koreanCharcter:
                                listCharacter = list.number.koreanCharaterInt
                            case .koreanLetter:
                                listCharacter = list.number.koreanLetterInt
                            }
                            
                            let newList = ListSelection(revision: list.revision, question: newQuestion, content: list.content, selectString: listCharacter)
                            // 아래 반전지문 넣어주는게 꼭 필요한 작업인가?
                            // 실수로 목록지가 안들어간 문제에 반전지문이 들어가버리는 문제가 발생했었다. 2017. 5. 20.
                            newList.notContent = list.notContent
                            newList.specification = list.specification
                            listCounter = listCounter + 1
                        }
                        
                        // 이것을 안하니 .Find형식의 문제에서는 섞은 문제가 정답을 찾지 못하는 문제가 발생했다.
                        // 빼먹어도 문제없도록 자동실행 방안을 찾으면 좋겠다. 2017. 5. 9.
                        _ = newQuestion.findAnswer()
                    }
                }
            }
        }
        log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "\(catCounter)개의 범주 \(subCounter)개의 과목 \(testCounter)개 회차의 시험에서 \(queCounter)개 문제와 \(listCounter)개 목록진술 \(selCounter)개의 선택지를 불러오기 완료")
        return true
    }
}

extension String {
    // http://stackoverflow.com/questions/27880650/swift-extract-regex-matches
    // Swift extract regex matches
    // 2017. 5. 10. 공부를 해야, 아주 훌륭한 공부예제일 것 (+) 지금은 잘 모르는 구문이지만..
    func matchingStrings(regex: String) -> [[String]] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return [] }
        let nsString = self as NSString
        let results  = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
        return results.map { result in
            (0..<result.numberOfRanges).map { result.range(at: $0).location != NSNotFound
                ? nsString.substring(with: result.range(at: $0))
                : ""
            }
        }
    }
    
    // 내가 만든 태그안에 있는 텍스트를 가져오는 함수
    // 노가다의 산물로 더 깔끔하게 짜는 방법이 있을듯 하나 모르겟음 개선필요
    // 특히 레겍스 식을 연구해야함  (+) 2017. 5. 12.
    func getTaggedText(_ tag : String) -> (modifiedText : String, taggedText : String?){
        var modifiedText : String = self
        var taggedText : String? = nil
        
        // Regex select all text between tags
        // http://stackoverflow.com/questions/7167279/regex-select-all-text-between-tags
        // 꼭 공부해야하는 좋은 구문 2017. 5. 11. -> 별로 효율적이지 못해서
        // 아래 구문으로 변경함
        // Regular expression to match all characters between <h1> tag
        // http://stackoverflow.com/questions/14525286/regular-expression-to-match-all-characters-between-h1-tag
        
        let regexTag = "(?s)<" + tag + ">(.+)</" + tag+">"  // "(?s)<p>.+</p>"
        if let range = self.range(of: regexTag, options: .regularExpression) {
            taggedText = self.substring(with: range)
            modifiedText = self.substring(with: self.startIndex..<range.lowerBound) + self.substring(with: range.upperBound..<self.endIndex)
            
            //        let tagRegex = "(?s)<" + tag + ">.+</" + tag+"s>"
            //        if let passageRange = originalText.range(of: tagRegex, options: .regularExpression) {
            // 태그안의 값만 가져오도록 수정해야 하는데 이 구문이 먹지 않아 삽질해서 구현하였음 향후 레겍스 개발 필요 2017. 5. 12. (+)
            
            let lowerTagRange = taggedText!.range(of: "<" + tag + ">", options: .regularExpression)
            let upperTagRange = taggedText!.range(of: "</" + tag + ">", options: .regularExpression)
            taggedText = taggedText?.substring(with: (lowerTagRange?.upperBound)!..<(upperTagRange?.lowerBound)!)
        }
        return (modifiedText, taggedText)
    }
    
    func getElimatedText(_ regexToElimate : String, spaceCheck : Bool = false) -> (elimatedText : String, textToElimate : String?) {
        
        // http://stackoverflow.com/questions/24200888/any-way-to-replace-characters-on-swift-string
        // Any way to replace characters on Swift String?
        let regex = spaceCheck ? regexToElimate : regexToElimate.replacingOccurrences(of: " ", with: "\\s")
        
        var elimatedText = self
        var textToElimateResult : String? = nil
        
        if let range = self.range(of: regex, options: .regularExpression) {
            textToElimateResult = elimatedText.substring(with: range)
            // 왜 offset을 +1, -1해줘야 하는지 모르겠다. 그냥 일단 넘어가는데 나중에 자세하게 탐구 필요 2017. 5. 13. (+)
            elimatedText =
                elimatedText.substring(with: elimatedText.startIndex..<index(range.lowerBound, offsetBy : -1))
                +
                elimatedText.substring(with: index(range.upperBound, offsetBy : 1)..<elimatedText.endIndex)
        }
        
        
        
        return (elimatedText, textToElimateResult)
    }
}
