//
//  DC변호사시험민사법.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 7..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Cocoa

class DC변호사시험민사법 : DataConverter {
    
    //    Read JSON file with Swift 3
    //    http://stackoverflow.com/questions/40438784/read-json-file-with-swift-3
    
    init?(_ testDatabase : TestDatabase) {
        
        super.init(testDatabase: testDatabase,
                   answerFilename: "변호사시험=1~6회-정답.json",
                   questionFilename: "변호사시험=1~6회-문제.txt"
        )
        
        
        let resultTuple = extractTestAndAnswerJson()
        setTestAndAnswerTemplet(resultTuple)
        
        
        let testSeperator = "=(변호사시험)=(.+)=(\\d+)회="
        
        parseQustionsFromTextFile(testSeperator: testSeperator
            // "문\\s{0,}\\d+."의 형식으로 레겍스를 입력할 경우 .항목이 모든 문자를 가져오는 것으로 해석되버리므로 여기서는 꼭 \.표현으로 입력해주어야 함 2017. 5. 11.
            , questionSeperator: "문\\s{0,}\\d+\\."
            , selectionSeperator: "(①|②|③|④|⑤|⑥|⑦|⑧|⑨|⑩)(.+\\n{0,}){1,9}"
            , numberOfSelections: 5
        )
        
        _ = saveTests()
        
        
        log = closeLog(log: log, file: "\(#file)")
//            log + "Data Converter Log 종료 \(Date().HHmmSS)"
        print(log)
        
        
    }
    
//}
//    
//    
//    
//    
//    override func saveTests() -> Bool {
//        
//        sortTestAndQuestion()
//        
//        let newTestCategory = TestCategory(testDatabase: testDatabase, category: self.testCategory, catHelper: nil)
//        let newTestSubject = TestSubject(testCategory: newTestCategory, subject: self.subject)
//        
//        for test in tests {
//            
//            let newTest = Test(testSubject: newTestSubject, isPublished: true, number: test.number, numHelper: test.numHelper)
//            
//            for question in test.questions {
//                let newQuestion = Question(test: newTest, number: question.number, questionType: question.questionType, questionOX: question.questionOX, content: question.content, answer: question.answer)
//                
//                newQuestion.contentNote = question.contentNote
//                newQuestion.contentPrefix = question.contentPrefix
//                newQuestion.contentSuffix = question.contentSuffix
//                newQuestion.passage =  question.passage
//                newQuestion.specification =  question.specification
//                
//                newQuestion.raw =  question.raw
//                newQuestion.rawLists = question.rawLists
//                newQuestion.rawSelections =  question.rawSelections
//                
//                for selection in question.selections {
//                    let newSelection = Selection(question: newQuestion, number: selection.number, content: selection.content)
//                    newSelection.contentControversal = selection.contentControversal
//                    newSelection.specification = selection.specification
//                }
//                for list in question.lists {
//                    
//                    var listCharacter : String
//                    switch list.listStringType {
//                    case .koreanCharcter:
//                        listCharacter = list.number.koreanCharaterInt
//                    case .koreanLetter:
//                        listCharacter = list.number.koreanLetterInt
//                    }
//                    
//                    let newList = List(question: newQuestion, content: list.content, selectString: listCharacter)
//                    newList.contentControversal = list.contentControversal
//                    newList.specification = list.specification
//                }
//                
//                // 이것을 안하니 .Find형식의 문제에서는 섞은 문제가 정답을 찾지 못하는 문제가 발생했다.
//                // 빼먹어도 문제없도록 자동실행 방안을 찾으면 좋겠다. 2017. 5. 9.
//                _ = newQuestion.findAnswer()
//            }
//        }
//        return true
//    }
//    
//    // json 파일에 있는 시험과 정답정보를 가져오는 매우 중요한 함수
//    func parseAnswerAndTestFromJsonFormat(testSeperator: String) {
//        let path = checkPath(path: answerPath)
//        var testParsedCounter = 0
//        var answerParsedCounter = 0
//        
//        // 정답을 파싱
//        do {
//            if let path = self.answerPath {
//                let data = try Data(contentsOf: path)
//                let json = try JSONSerialization.jsonObject(with: data, options: [])
//                if let obj = json as? [String:Any] {
//                    
//                    // 시험 객체 Array에 대한 파싱
//                    // test.key : test.value = queData = [["문제" : 문제번호], ["정답" : 정답번호]]
//                    // test.key => 모든 문제정보를 여기에다가 넣어서 받으면됨
//                    for test in obj {
//                        
//                        // test.key 안에서 시험번호정보를 빼내는 구문,
//                        // 시험을 생성하는 구문이므로 매우중요하며,
//                        // 에러체크를 빡시게 해야 하는데 혹시 새는 부분이 있는지 나중에 확인필요함 (+) 2017. 5. 7.
//                        guard let _ = test.key.range(of: testSeperator, options: .regularExpression) else {
//                            fatalError("\(answerFilename)은 \(testSeperator) 형삭의 testSeperator를 갖지 않으므로 진행할 수 없음")
//                        }
//                        
//                        let testNumber = getTestNumber(testHeader: test.key)
//                        
//                        
//                        
//                        // 새로운 시험을 생성
//                        // 아직 정확한 파싱이 되지 않았으므로 testDB입력은 nil로 둠,
//                        
//                        // 모든 입력이 정확하면 나중에 직접 testDB에 추가해야함(context개념)
//                        // let newTest = Test(testDB: nil, isPublished: true, category: self.testCategory, subject: self.testSubject, number: testNumber)
//                        // 이건 의미가 없는 듯하다, 데이터를 더 정확하게 관리하기위해서 무엇보다 초기화 단계에서는 필요한 입력을 모두 확인한뒤 이상 없으면 Test객체를 생성해서 testDB에 마지막으로 저장하자
//                        
//                        // 문제해결을 위해 초기화 필요없고 간단하게 사용가능한 Templet를 만들어서 사용할 것임
//                        // 모두 정의되면 이를 test단위로 save할 수 있도록 할 것임
//                        var newTest = Templet.Test()
//                        newTest.number = testNumber
//                        newTest.raw = test.key
//                        
//                        // 문제의 정보를 빼내기 시작
//                        if let queData = test.value as? [[String:Any]] {        // [["문제" : 문제번호], ["정답" : 정답번호]]
//                            // 시험 객체 중에 문제와 정답에 대한 정보 Array에 대한 파싱
//                            for answerDict in queData {                         //  ["문제" : 문제번호], ["정답" : 정답번호]
//                                var newAnswer = Templet.Answer()
//                                if let queNo = answerDict["문번"] as? Int {
//                                    if let ans = answerDict["정답"] as? Int {
//                                        newAnswer.questionNumber = queNo
//                                        newAnswer.answer = ans
//                                        // 시험에 문제번호와 정답을 입력
//                                        newTest.answers.append(newAnswer)
//                                        answerParsedCounter = answerParsedCounter + 1
//                                    }
//                                }
//                            }
//                        }
//                        self.tests.append(newTest)
//                        testParsedCounter = testParsedCounter + 1
//                    }
//                }
//            }
//        } catch {
//            fatalError("법조윤리 정답 파싱 error")
//        }
//        
//        log = log + "  \(Date().HHmmss) : \(path.path) 정답 입력 완료\n"
//        log = log + "  \(Date().HHmmss) : \(testParsedCounter)개의 시험에서 총 \(answerParsedCounter)개의 문제를 찾아서 작업함\n"
//    }
//    
//    // 텍스트 파일에서 문제의 거의 모든 정보를 가져오는 매우 중요한 함수
//    override func parseQustionsFromTextFile(testSeperator: String, questionSeperator: String, contentSuffixSeperator: String? = nil, selectionSeperator: String, numberOfSelections: Int?) {
//        
//        // path를 확인하고
//        let path = checkPath(path: questionPath)
//        
//        
//        // path의 텍스트를 가져와서
//        let wholeTestString = getText(path: path)
//        
//        
//        // 시험별로 쪼개고
//        let testStrings = sliceString(regexPattern: testSeperator, string: wholeTestString)
//        log = log + "  \(Date().HHmmss) : \(path.path) 텍스트를 \(testStrings.count)개의 시험으로 나누는데 성공\n"
//        
//        
//        
//        for testString in testStrings {
//            
//            
//            // 문제별로 쪼개었음
//            let questionStrings = sliceString(regexPattern: questionSeperator, string: testString.value)
//            log = log + "  \(Date().HHmmss) : \(testString.key) 시험을 \(questionStrings.count)개 문제로 나누는데 성공\n"
//            
//            
//            
//            
//            for questionStringDictionary in questionStrings {
//                
//                
//                
//                var questionString = questionStringDictionary.value
//                var newQuestion = Templet.Question(specification: "", number: 0, subjectDetails: [], questionType: QuestionType.Unknown, questionOX: QuestionOX.Unknown, content: questionString, contentControversal: nil, contentPrefix: nil, contentNote: nil, passage: nil, contentSuffix: nil, answer: 1, raw: "", rawSelections: "", rawLists: "", selections: [], lists: [])
//                
//                
//                // 문제텍스트 중에 선택지는 항상 잇어야 하므로 선택지가 잇는지를 확인하고
//                // 특히 이는 꼭있어야 되니 없으면 치명적 에러
//                // 이 후 선택지텍스트를 찾아냄
//                let selectionRange = questionString.range(of: selectionSeperator, options: .regularExpression)
//                guard let selectionRangeWrapped = selectionRange else {
//                    fatalError("\(testString.key)시험의 \(questionStringDictionary.key)문제 파싱 중 문제의 선택지를 찾을 수 없음")
//                }
//                let selectionStrings = questionString.substring(with: selectionRangeWrapped)
//                
//                
//                
//                // 선택지를 파싱함
//                // que.rawSelections = queCutSelection.trimmingCharacters(in: .whitespacesAndNewlines)
//                
//                
//                let selectionStringSliced = sliceString(regexPattern: "①|②|③|④|⑤|⑥|⑦|⑧|⑨|⑩", string: selectionStrings)
//                for selection in selectionStringSliced {
//                    
//                    var newSelection = Templet.Selection()
//                    newSelection.content = selection.value.trimmingCharacters(in: .whitespacesAndNewlines)
//                    newSelection.contentControversal = nil
//                    newSelection.number = selection.key.roundInt
//                    
//                    newQuestion.selections.append(newSelection)
//                    
//                }
//                
//                
//                // 선택지가 주어진 갯수와 맞는지 체크하는 함수, 입력이 nil이면 하지않음
//                if let numberOfSelectionsWrapped = numberOfSelections {
//                    if selectionStringSliced.count != numberOfSelectionsWrapped {
//                        fatalError("\(testString.key) - \(questionStringDictionary.key) 에는 선택지가 \(numberOfSelectionsWrapped)개가 아님")
//                    }
//                }
//                
//                // 문제텍스트에서 선택지 텍스트를 제거함, 이게 문제의 content가 될 수 있음
//                // 만약 선택지 뒤에 잡다한 텍스트가 잇다면 어그러질 것 그치만 그런 형식의 텍스트가 입력되는 일은 없겠지?
//                // 문제를 정확하게 자르지 못하지 않는한 그런일 없다.
//                questionString = questionString.substring(with: questionString.startIndex..<selectionRangeWrapped.lowerBound)
//                
//                
//                
//                // 각각 가나다 형태와 ㄱㄴㄷ 목록이 있는지 확인해서 문제텍스트를 잘라 가지고 있음
//                // queCutListSelWord와 queCutListSelLetter
//                var queCutListSelWord : String? = nil
//                let queCutListSelWordRange = questionString.range(of: "(가(\\..+\\n{0,}\\s{0,}))((나|다|라|마|바|사|아|자|차|카|타|파|하)(\\..+\\n{0,}\\s{0,})){1,14}", options: .regularExpression)
//                if queCutListSelWordRange != nil {
//                    queCutListSelWord = questionString.substring(with: queCutListSelWordRange!)
//                    questionString = questionString.substring(with: questionString.startIndex..<queCutListSelWordRange!.lowerBound)
//                }
//                
//                var queCutListSelLetter : String? = nil
//                let queCutListSelLetterRange = questionString.range(of: "((ㄱ|ㄴ|ㄷ|ㄹ|ㅁ|ㅂ|ㅅ|ㅇ|ㅈ|ㅊ|ㅋ|ㅌ|ㅍ|ㅎ)(\\..+\\n{0,}\\s{0,})){1,14}", options: .regularExpression)
//                if queCutListSelLetterRange != nil {
//                    queCutListSelLetter = questionString.substring(with: queCutListSelLetterRange!)
//                    questionString = questionString.substring(with: questionString.startIndex..<queCutListSelLetterRange!.lowerBound)
//                }
//                
//                // 가나다와 ㄱㄴㄷ이 둘다 존재할 수는 없을것
//                if queCutListSelWord != nil && queCutListSelLetter != nil {
//                    fatalError("문제 파싱중에 목록선택지의 구조가 이상하게 파싱되었음")
//                }
//                
//                
//                //
//                if queCutListSelLetter != nil {
//                    newQuestion.rawLists = queCutListSelLetter!.trimmingCharacters(in: .whitespacesAndNewlines)
//                    let listsDictionary = sliceString(regexPattern: "ㄱ\\.|ㄴ\\.|ㄷ\\.|ㄹ\\.|ㅁ\\.|ㅂ\\.|ㅅ\\.|ㅇ\\.|ㅈ\\.|ㅊ\\.|ㅋ\\.|ㅌ\\.|ㅍ\\.|ㅎ\\.", string: newQuestion.rawLists)
//                    for listDictionary in listsDictionary {
//                        var newList = Templet.List()
//                        newList.specification = ""
//                        newList.content = listDictionary.value.trimmingCharacters(in: .whitespacesAndNewlines)
//                        newList.contentControversal = nil
//                        newList.listStringType = .koreanCharcter  //여기 입력이 잘못되어 있어서 매우 긴 디버깅 시간이 걸림 2017. 5. 9.
//                        newList.number = getKoreanCharacterOrLetterInListSelection(header: listDictionary.key).koreanCharacterAndLetterInt
//                        
//                        newQuestion.lists.append(newList)
//                    }
//                    newQuestion.questionType = .Find
//                }
//                
//                if queCutListSelWord != nil {
//                    newQuestion.rawLists = queCutListSelWord!.trimmingCharacters(in: .whitespacesAndNewlines)
//                    let listsDictionary = sliceString(regexPattern: "가\\.|나\\.|다\\.|라\\.|마\\.|바\\.|사\\.|아\\.|자\\.|차\\.|카\\.|타\\.|파\\.|하\\.", string: newQuestion.rawLists)
//                    for listDictionary in listsDictionary {
//                        var newList = Templet.List()
//                        newList.specification = ""
//                        newList.content = listDictionary.value.trimmingCharacters(in: .whitespacesAndNewlines)
//                        newList.contentControversal = nil
//                        newList.listStringType = .koreanCharcter
//                        newList.number = getKoreanCharacterOrLetterInListSelection(header: listDictionary.key).koreanCharacterAndLetterInt
//                        
//                        newQuestion.lists.append(newList)
//                        
//                    }
//                    newQuestion.questionType = .Find
//                }
//                
//                
//                
//                
//                // 필터는 포인터가 아니라 갚을 반환해줘서 사용이 안된다. 다른 방법은 없느가? 2017. 5. 7.
//                var currentIndex = -1
//                for (index,test) in self.tests.enumerated() {
//                    if test.number == getTestNumber(testHeader: testString.key) {
//                        currentIndex = index
//                        break
//                    }
//                }
//                
//                if currentIndex == -1 {
//                    fatalError("\(self.questionFilename)에서 시험과 정답파일에서 찾은 시험을 찾을 수 없음")
//                }
//                
//                
//                guard let questionNumber = Int(questionStringDictionary.key.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) else {
//                    fatalError("\(questionStringDictionary.key)에서 문제번호를 찾아낼 수 없음")
//                }
//                
//                newQuestion.number = questionNumber
//                
//                
//                guard let answer = tests[currentIndex].answers.filter({$0.questionNumber == questionNumber}).first?.answer else {
//                    fatalError("")
//                }
//                
//                newQuestion.answer = answer
//                newQuestion.content = questionString.trimmingCharacters(in: .whitespacesAndNewlines)
//                
//                if newQuestion.content.contains("옳은 것은?") {
//                    newQuestion.questionType = .Select
//                    newQuestion.questionOX = .O
//                } else if newQuestion.content.contains("옳지 않은 것은?") {
//                    newQuestion.questionType = .Select
//                    newQuestion.questionOX = .X
//                }
//                
//                tests[currentIndex].questions.append(newQuestion)
//                // question 정보중에 추가할게 없는지 확인필요 2017. 5. 7.
//            }
//            
//        }
//    }
//    
//

}
