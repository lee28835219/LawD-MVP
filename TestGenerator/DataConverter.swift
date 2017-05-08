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
    var log : String = "Data Converter Log 시작 \(Date().hhmmss)\n"
    
    var testDB : TestDB
    
    var tests : [Templet.Test] = []
    
    var answerFilename : String
    var questionFilename : String
    let answerPath : URL?
    let questionPath : URL?
    
    let testCategory : String
    
    private var _headerAndResidualStrings : [String : String] = [:]
    
    
    
    
    
    
    init(testDB : TestDB, testCategory : String, answerFilename: String, questionFilename : String) {
        
        self.testDB = testDB
        
        self.testCategory = testCategory
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
    
    
    
    
    
    
    // json 파일에 있는 시험과 정답정보를 가져오는 매우 중요한 함수
    func parseAnswerAndTestFromJsonFormat(testSeperator: String) {
        let path = checkPath(path: answerPath)
        var testParsedCounter = 0
        var answerParsedCounter = 0
        
        // 정답을 파싱
        do {
            if let path = self.answerPath {
                let data = try Data(contentsOf: path)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let obj = json as? [String:Any] {
                    
                    // 시험 객체 Array에 대한 파싱
                    // test.key : test.value = queData = [["문제" : 문제번호], ["정답" : 정답번호]]
                    // test.key => 모든 문제정보를 여기에다가 넣어서 받으면됨
                    for test in obj {
                        
                        // test.key 안에서 시험번호정보를 빼내는 구문,
                        // 시험을 생성하는 구문이므로 매우중요하며,
                        // 에러체크를 빡시게 해야 하는데 혹시 새는 부분이 있는지 나중에 확인필요함 (+) 2017. 5. 7.
                        guard let _ = test.key.range(of: testSeperator, options: .regularExpression) else {
                            fatalError("\(answerFilename)은 \(testSeperator) 형삭의 testSeperator를 갖지 않으므로 진행할 수 없음")
                        }
                        
                        let testNumber = getTestNumber(testHeader: test.key)
                        
                        
                        
                        // 새로운 시험을 생성
                        // 아직 정확한 파싱이 되지 않았으므로 testDB입력은 nil로 둠,
                        
                        // 모든 입력이 정확하면 나중에 직접 testDB에 추가해야함(context개념)
                        // let newTest = Test(testDB: nil, isPublished: true, category: self.testCategory, subject: self.testSubject, number: testNumber)
                        // 이건 의미가 없는 듯하다, 데이터를 더 정확하게 관리하기위해서 무엇보다 초기화 단계에서는 필요한 입력을 모두 확인한뒤 이상 없으면 Test객체를 생성해서 testDB에 마지막으로 저장하자
                        
                        // 문제해결을 위해 초기화 필요없고 간단하게 사용가능한 Templet를 만들어서 사용할 것임
                        // 모두 정의되면 이를 test단위로 save할 수 있도록 할 것임
                        var newTest = Templet.Test()
                        newTest.category = self.testCategory
                        newTest.number = testNumber
                        newTest.raw = test.key
                        
                        // 문제의 정보를 빼내기 시작
                        if let queData = test.value as? [[String:Any]] {        // [["문제" : 문제번호], ["정답" : 정답번호]]
                            // 시험 객체 중에 문제와 정답에 대한 정보 Array에 대한 파싱
                            for answerDict in queData {                         //  ["문제" : 문제번호], ["정답" : 정답번호]
                                var newAnswer = Templet.Answer()
                                if let queNo = answerDict["문번"] as? Int {
                                    if let ans = answerDict["정답"] as? Int {
                                        newAnswer.questionNumber = queNo
                                        newAnswer.answer = ans
                                        // 시험에 문제번호와 정답을 입력
                                        newTest.answers.append(newAnswer)
                                        answerParsedCounter = answerParsedCounter + 1
                                    }
                                }
                            }
                        }
                        self.tests.append(newTest)
                        testParsedCounter = testParsedCounter + 1
                    }
                }
            }
        } catch {
            fatalError("법조윤리 정답 파싱 error")
        }
        
        log = log + "  \(Date().hhmmss) : \(path.path) 정답 입력 완료\n"
        log = log + "  \(Date().hhmmss) : \(testParsedCounter)개의 시험에서 총 \(answerParsedCounter)개의 문제를 찾아서 작업함\n"
    }
    
    
    
    
    
    
    
    
    
    
    // 텍스트 파일에서 문제의 거의 모든 정보를 가져오는 매우 중요한 함수
    func parseQustionsFromTextFile(testSeperator: String, questionSeperator: String, contentSuffixSeperator: String? = nil, selectionSeperator: String, numberOfSelections: Int?) {
        
        // path를 확인하고
        let path = checkPath(path: questionPath)
        
        
        // path의 텍스트를 가져와서
        let wholeTestString = getText(path: path)
        
        
        // 시험별로 쪼개고
        let testStrings = sliceString(regexPattern: testSeperator, string: wholeTestString)
        log = log + "  \(Date().hhmmss) : \(path.path) 텍스트를 \(testStrings.count)개의 시험으로 나누는데 성공\n"
        
        
        
        for testString in testStrings {
        
            
            // 문제별로 쪼개었음
            let questionStrings = sliceString(regexPattern: questionSeperator, string: testString.value)
            log = log + "  \(Date().hhmmss) : \(testString.key) 시험을 \(questionStrings.count)개 문제로 나누는데 성공\n"
            
            
            
            
            for questionStringDictionary in questionStrings {
                
                
                
                var questionString = questionStringDictionary.value
                var newQuestion = Templet.Question(specification: "", number: 0, subjectDetails: [], questionType: QuestionType.Unknown, questionOX: QuestionOX.Unknown, content: questionString, contentControversal: nil, contentPrefix: nil, contentNote: nil, passage: nil, contentSuffix: nil, answer: 1, raw: "", rawSelections: "", rawLists: "", selections: [], lists: [])
                
                
                // 문제텍스트 중에 선택지는 항상 잇어야 하므로 선택지가 잇는지를 확인하고
                // 특히 이는 꼭있어야 되니 없으면 치명적 에러
                // 이 후 선택지텍스트를 찾아냄
                let selectionRange = questionString.range(of: selectionSeperator, options: .regularExpression)
                guard let selectionRangeWrapped = selectionRange else {
                    fatalError("\(testString.key)시험의 \(questionStringDictionary.key)문제 파싱 중 문제의 선택지를 찾을 수 없음")
                }
                let selectionStrings = questionString.substring(with: selectionRangeWrapped)
                
                
                
                // 선택지를 파싱함
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
                    if selectionStringSliced.count != numberOfSelectionsWrapped {
                        fatalError("\(testString.key) - \(questionStringDictionary.key) 에는 선택지가 \(numberOfSelectionsWrapped)개가 아님")
                    }
                }
                
                // 문제텍스트에서 선택지 텍스트를 제거함, 이게 문제의 content가 될 수 있음
                // 만약 선택지 뒤에 잡다한 텍스트가 잇다면 어그러질 것 그치만 그런 형식의 텍스트가 입력되는 일은 없겠지?
                // 문제를 정확하게 자르지 못하지 않는한 그런일 없다.
                questionString = questionString.substring(with: questionString.startIndex..<selectionRangeWrapped.lowerBound)
                
                
                
                // 각각 가나다 형태와 ㄱㄴㄷ 목록이 있는지 확인해서 문제텍스트를 잘라 가지고 있음
                // queCutListSelWord와 queCutListSelLetter
                var queCutListSelWord : String? = nil
                let queCutListSelWordRange = questionString.range(of: "(가(\\..+\\n{0,}\\s{0,}))((나|다|라|마|바|사|아|자|차|카|타|파|하)(\\..+\\n{0,}\\s{0,})){1,14}", options: .regularExpression)
                if queCutListSelWordRange != nil {
                    queCutListSelWord = questionString.substring(with: queCutListSelWordRange!)
                    questionString = questionString.substring(with: questionString.startIndex..<queCutListSelWordRange!.lowerBound)
                }
                
                var queCutListSelLetter : String? = nil
                let queCutListSelLetterRange = questionString.range(of: "((ㄱ|ㄴ|ㄷ|ㄹ|ㅁ|ㅂ|ㅅ|ㅇ|ㅈ|ㅊ|ㅋ|ㅌ|ㅍ|ㅎ)(\\..+\\n{0,}\\s{0,})){1,14}", options: .regularExpression)
                if queCutListSelLetterRange != nil {
                    queCutListSelLetter = questionString.substring(with: queCutListSelLetterRange!)
                    questionString = questionString.substring(with: questionString.startIndex..<queCutListSelLetterRange!.lowerBound)
                }
                
                // 가나다와 ㄱㄴㄷ이 둘다 존재할 수는 없을것
                if queCutListSelWord != nil && queCutListSelLetter != nil {
                    fatalError("문제 파싱중에 목록선택지의 구조가 이상하게 파싱되었음")
                }
                
                
                //
                if queCutListSelLetter != nil {
                    newQuestion.rawLists = queCutListSelLetter!.trimmingCharacters(in: .whitespacesAndNewlines)
                    let listsDictionary = sliceString(regexPattern: "ㄱ\\.|ㄴ\\.|ㄷ\\.|ㄹ\\.|ㅁ\\.|ㅂ\\.|ㅅ\\.|ㅇ\\.|ㅈ\\.|ㅊ\\.|ㅋ\\.|ㅌ\\.|ㅍ\\.|ㅎ\\.", string: newQuestion.rawLists)
                    for listDictionary in listsDictionary {
                        var newList = Templet.List()
                        newList.specification = ""
                        newList.content = listDictionary.value.trimmingCharacters(in: .whitespacesAndNewlines)
                        newList.contentControversal = nil
                        newList.listStringType = .koreanLetter
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
                
                
                
                
                // 필터는 포인터가 아니라 갚을 반환해줘서 사용이 안된다. 다른 방법은 없느가? 2017. 5. 7.
                var currentIndex = -1
                for (index,test) in self.tests.enumerated() {
                    if test.number == getTestNumber(testHeader: testString.key) {
                        currentIndex = index
                        break
                    }
                }
                
                if currentIndex == -1 {
                    fatalError("\(self.questionFilename)에서 시험과 정답파일에서 찾은 시험을 찾을 수 없음")
                }
                
                
                guard let questionNumber = Int(questionStringDictionary.key.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) else {
                    fatalError("\(questionStringDictionary.key)에서 문제번호를 찾아낼 수 없음")
                }
                
                newQuestion.number = questionNumber
                
                
                guard let answer = tests[currentIndex].answers.filter({$0.questionNumber == questionNumber}).first?.answer else {
                    fatalError("")
                }
                
                newQuestion.answer = answer
                newQuestion.content = questionString.trimmingCharacters(in: .whitespacesAndNewlines)
                
                if newQuestion.content.contains("옳은 것은?") {
                    newQuestion.questionType = .Select
                    newQuestion.questionOX = .O
                } else if newQuestion.content.contains("옳지 않은 것은?") {
                    newQuestion.questionType = .Select
                    newQuestion.questionOX = .X
                }
                
                tests[currentIndex].questions.append(newQuestion)
                // question 정보중에 추가할게 없는지 확인필요 2017. 5. 7.
            }
            
        }
    }
    
    
    
    
    
    // 파싱한 시험과 질문데이터를 소팅해주는 함수
    // 저장전에 불러주면 좋을 듯
    func sortTestAndQuestion() {
        
        // How do you sort an array of structs in swift
        // http://stackoverflow.com/questions/24781027/how-do-you-sort-an-array-of-structs-in-swift
        
        tests.sort{$0.number < $1.number}
        
        for (index, test) in tests.enumerated() {
            tests[index].questions.sort{$0.number < $1.number}
            
            for (jdex, _) in test.questions.enumerated() {
                tests[index].questions[jdex].selections.sort{$0.number < $1.number}
                tests[index].questions[jdex].lists.sort{$0.number < $1.number}
            }
        }
        
    }
    
    
    func saveTests() -> Bool {
        
        sortTestAndQuestion()
        
        for test in tests {
            let newTest = Test(testDB: testDB, isPublished: true, category: test.category, catHelper: test.catHelper, subject: test.subject, number: test.number, numHelper: test.numHelper)
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
