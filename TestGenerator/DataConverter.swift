//
//  DataConverter.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 1..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Cocoa

//How can I quickly and easily convert spreadsheet data to JSON? [closed]
//http://stackoverflow.com/questions/19187085/how-can-i-quickly-and-easily-convert-spreadsheet-data-to-json

//Read and write data from text file
//http://stackoverflow.com/questions/24097826/read-and-write-data-from-text-file
class DataConverter: NSObject {
    
    var answerFilename : String
    let answerPath : URL?
    var questionFilename : String
    let questionPath : URL?
    let testCategory : String
    let testSubject : String
    
    var 시험들 = [Test]()
    var 정답들 = [정답]()
    
    init(testCategory : String, testSubject : String, answerFilename: String, questionFilename : String) {
        self.testCategory = testCategory
        self.testSubject = testSubject
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
            self.answerPath = nil
            self.questionPath = nil
        }
    }
    
    func getText(path : URL?) -> String {
        var wholeStringUn : String?
        do {
            if let _path = path {
                //                print(path)
                wholeStringUn = try String(contentsOf: _path, encoding: String.Encoding.utf8)
            }
        } catch {
            fatalError("법조윤리 문제 파싱 error")
        }
        guard let wholeString = wholeStringUn else {
            fatalError("can't find test string")
        }
        return wholeString
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
    
    func sliceTestString(regexPattern : String, string : String) {
        _sliceTestString(regexPattern : regexPattern, residualString : string, headerUn : nil)
    }
    
    private func _sliceTestString(regexPattern : String, residualString : String, headerUn : String?) {
        let headerRangeUn = residualString.range(of: regexPattern, options: .regularExpression)
        // 패턴을 못찾았을 경우 else구문 실행하여 종료
        // 1. 패턴이 없는데 첫번째 루프 -> 치명적 에러
        // 2. 패턴이 없는데 첫번째 루프가 아님 -> 파싱이 완료될 때가 되었음
        guard let headerRange = headerRangeUn else
        {
            // 1. 패턴을 못찼잤는데 첫번재 루프라면 입력이 이상한 것임, 이대는 에러 메세지 출력 후 종료
            guard let testHeader = headerUn else {
                fatalError("이상한 입력으로 인하여 시험 파싱을 진행할 수 없음")
            }
            // 2. 패턴을못찼았는데 첫번째 루프가 아님, 이는 모든 작업이 완료된 것임, 따라서 잔여 스트링을 저장하고 종료함
            //    이 때 사용하는 헤더는 함수에서 입력받은 헤더 즉 전 루프에서 찾았던 헤더의 정보임
            let testString = residualString
        // newTest 초기화에 대해서 고민해봐야 함 (+) 2017. 5. 5.
            let newTest = Test(testDB : TestDB(), isPublished: true, category: testCategory, subject: testSubject, number: getTestNumber(testHeader: testHeader), numHelper: 2017)
            newTest.description = testHeader
            newTest.string = testString
            시험들.append(newTest)
            print("---시험 파싱완료")
            return
        }
        
        var _testHeader = headerUn
        var _residualString = residualString
        
        //첫번째 루프가 아님
        if _testHeader != nil {  //이 조건식이 꼭 필요한가? 구조를 좀더 다시 생각해보는게 좋을 듯 2017. 5. 3.
            let testString = _residualString.substring(with: _residualString.startIndex..<headerRange.lowerBound)
            let newTest = Test(testDB : TestDB(), isPublished: true, category: testCategory, subject: testSubject, number: getTestNumber(testHeader: _testHeader!), numHelper: 2017)
            newTest.description = _testHeader!
            newTest.string = testString
            시험들.append(newTest)
        } else {
            print("---시험파싱중")
        }
        
        _testHeader = _residualString.substring(with: headerRange) // 이는 절대로 nil이 될 수 없다. 왜냐하면 위에서 이미 headerRange을 체크하였기 때문이다. headerRange가 nil이 아니라는 것은 _residualString에 결과가 있다는 의미이다
        _residualString = _residualString.substring(with: headerRange.upperBound..<_residualString.endIndex)
        
        _sliceTestString(regexPattern: regexPattern, residualString: _residualString, headerUn: _testHeader)
    }
    
    // func sliceTestString(regexPattern : String, string : String) 보조함수
    // 문자에서 첫번째 숫자만 추출해서 가져옴, 향후 정밀하게 변경하거나, 오버라이딩으로 사용하도록 수정 필요 (+) 2017. 5. 3.
    func getTestNumber(testHeader: String) -> Int {
        // 일단 첫번째 것만 반환받아도 되니 간단히 넘어가는데 뒤에 연도를 가져오려면 regex를 어떻게 짜야 하는지 고민해야함 (+) 2017. 5. 3.
        guard let intTestIntRange = testHeader.range(of: "\\d+", options: .regularExpression) else {
            fatalError("번호를 파싱할 수 없음")
        }
        let stringToIntUn = Int(testHeader.substring(with: intTestIntRange))
        guard let stringToInt = stringToIntUn else {
            fatalError("번호를 파싱할 수 없음")
        }
        return stringToInt
    }
    
    func sliceQuestionString(regexPattern : String, residualString : String, test : Test, headerUn : String?) {
        let headerRangeUn = residualString.range(of: regexPattern, options: .regularExpression)
        // 패턴을 못찾았을 경우 else구문 실행하여 종료
        // 1. 패턴이 없는데 첫번째 루프 -> 치명적 에러
        // 2. 패턴이 없는데 첫번째 루프가 아님 -> 파싱이 완료될 때가 되었음
        guard let headerRange = headerRangeUn else
        {
            // 1. 패턴을 못찼잤는데 첫번재 루프라면 입력이 이상한 것임, 이대는 에러 메세지 출력 후 종료
            guard let header = headerUn else {
                fatalError("이상한 입력으로 인하여 문제 파싱을 진행할 수 없음")
            }
            // 2. 패턴을못찼았는데 첫번째 루프가 아님, 이는 모든 작업이 완료된 것임, 따라서 잔여 스트링을 저장하고 종료함
            //    이 때 사용하는 헤더는 함수에서 입력받은 헤더 즉 전 루프에서 찾았던 헤더의 정보임
            let questionString = residualString
            
            let newQuestion = Question(test: test,number: getTestNumber(testHeader: header), questionType: QuestionType.Select, questionOX: QuestionOX.X, content: "", answer: 0)
            newQuestion.string = questionString
            test.questions.append(newQuestion)
            print("---문제 파싱완료")
            return
        }
        
        var _testHeader = headerUn
        var _residualString = residualString
        
        //첫번째 루프가 아님
        if _testHeader != nil {  //이 조건식이 꼭 필요한가? 구조를 좀더 다시 생각해보는게 좋을 듯 2017. 5. 3.
            let questionString = _residualString.substring(with: _residualString.startIndex..<headerRange.lowerBound)
            let newQuestion = Question(test: test,number: getTestNumber(testHeader: _testHeader!),  questionType: QuestionType.Select, questionOX: QuestionOX.X, content: "", answer: 0)
            newQuestion.string = questionString
            test.questions.append(newQuestion)
        } else {
            print("---시험파싱중")
        }
        
        _testHeader = _residualString.substring(with: headerRange) // 이는 절대로 nil이 될 수 없다. 왜냐하면 위에서 이미 headerRange을 체크하였기 때문이다. headerRange가 nil이 아니라는 것은 _residualString에 결과가 있다는 의미이다
        _residualString = _residualString.substring(with: headerRange.upperBound..<_residualString.endIndex)
        
        sliceQuestionString(regexPattern: regexPattern, residualString: _residualString, test: test, headerUn: _testHeader)
    }
    
    func sliceSelectionString(regexPattern : String, residualString : String, question : Question, headerUn : String?) {
        let headerRangeUn = residualString.range(of: regexPattern, options: .regularExpression)
        
        guard let headerRange = headerRangeUn else
        {
            guard let header = headerUn else {
                fatalError("이상한 입력으로 인하여 선택지 파싱을 진행할 수 없음")
            }
            _ = Selection(question: question, selectNumber: header.roundInt, content: residualString.trimmingCharacters(in: .whitespacesAndNewlines))
            // 선택지 생성 시에 자동으로 문제에 append되므로 아래 명령 필요없음
            // question.selections.append(newSelection)
            print("---선택지 파싱완료")
            return
        }
        
        var _header = headerUn
        var _residualString = residualString
        
        if _header != nil {
            let selectionString = _residualString.substring(with: _residualString.startIndex..<headerRange.lowerBound)
            _ = Selection(question: question, selectNumber: _header!.roundInt, content: selectionString.trimmingCharacters(in: .whitespacesAndNewlines))
        } else {
            print("---선택지파싱중")
        }
        
        _header = _residualString.substring(with: headerRange)
        _residualString = _residualString.substring(with: headerRange.upperBound..<_residualString.endIndex)
        
        sliceSelectionString(regexPattern: regexPattern, residualString: _residualString, question: question, headerUn: _header)
    }
    
    func sliceListSelectionString(regexPattern : String, residualString : String, question : Question, headerUn : String?) {
        let headerRangeUn = residualString.range(of: regexPattern, options: .regularExpression)
        
        guard let headerRange = headerRangeUn else
        {
            guard let header = headerUn else {
                fatalError("이상한 입력으로 인하여 목록선택지 파싱을 진행할 수 없음")
            }
            _ = List(question: question, content: residualString.trimmingCharacters(in: .whitespacesAndNewlines), selectString: getKoreanCharacterOrLetterInListSelection(header: header))
//            _ = Selection(question: question, selectNumber: getKoreanCharacterOrLetterInListSelection(header: header).koreanCharacterAndLetterInt, content: residualString.trimmingCharacters(in: .whitespacesAndNewlines), selectString: getKoreanCharacterOrLetterInListSelection(header: header))
            print("---목록선택지 파싱완료")
            return
        }
        
        var _header = headerUn
        var _residualString = residualString
        
        if _header != nil {
            _ = getKoreanCharacterOrLetterInListSelection(header: _header!).koreanCharacterAndLetterInt
            let selectionString = _residualString.substring(with: _residualString.startIndex..<headerRange.lowerBound)
            _ = List(question: question, content: selectionString.trimmingCharacters(in: .whitespacesAndNewlines), selectString: getKoreanCharacterOrLetterInListSelection(header: _header!))
//            _ = Selection(question: question, selectNumber: selectNumber, content: selectionString.trimmingCharacters(in: .whitespacesAndNewlines), selectString: getKoreanCharacterOrLetterInListSelection(header: _header!))
        } else {
            print("---목록선택지파싱중")
        }
        
        _header = _residualString.substring(with: headerRange)
        _residualString = _residualString.substring(with: headerRange.upperBound..<_residualString.endIndex)
        
        sliceListSelectionString(regexPattern: regexPattern, residualString: _residualString, question: question, headerUn: _header)
    }
    
    func getKoreanCharacterOrLetterInListSelection(header: String) -> String {
        let rangeUn = header.range(of: "ㄱ|ㄴ|ㄷ|ㄹ|ㅁ|ㅂ|ㅅ|ㅇ|ㅈ|ㅊ|ㅋ|ㅌ|ㅍ|ㅎ|가|나|다|라|마|바|사|아|자|차|카|타|파|하", options: .regularExpression)
        guard let range = rangeUn else {
            fatalError("목록선택지안의 문자를 해석할 수 없음")
        }
        return header.substring(with: range)
    }
}
