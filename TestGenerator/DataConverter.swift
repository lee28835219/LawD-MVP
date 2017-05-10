//
//  DataConverter.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 1..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

//How can I quickly and easily convert spreadsheet data to JSON? [closed]
//http://stackoverflow.com/questions/19187085/how-can-i-quickly-and-easily-convert-spreadsheet-data-to-json

//Read and write data from text file
//http://stackoverflow.com/questions/24097826/read-and-write-data-from-text-file
class DataConverter: NSObject {
    var log : String = "Data Converter Log 시작 \(Date().HHmmss)\n"
    
    var testDatabase : TestDatabase
    
//    var tests : [Templet.Test] = []
    var testCategories : [Templet.TestCategory] = []
    
    var answerFilename : String
    var questionFilename : String
    let answerPath : URL?
    let questionPath : URL?
    
//    let testCategory : String
//    var catHelper : String? = nil
//    let subject : String
    
    private var _headerAndResidualStrings : [String : String] = [:]
    
    
    
    init(testDatabase : TestDatabase,
         answerFilename: String,
         questionFilename : String) {
        
        self.testDatabase = testDatabase
        self.answerFilename = answerFilename
        self.questionFilename = questionFilename
        
        //Accessing files in xcode
        //https://www.youtube.com/watch?v=71DnOYeqJuM
        //Mac OX 는 Bundle이라는 개념이 없는듯 하다, 프로젝트에 txt를 가지고 다니도록 하는 방법을 더 찾아봐야 한다 (+) 2017. 5. 1.
        
        //How can I add a file to an existing Mac OS X .app bundle?
        //http://stackoverflow.com/questions/14950440/how-can-i-add-a-file-to-an-existing-mac-os-x-app-bundle
        
        //일단 system의 document폴더 안의 TestGeneratorResource 에서 읽는 것으로 진행
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let dirTestGeneratorResource = dir.appendingPathComponent("Test").appendingPathComponent("TestGeneratorResource")
            self.answerPath = dirTestGeneratorResource.appendingPathComponent(self.answerFilename)
            self.questionPath = dirTestGeneratorResource.appendingPathComponent(self.questionFilename)
        } else {
            fatalError("파일을 파싱해서 저장하려는 Document 폴더가 존재하지 않음")
        }
    }
    
    
    // 2017. 5. 10.
    // 첫번째 : json 정답파일에서 시험과 문제, 정답의 원시정보를 가져옴
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
        
        log = log + "  \(Date().HHmmss) : \(result.count)개의 문제와 정답을 찾았음\n"
        log = log + "  \(Date().HHmmss) : \(path.path) 파싱 완료\n"
        
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
                self.testCategories[index].testSubjects[jndex].tests.append(Templet.Test(specification: "", number: result.testNumber, numHelper: nil, date: nil, raw: "", answers: [], questions: []))
                testCounter = testCounter + 1
            }
            
            
            
            self.testCategories[index].testSubjects[jndex].tests[kndex].answers.append(Templet.Answer(questionNumber: result.questonNumber, answer: result.answerNumber))
            answerCounter = answerCounter + 1
        }
        
        
        log = log + "  \(Date().HHmmss) : 파싱자료를 분석하여 -> \(catCounter)개의 시험명에서 \(subCounter)개의 과목의 \(testCounter)회의 시험에서  \(answerCounter)개의 정답을 찾았음 \n"
        
        
        
//        print("==================================")
//        for cat in self.testCategories {
//            print(cat.category)
//            for sub in cat.testSubjects {
//                print("  ",cat.category, "=", sub.subject)
//                for te in sub.tests {
//                    print("    ",cat.category, "=", sub.subject,"=", te.number)
//                    for qu in te.answers {
//                        print("      ",qu.questionNumber, qu.answer)
//                    }
//                }
//            }
//            
//        }
//        print("==================================")
    }
    
    // 세번째 : 텍스트 파일에서 문제의 거의 모든 정보를 가져오는 매우 중요한 함수
    // -사용하는 함수 checkPath, getText, matchingStrings, sliceString
    //
    //
    func parseQustionsFromTextFile(testSeperator: String, questionSeperator: String, contentSuffixSeperator: String? = nil, selectionSeperator: String, numberOfSelections: Int?) {
        
        // path를 확인 및 텍스트를 가져오고
        let path = checkPath(path: questionPath)
        let wholeTestString = getText(path: path)
        
        
        // 시험별로 쪼개고
        let testStrings = sliceString(regexPattern: testSeperator, string: wholeTestString)
        log = log + "  \(Date().HHmmss) : \(path.path) 텍스트를 \(testStrings.count)개의 시험으로 나누는데 성공\n"
        
        
        
        for testString in testStrings {
            
            
            // 문제별로 쪼개었음
            let questionStrings = sliceString(regexPattern: questionSeperator, string: testString.value)
            log = log + "  \(Date().HHmmss) : \(testString.key) 시험을 \(questionStrings.count)개 문제로 나누는데 성공\n"
            
            
            // 시험정보에 대해서 matchingStrings 함수의 regex를 이용해서 분석한뒤 이 시험의 위치가 testCategories의 어디인지 밝혀내는 소중한 함수
            let testInfoArray = testString.key.matchingStrings(regex: testSeperator)
            if testInfoArray.count != 1 {
                fatalError("이상한 시험정보 입력 \(testSeperator)")
            }
            let testInfo = testInfoArray[0]
            
            guard let index = testCategories.index(where: {$0.category == testInfo[1]}) else {
                fatalError("이상한 시험정보 입력 \(testSeperator)")
            }
            guard let jndex = testCategories[index].testSubjects.index(where: {$0.subject == testInfo[2]}) else {
                fatalError("이상한 시험정보 입력 \(testSeperator)")
            }
            
            
            // 그리고 이 시험의 위치 포인터 index, jndex를 찾아낸뒤 문제의 정보를 확인하기 시작함
            for questionStringDictionary in questionStrings {
                
                // 필터는 포인터가 아니라 갚을 반환해줘서 사용이 안된다. 다른 방법은 없느가? 2017. 5. 7. (-)
                // 아마도 index(where)로 찾아낼 수 있을 것임 2017. 5. 10.
//                var currentIndex = -1
//                for (kndex,test) in self.testCategories[index].testSubjects[jndex].tests.enumerated() {
//                    //getTestNumber 함수에서 가져오던 시험의 숮자를 레겍스로 정밀하게 가져오도록 수정함 2017. 5. 10. 비록 함수는 배꼈지만..
//                    if test.number == Int(testInfo[3]) {
//                        currentIndex = kndex
//                        break
//                    }
//                }
//                
//                if currentIndex == -1 {
//                    fatalError("\(self.questionFilename)에서 시험과 정답파일에서 찾은 시험을 찾을 수 없음")
//                }
                
                guard let kndex = self.testCategories[index].testSubjects[jndex].tests.index(where: {$0.number == Int(testInfo[3])}) else {
                    fatalError("\(self.questionFilename)에서 시험과 정답파일에서 찾은 시험을 찾을 수 없음")
                }
                
                
                
                var contentRaw = questionStringDictionary.value
                // 모든정보를 거짓으로 하여 새로운 문제 Templet.Qustion을 만듬
                // 입력정보는 없어도 되지만 향후 사용 및 전체 문제에 입력할 데이터 조망을 위해 남겨두겠음
                var newQuestion = Templet.Question(specification: "",
                                                   number: 0,
                                                   subjectDetails: [],
                                                   questionType: QuestionType.Unknown,
                                                   questionOX: QuestionOX.Unknown,
                                                   content: contentRaw,
                                                   contentControversal: nil,
                                                   contentPrefix: nil,
                                                   contentNote: nil,
                                                   passage: nil,
                                                   contentSuffix: nil,
                                                   answer: 1,
                                                   raw: "",
                                                   rawSelections: "",
                                                   rawLists: "",
                                                   selections: [],
                                                   lists: []
                )
                
                
                var contentSuffix : String?
                
                
                // 문제의 Passage인 <p> </p>를 처리
                // Regex select all text between tags
                // http://stackoverflow.com/questions/7167279/regex-select-all-text-between-tags
                // 꼭 공부해야하는 좋은 구문 2017. 5. 11.
                var passage : String?
                if let passageRange = contentRaw.range(of: "(?<=(<p>))(\\w|\\d|\\n|[().,\\-:;@#$%^&*\\[\\]\"'+–/\\/®°⁰!?○{}|`~]| )+?(?=(</p>))", options: .regularExpression) {
                    if let passageRangeOutrange = contentRaw.range(of: "<p>(\\w|\\d|\\n|[().,\\-:;@#$%^&*\\[\\]\"'+–/\\/®°⁰!?○{}|`~]| )+?</p>", options: .regularExpression) {
                        passage = contentRaw.substring(with: passageRange)
                        contentRaw = contentRaw.substring(with: contentRaw.startIndex..<passageRangeOutrange.lowerBound) + contentRaw.substring(with: passageRangeOutrange.upperBound..<contentRaw.endIndex)
                    }
                }
                
                
                
                // 문제텍스트 중에 선택지는 항상 잇어야 하므로 선택지가 잇는지를 확인하고
                // 특히 이는 꼭있어야 되니 없으면 치명적 에러
                // 이 후 선택지텍스트를 찾아냄
                // ->입력 contentRaw, selectionSeperator (regex)
                // 출력-> selectionStrings
                let selectionRange = contentRaw.range(of: selectionSeperator, options: .regularExpression)
                guard let selectionRangeWrapped = selectionRange else {
                    fatalError("\(testString.key)시험의 \(questionStringDictionary.key)문제 파싱 중 문제의 선택지를 찾을 수 없음")
                }
                let selectionStrings = contentRaw.substring(with: selectionRangeWrapped)
                
                
                
                // 선택지를 파싱하여 selectionStringSliced을 만들고
                // 이를 분석해서 여러개의 선택지를 만들어냄
                // que.rawSelections = queCutSelection.trimmingCharacters(in: .whitespacesAndNewlines)
                let selectionStringSliced = sliceString(regexPattern: "①|②|③|④|⑤|⑥|⑦|⑧|⑨|⑩", string: selectionStrings)
                for selection in selectionStringSliced {
                    
                    var newSelection = Templet.Selection()
                    newSelection.content = selection.value.trimmingCharacters(in: .whitespacesAndNewlines)
                    newSelection.contentControversal = nil
                    newSelection.number = selection.key.roundInt
                    
                    newQuestion.selections.append(newSelection)
                    
                }
                
                
                
                // 선택지가 주어진 갯수와 맞는지 체크하는 함수, 입력이 nil이면 하지않음
                if let numberOfSelectionsWrapped = numberOfSelections {
                    if selectionStringSliced.count > numberOfSelectionsWrapped {
                        fatalError("\(testString.key) - \(questionStringDictionary.key) 에는 선택지가 \(numberOfSelectionsWrapped)개 보다많음")
                    }
                }
                
                
                // 문제텍스트에서 선택지 텍스트를 제거함, 이게 문제의 content가 될 수 있음
                // 만약 선택지 뒤에 잡다한 텍스트가 잇다면 어그러질 것 그치만 그런 형식의 텍스트가 입력되는 일은 없겠지?
                // 문제를 정확하게 자르지 못하지 않는한 그런일 없다.
                contentRaw = contentRaw.substring(with: contentRaw.startIndex..<selectionRangeWrapped.lowerBound)
                
                
                
                // 각각 가나다 형태와 ㄱㄴㄷ 목록이 있는지 확인해서 문제텍스트를 잘라 가지고 있음
                // queCutListSelWord와 queCutListSelLetter
                // ->입력 contentRaw
                var queCutListSelWord : String? = nil
                let queCutListSelWordRange = contentRaw.range(of: "(가(\\..+\\n{0,}\\s{0,}))((나|다|라|마|바|사|아|자|차|카|타|파|하)(\\..+\\n{0,}\\s{0,})){1,14}", options: .regularExpression)
                if queCutListSelWordRange != nil {
                    queCutListSelWord = contentRaw.substring(with: queCutListSelWordRange!)
                    
                    
                    // 이 지점에서 목록 문장 뒤에 있는 문제정보가 contentRaw에서 날라가 버리는 문제가 발생한다
                    // 이는 꼭 바로잡아야 되는 문제이다. 그래서 수정하엿다. 그치만 출력함수가 안변하면 의미 없을 것이다. 2017. 5. 11. 꼭 바꾸길 (+)
                    // 제대로 작동하는지 디버깅을 안해봐서 모르겠다. 담에 꼭해야함, <p>~~</p>처리도 함께
                    contentRaw = contentRaw.substring(with: contentRaw.startIndex..<queCutListSelWordRange!.lowerBound)
                    if queCutListSelWordRange!.upperBound < contentRaw.endIndex {
                        contentSuffix = contentRaw.substring(with: queCutListSelWordRange!.upperBound..<contentRaw.endIndex)
                    }
                }
                
                var queCutListSelLetter : String? = nil
                let queCutListSelLetterRange = contentRaw.range(of: "((ㄱ|ㄴ|ㄷ|ㄹ|ㅁ|ㅂ|ㅅ|ㅇ|ㅈ|ㅊ|ㅋ|ㅌ|ㅍ|ㅎ)(\\..+\\n{0,}\\s{0,})){1,14}", options: .regularExpression)
                if queCutListSelLetterRange != nil {
                    queCutListSelLetter = contentRaw.substring(with: queCutListSelLetterRange!)
                    contentRaw = contentRaw.substring(with: contentRaw.startIndex..<queCutListSelLetterRange!.lowerBound)
                    if queCutListSelLetterRange!.upperBound < contentRaw.endIndex {
                        contentSuffix = contentRaw.substring(with: queCutListSelLetterRange!.upperBound..<contentRaw.endIndex)
                    }
                }
                
                
                
                // 가나다와 ㄱㄴㄷ이 둘다 존재할 수는 없을것
                if queCutListSelWord != nil && queCutListSelLetter != nil {
                    fatalError("문제 파싱중에 목록선택지의 구조가 이상하게 파싱되었음")
                }
                
                
                // 잘라낸 가나다 혹은 ㄱㄴㄷ 문장들을 각각 파싱
                if queCutListSelLetter != nil {
                    newQuestion.rawLists = queCutListSelLetter!.trimmingCharacters(in: .whitespacesAndNewlines)
                    let listsDictionary = sliceString(regexPattern: "ㄱ\\.|ㄴ\\.|ㄷ\\.|ㄹ\\.|ㅁ\\.|ㅂ\\.|ㅅ\\.|ㅇ\\.|ㅈ\\.|ㅊ\\.|ㅋ\\.|ㅌ\\.|ㅍ\\.|ㅎ\\.", string: newQuestion.rawLists)
                    for listDictionary in listsDictionary {
                        var newList = Templet.List()
                        newList.specification = ""
                        newList.content = listDictionary.value.trimmingCharacters(in: .whitespacesAndNewlines)
                        newList.contentControversal = nil
                        newList.listStringType = .koreanCharcter  //여기 입력이 잘못되어 있어서 매우 긴 디버깅 시간이 걸림 2017. 5. 9.
                        newList.number = getKoreanCharacterOrLetterInListSelection(header: listDictionary.key).koreanCharacterAndLetterInt
                        
                        newQuestion.lists.append(newList)
                    }
                    newQuestion.questionType = .Find
                }
                
                if queCutListSelWord != nil {
                    newQuestion.rawLists = queCutListSelWord!.trimmingCharacters(in: .whitespacesAndNewlines)
                    let listsDictionary = sliceString(regexPattern: "가\\.|나\\.|다\\.|라\\.|마\\.|바\\.|사\\.|아\\.|자\\.|차\\.|카\\.|타\\.|파\\.|하\\.", string: newQuestion.rawLists)
                    for listDictionary in listsDictionary {
                        var newList = Templet.List()
                        newList.specification = ""
                        newList.content = listDictionary.value.trimmingCharacters(in: .whitespacesAndNewlines)
                        newList.contentControversal = nil
                        newList.listStringType = .koreanCharcter
                        newList.number = getKoreanCharacterOrLetterInListSelection(header: listDictionary.key).koreanCharacterAndLetterInt
                        
                        newQuestion.lists.append(newList)
                        
                    }
                    newQuestion.questionType = .Find
                }
                
                
                
                
                
                
                guard let questionNumber = Int(questionStringDictionary.key.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) else {
                    fatalError("\(questionStringDictionary.key)에서 문제번호를 찾아낼 수 없음")
                }
                
                newQuestion.number = questionNumber
                
                
                guard let answer = testCategories[index].testSubjects[jndex].tests[kndex].answers.filter({$0.questionNumber == questionNumber}).first?.answer else {
                    fatalError("파싱한 문제에 맞는 전에 입력해두었던 문제의 정답이 없음")
                }
                newQuestion.answer = answer
                
                newQuestion.passage = passage
                newQuestion.content = contentRaw.trimmingCharacters(in: .whitespacesAndNewlines)
                newQuestion.contentSuffix = contentSuffix?.trimmingCharacters(in: .whitespacesAndNewlines)
                
                if newQuestion.content.contains("옳은 것은?") {
                    newQuestion.questionType = .Select
                    newQuestion.questionOX = .O
                } else if newQuestion.content.contains("옳지 않은 것은?") {
                    newQuestion.questionType = .Select
                    newQuestion.questionOX = .X
                }
                
                testCategories[index].testSubjects[jndex].tests[kndex].questions.append(newQuestion)
                // question 정보중에 추가할게 없는지 확인필요 2017. 5. 7.
            }
            
        }
    }
    
    
    
    
    // 파싱한 시험과 질문데이터를 소팅해주는 함수
    // 저장전에 불러주면 좋을 듯
    func sortTestAndQuestion() {
        
        
        // How do you sort an array of structs in swift
        // http://stackoverflow.com/questions/24781027/how-do-you-sort-an-array-of-structs-in-swift
        
        
        
        for (index,_) in self.testCategories.enumerated() {
            
            testCategories[index].testSubjects.sort{$0.subject < $1.subject}
            
            for (jndex,_) in testCategories[index].testSubjects.enumerated() {
                
                testCategories[index].testSubjects[jndex].tests.sort{$0.number < $1.number}
                
                for (kndex, _) in testCategories[index].testSubjects[jndex].tests.enumerated() {
                    
                    if testCategories[index].testSubjects[jndex].tests[kndex].number == 27 {
                        
                    }
                    
                    testCategories[index].testSubjects[jndex].tests[index].questions.sort{$0.number < $1.number}
                    
                    if testCategories[index].testSubjects[jndex].tests[kndex].number == 27 {
                        
                    }
                    
                    
                    for (lndex, _) in testCategories[index].testSubjects[jndex].tests[kndex].questions.enumerated() {
                        
                        testCategories[index].testSubjects[jndex].tests[kndex].questions[lndex].selections.sort{$0.number < $1.number}
                        testCategories[index].testSubjects[jndex].tests[kndex].questions[lndex].lists.sort{$0.number < $1.number}
                        
                    }
                }
            }
        }
        
    }
    
    
    
    func saveTests() -> Bool {
        
        sortTestAndQuestion()
        
        for testCategory in testCategories {
            
            let newTestCategory = TestCategory(testDatabase: self.testDatabase, category: testCategory.category, catHelper: testCategory.catHelper)
            newTestCategory.specification = testCategory.specification
            
            for testSubject in testCategory.testSubjects {
                let newTestSubject = TestSubject(testCategory: newTestCategory, subject: testSubject.subject)
                newTestSubject.specification = testSubject.specification
                
                for test in testSubject.tests {
                    
                    let newTest = Test(testSubject: newTestSubject, isPublished: true, number: test.number, numHelper: test.numHelper)
                    
                    for question in test.questions {
                        let newQuestion = Question(test: newTest, number: question.number, questionType: question.questionType, questionOX: question.questionOX, content: question.content, answer: question.answer)
                        
                        newQuestion.contentNote = question.contentNote
                        newQuestion.contentPrefix = question.contentPrefix
                        newQuestion.contentSuffix = question.contentSuffix
                        newQuestion.passage =  question.passage
                        newQuestion.specification =  question.specification
                        
                        newQuestion.raw =  question.raw
                        newQuestion.rawLists = question.rawLists
                        newQuestion.rawSelections =  question.rawSelections
                        
                        for selection in question.selections {
                            let newSelection = Selection(question: newQuestion, number: selection.number, content: selection.content)
                            newSelection.contentControversal = selection.contentControversal
                            newSelection.specification = selection.specification
                        }
                        for list in question.lists {
                            
                            var listCharacter : String
                            switch list.listStringType {
                            case .koreanCharcter:
                                listCharacter = list.number.koreanCharaterInt
                            case .koreanLetter:
                                listCharacter = list.number.koreanLetterInt
                            }
                            
                            let newList = List(question: newQuestion, content: list.content, selectString: listCharacter)
                            newList.contentControversal = list.contentControversal
                            newList.specification = list.specification
                        }
                        
                        // 이것을 안하니 .Find형식의 문제에서는 섞은 문제가 정답을 찾지 못하는 문제가 발생했다.
                        // 빼먹어도 문제없도록 자동실행 방안을 찾으면 좋겠다. 2017. 5. 9.
                        _ = newQuestion.findAnswer()
                    }
                }
            }
        }
        
        return true
    }

    
    
    
    
    
    
    
    
    // http://kandelvijaya.com/2016/10/11/swiftstringrange/
    // WHY STRING MANIPULATION IS ALIEN IN SWIFT3?
    
    
    // =-=변호사윤리 시험기출 \d회 \d{3}.+=-=
    
    // 문\s{0,}\d+.
    
    // 목록선택지
    // ㄱ\..+\n{0,}\s{0,}ㄴ\..+\n{0,}\s{0,}ㄷ\..+\n{0,}\s{0,}
    // ㄱ\..+\n{0,}\s{0,}ㄴ\..+\n{0,}\s{0,}ㄷ\..+\n{0,}\s{0,}ㄹ\..+\n{0,}\s{0,}
    // ㄱ\..+\n{0,}\s{0,}ㄴ\..+\n{0,}\s{0,}ㄷ\..+\n{0,}\s{0,}ㄹ\..+\n{0,}\s{0,}ㅁ\..+\n{0,}\s{0,}
    // ㄱ\..+\n{0,}\s{0,}ㄴ\..+\n{0,}\s{0,}ㄷ\..+\n{0,}\s{0,}ㄹ\..+\n{0,}\s{0,}ㅁ\..+\n{0,}\s{0,}ㅂ\..+\n{0,}\s{0,}
    // ㄱ\..+\n{0,}\s{0,}ㄴ\..+\n{0,}\s{0,}ㄷ\..+\n{0,}\s{0,}ㄹ\..+\n{0,}\s{0,}ㅁ\..+\n{0,}\s{0,}ㅂ\..+\n{0,}\s{0,}ㅅ\..+\n{0,}\s{0,}
    // =>
    // ((ㄱ|ㄴ|ㄷ|ㄹ|ㅁ|ㅂ|ㅅ|ㅇ|ㅈ|ㅊ|ㅋ|ㅌ|ㅍ|ㅎ)(\..+\n{0,}\s{0,})){1,14}
    
    // 가\..+\n{0,}\s{0,}나\..+\n{0,}\s{0,}다\..+\n{0,}\s{0,}
    // 가\..+\n{0,}\s{0,}나\..+\n{0,}\s{0,}다\..+\n{0,}\s{0,}라\..+\n{0,}\s{0,}
    // 가\..+\n{0,}\s{0,}나\..+\n{0,}\s{0,}다\..+\n{0,}\s{0,}라\..+\n{0,}\s{0,}마\..+\n{0,}\s{0,}
    // 가\..+\n{0,}\s{0,}나\..+\n{0,}\s{0,}다\..+\n{0,}\s{0,}라\..+\n{0,}\s{0,}마\..+\n{0,}\s{0,}바\..+\n{0,}\s{0,}
    // 가\..+\n{0,}\s{0,}나\..+\n{0,}\s{0,}다\..+\n{0,}\s{0,}라\..+\n{0,}\s{0,}마\..+\n{0,}\s{0,}바\..+\n{0,}\s{0,}사\..+\n{0,}\s{0,}
    // =>
    // (가(\..+\n{0,}\s{0,}))((나|다|라|마|바|사|아|자|차|카|타|파|하)(\..+\n{0,}\s{0,})){1,14}
    
    // ①.+\n{0,}\s{0,}②.+\n{0,}\s{0,}③.+\n{0,}\s{0,}④.+
    // =>
    // (①|②|③|④|⑤|⑥|⑦|⑧|⑨|⑩)(.+\n){1,9}
    // (①|②|③|④|⑤|⑥|⑦|⑧|⑨|⑩)(.+\n{0,}){1,9}
    
    // NSRegularExpression Tutorial: Getting Started
    // https://www.raywenderlich.com/86205/nsregularexpression-swift-tutorial
    // https://regexone.com
    
    // https://www.raywenderlich.com/86205/nsregularexpression-swift-tutorial
    // NSRegularExpression Tutorial: Getting Started
    
    // 시험문제 String에서 시험들 별로 String을 나누는 함수
    // pattern - testString - Patter - String 순
    // pattern에서 나오는 첫번째 숫자가 시험의 번호가 됨
    
    func sliceString(regexPattern : String, string : String) -> [String : String] {
        _headerAndResidualStrings = [:]  // 전역변수이므로 초기화가 매우 중요, 리컬시브 함수에서 파라미터를 포인터로 전달하는 방법은 없을까? 예가 구조체라서 불가능할려나 2017. 5. 7.
        return _sliceString(regexPattern : regexPattern, residualString : string, headerUn : nil)
    }
    

    
    private func _sliceString(regexPattern : String, residualString : String, headerUn : String?) -> [String : String] {
        let headerRangeUn = residualString.range(of: regexPattern, options: .regularExpression)
        // 패턴을 못찾았을 경우 else구문 실행하여 종료
        // 1. 패턴이 없는데 첫번째 루프 -> 치명적 에러
        // 2. 패턴이 없는데 첫번째 루프가 아님 -> 파싱이 완료될 때가 되었음
        guard let headerRange = headerRangeUn else
        {
            // 1. 패턴을 못찼잤는데 첫번재 루프라면 입력이 이상한 것임, 이대는 에러 메세지 출력 후 종료
            guard let header = headerUn else {
                fatalError("이상한 입력으로 인하여 시험 파싱을 진행할 수 없음")
            }
            // 2. 패턴을못찼았는데 첫번째 루프가 아님, 이는 모든 작업이 완료된 것임, 따라서 잔여 스트링을 저장하고 종료함
            //    이 때 사용하는 헤더는 함수에서 입력받은 헤더 즉 전 루프에서 찾았던 헤더의 정보임
            //// newTest 초기화에 대해서 고민해봐야 함 (-) 2017. 5. 5.
            // let testString = residualString
            // let newTest = Test(testDB : TestDB(), isPublished: true, category: testCategory, subject: testSubject, number: getTestNumber(testHeader: testHeader), numHelper: 2017)
            // newTest.specification = testHeader
            // newTest.raw = testString
            // 시험들.append(newTest)
            //// newTest를 이 함수 안에서 초기화 하는 것 보다는 밖에서 나가서 할 수 있도록 수정, 이를 위해 Templet이라는 구조체를 만듬 2017. 5. 7.
            self._headerAndResidualStrings[header] = residualString
            return _headerAndResidualStrings
        }
        
        var _header = headerUn
        var _residualString = residualString
        
        //첫번째 루프가 아님
        if _header != nil {  //이 조건식이 꼭 필요한가? 구조를 좀더 다시 생각해보는게 좋을 듯 2017. 5. 3.
             let result = _residualString.substring(with: _residualString.startIndex..<headerRange.lowerBound)
            // let newTest = Test(testDB : TestDB(), isPublished: true, category: testCategory, subject: testSubject, number: getTestNumber(testHeader: _testHeader!), numHelper: 2017)
            // newTest.specification = _testHeader!
            // newTest.raw = testString
            // 시험들.append(newTest)
            
            self._headerAndResidualStrings[_header!] = result
        } else {
        }
        
        _header = _residualString.substring(with: headerRange) // 이는 절대로 nil이 될 수 없다. 왜냐하면 위에서 이미 headerRange을 체크하였기 때문이다. headerRange가 nil이 아니라는 것은 _residualString에 결과가 있다는 의미이다
        _residualString = _residualString.substring(with: headerRange.upperBound..<_residualString.endIndex)
        
        return _sliceString(regexPattern: regexPattern, residualString: _residualString, headerUn: _header)
    }
    

    
    
    
    
    
    
    
    
    // func sliceTestString(regexPattern : String, string : String) 보조함수
    // 문자에서 첫번째 숫자만 추출해서 가져옴, 향후 정밀하게 변경하거나, 오버라이딩으로 사용하도록 수정 필요 (+) 2017. 5. 3.
    func getTestNumber(testHeader: String) -> Int {
        // 일단 첫번째 것만 반환받아도 되니 간단히 넘어가는데 뒤에 연도를 가져오려면 regex를 어떻게 짜야 하는지 고민해야함 (+) 2017. 5. 3.
        
        
        // Swift How to get integer from string and convert it into integer
        // http://stackoverflow.com/questions/30342744/swift-how-to-get-integer-from-string-and-convert-it-into-integer
        // guard let testNumber = Int(test.key.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) else {
        //     fatalError("법조윤리 정답 파싱 error")
        // }
        
        //필요하면 향후 헬퍼도 넣을 수 잇는 구문을 추가하면 될듯 2017. 5. 7. (+)
        
        
        
        let testNumberRange = testHeader.range(of: "\\d회", options: .regularExpression)
        guard let testNumberRangeWrapped = testNumberRange else {
            fatalError("\(answerFilename) 파일 안의 시험정보 \(testNumberRange) 안에는 시험회차정보가 없음")
        }
        
        let testNumberString = testHeader.substring(with: testNumberRangeWrapped)
        guard let testNumber = Int(testNumberString.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) else {
            fatalError("\(answerFilename)에서 문제회차정보를 찾을 수 없음")
        }
        
        return testNumber
    }
    
    
    
    
    
    
    
    func getKoreanCharacterOrLetterInListSelection(header: String) -> String {
        let rangeUn = header.range(of: "ㄱ|ㄴ|ㄷ|ㄹ|ㅁ|ㅂ|ㅅ|ㅇ|ㅈ|ㅊ|ㅋ|ㅌ|ㅍ|ㅎ|가|나|다|라|마|바|사|아|자|차|카|타|파|하", options: .regularExpression)
        guard let range = rangeUn else {
            fatalError("목록선택지안의 문자를 해석할 수 없음")
        }
        return header.substring(with: range)
    }
    
    
    
    
    
    func checkPath(path : URL?)  -> URL {
        guard let answerPathUnwrraped = path else {
            fatalError("\(path)가 존재하지 않음")
        }
        let fileManager = FileManager()
        if !fileManager.fileExists(atPath: answerPathUnwrraped.path) {
            fatalError("\(path)에 파일이 존재하지 않음")
        }
        return answerPathUnwrraped
    }
    
    
    
    
    
    func getText(path : URL) -> String {
        var text : String?
        do {
            text = try String(contentsOf: path, encoding: String.Encoding.utf8)
        } catch {
            fatalError("\(path) 텍스트 파일에서 문자열 가져오기 실패하였음, 적절한 텍스트파일이 아님")
        }
        guard let textWrapped = text else {
            fatalError("\(path) 텍스트 파일에서 문자열 가져오기 실패하였음, 문자열이 아님")
        }
        return textWrapped
    }
    
}


// http://stackoverflow.com/questions/27880650/swift-extract-regex-matches
// Swift extract regex matches
// 2017. 5. 10. 공부를 해야, 아주 훌륭한 공부예제일 것 (+) 지금은 잘 모르는 구문이지만..

extension String {
    func matchingStrings(regex: String) -> [[String]] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return [] }
        let nsString = self as NSString
        let results  = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
        return results.map { result in
            (0..<result.numberOfRanges).map { result.rangeAt($0).location != NSNotFound
                ? nsString.substring(with: result.rangeAt($0))
                : ""
            }
        }
    }
}
