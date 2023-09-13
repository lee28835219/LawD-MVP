//
//  DataConverter+Extension.swift
//  TestGenerator
//
//  Created by Masterbuilder on 2023/07/08.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import Foundation

extension DataConverter {
    
    
    
    
    
    
    
    
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
    
//    // 2017. 5. 15. 이후 사용안함
//    func sliceString_oldversion(regexPattern : String, string : String) -> [String : String] {
//        _headerAndResidualStrings = [:]  // 전역변수이므로 초기화가 매우 중요, 리컬시브 함수에서 파라미터를 포인터로 전달하는 방법은 없을까? 예가 구조체라서 불가능할려나 2017. 5. 7.
//        return _sliceString_oldversion(regexPattern : regexPattern, residualString : string, headerUn : nil)
//    }
//
//
//
//    private func _sliceString_oldversion(regexPattern : String, residualString : String, headerUn : String?) -> [String : String] {
//        let headerRangeUn = residualString.range(of: regexPattern, options: .regularExpression)
//        // 패턴을 못찾았을 경우 else구문 실행하여 종료
//        // 1. 패턴이 없는데 첫번째 루프 -> 치명적 에러
//        // 2. 패턴이 없는데 첫번째 루프가 아님 -> 파싱이 완료될 때가 되었음
//        guard let headerRange = headerRangeUn else
//        {
//            // 1. 패턴을 못찼잤는데 첫번재 루프라면 입력이 이상한 것임, 이대는 에러 메세지 출력 후 종료
//            guard let header = headerUn else {
//                fatalError("\(regexPattern)에 맞지 않는 이상한 텍스트를 파싱하려니 진행할 수 없음\n")
//            }
//            // 2. 패턴을못찼았는데 첫번째 루프가 아님, 이는 모든 작업이 완료된 것임, 따라서 잔여 스트링을 저장하고 종료함
//            //    이 때 사용하는 헤더는 함수에서 입력받은 헤더 즉 전 루프에서 찾았던 헤더의 정보임
//
//            //// newTest 초기화에 대해서 고민해봐야 함 (-) 2017. 5. 5.
//            // let testString = residualString
//            // let newTest = Test(testDB : TestDB(), isPublished: true, category: testCategory, subject: testSubject, number: getTestNumber(testHeader: testHeader), numHelper: 2017)
//            // newTest.specification = testHeader
//            // newTest.raw = testString
//            // 시험들.append(newTest)
//            //// newTest를 이 함수 안에서 초기화 하는 것 보다는 밖에서 나가서 할 수 있도록 수정, 이를 위해 Templet이라는 구조체를 만듬 2017. 5. 7.
//
//            self._headerAndResidualStrings[header] = residualString
//            return _headerAndResidualStrings
//        }
//
//        var _header = headerUn
//        var _residualString = residualString
//
//        //첫번째 루프가 아님
//        if _header != nil {  //이 조건식이 꼭 필요한가? 구조를 좀더 다시 생각해보는게 좋을 듯 2017. 5. 3.
//             let result = _residualString.substring(with: _residualString.startIndex..<headerRange.lowerBound)
//            // let newTest = Test(testDB : TestDB(), isPublished: true, category: testCategory, subject: testSubject, number: getTestNumber(testHeader: _testHeader!), numHelper: 2017)
//            // newTest.specification = _testHeader!
//            // newTest.raw = testString
//            // 시험들.append(newTest)
//
//            self._headerAndResidualStrings[_header!] = result
//        } else {
//        }
//
//        _header = _residualString.substring(with: headerRange) // 이는 절대로 nil이 될 수 없다. 왜냐하면 위에서 이미 headerRange을 체크하였기 때문이다. headerRange가 nil이 아니라는 것은 _residualString에 결과가 있다는 의미이다
//        _residualString = _residualString.substring(with: headerRange.upperBound..<_residualString.endIndex)
//
//        return _sliceString_oldversion(regexPattern: regexPattern, residualString: _residualString, headerUn: _header)
//    }
    

    // ^를 레겍스로 사용하기 위해선 혁명적 변화가 필요하다. 기존 String.range( 에서 NSRange(로 추출방법을 변경하였다. 2017. 5. 15.
    // 이는 결국 String.range(를 이용해 추출하는 sliceString함수 대신에 아래 새로짠 함수로 진행해야 함을 의미한다, 수정한 결과 잘 작동한다.
    
    // NSRegularExpression의 .anchorsMatchLines 옵션을 이용해서 ^표현을 사용하게 해준다.
    // 새로운 sliceString함수 2017. 5. 15.
    func sliceString(regexPattern : String, string : String) -> [String : String] {
        var listsDictionary = [String : String]()  // 만들어낼 대상
        
        // https://code.tutsplus.com/tutorials/swift-and-regular-expressions-swift--cms-26626
        // Swift and Regular Expressions: Swift
        let regex = try! NSRegularExpression(pattern: regexPattern, options: .anchorsMatchLines) // .anchorsMatchLines 옵션사용
        let matches = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count))
        
        var previousMatch : NSTextCheckingResult? = nil  // 버퍼
        
        for (index,match) in matches.enumerated() {
            
            if previousMatch != nil {
                let range = NSRange(location: previousMatch!.range.location+previousMatch!.range.length, length: (match.range.location-(previousMatch!.range.location+previousMatch!.range.length)))
                let seperator = (string as NSString).substring(with: previousMatch!.range)
                let residual = (string as NSString).substring(with: range)
                listsDictionary[seperator] = residual
            }
            
            if index == matches.count - 1 {
                let range = NSRange(location: match.range.location+match.range.length, length: (string.count - (match.range.location+match.range.length)))
                let seperator = (string as NSString).substring(with: match.range)
                let residual = (string as NSString).substring(with: range)
                listsDictionary[seperator] = residual
            } else {
                
                previousMatch = match
                
            }
        }
        return listsDictionary
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
            fatalError("\(answerFileName) 파일 안의 시험정보 \(testNumberRange) 안에는 시험회차정보가 없음")
        }
        
        let testNumberString = testHeader.substring(with: testNumberRangeWrapped)
        guard let testNumber = Int(testNumberString.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) else {
            fatalError("\(answerFileName)에서 문제회차정보를 찾을 수 없음")
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
    
    
    // 2023. 7. 7. 이 함수는 주어진 경로의 유효성을 확인하고, 파일이 존재하지 않거나 경로가 유효하지 않은 경우에는 에러를 발생시킵니다. 유효한 경로인 경우, 해당 경로를 반환하여 다른 작업에서 사용할 수 있도록 합니다.
    func checkPath(path : URL?)  -> URL {
        guard let answerPathUnwrraped = path else {
            fatalError("\(String(describing: path?.path))가 존재하지 않음") //path가 nil인 경우, fatalError("\(String(describing: path?.path))가 존재하지 않음") 구문이 실행될 때 path?.path의 값은 nil이 됩니다.
        }
        let fileManager = FileManager()
        if !fileManager.fileExists(atPath: answerPathUnwrraped.path) {
            fatalError("\(String(describing: path?.path))에 파일이 존재하지 않음")
        }
        return answerPathUnwrraped
    }
    func checkPath(paths : [URL?])  -> [URL] {
        var answerPathUnwrraped = [URL]()
        for path in paths {
            guard let answerPath = path else {
                fatalError("\(String(describing: path?.path))가 존재하지 않음")
            }
            let fileManager = FileManager()
            if !fileManager.fileExists(atPath: answerPath.path) {
                fatalError("\((path?.path)!)에 파일이 존재하지 않음")
            }
            answerPathUnwrraped.append(answerPath)
        }
        return answerPathUnwrraped
    }
    
    
    // ?
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
        
        return commentOut(textWrapped)
    }
    
    
    func commentOut(_ text :String) -> String {
        var outText = text
        if let commetnRange = outText.range(of: "//.+", options: .regularExpression) {
            outText = outText.substring(with: outText.startIndex..<commetnRange.lowerBound) + outText.substring(with: commetnRange.upperBound..<outText.endIndex)
            outText = commentOut(outText)
        }
        return outText
    }
    
    
    // 문제텍스트에서 목록을 가져오는 기능을 함수화 2017. 5. 12. 버그는 없으려나?
    func getListString(contentRaw: String, contentSuffix: String?) -> (contentRaw: String, contentSuffix: String?, lists: String?, listType: SelectStringType?) {
        
        
        var regexStr : String?
        regexStr = nil
        
        var listRange : Range<String.Index>? = nil
        var listType : SelectStringType? = nil
        
        
        if let range = contentRaw.range(of: "(가(\\..+\\n{0,}\\s{0,}))((나|다|라|마|바|사|아|자|차|카|타|파|하)(\\..+\\n{0,}\\s{0,})){1,14}", options: .regularExpression) {
            listType = SelectStringType.koreanLetter
            regexStr = "(가(\\..+\\n{0,}\\s{0,}))((나|다|라|마|바|사|아|자|차|카|타|파|하)(\\..+\\n{0,}\\s{0,})){1,14}"
            listRange = range
        }
        
        if let range = contentRaw.range(of: "((ㄱ|ㄴ|ㄷ|ㄹ|ㅁ|ㅂ|ㅅ|ㅇ|ㅈ|ㅊ|ㅋ|ㅌ|ㅍ|ㅎ)(\\..+\\n{0,}\\s{0,})){1,14}", options: .regularExpression) {
            if listType != nil {
                fatalError("파싱한 문자에 목록 선택지가 여래개 존재할 수 없음, 텍스트 입력의 오류가 의심됨")
            }
            listType = SelectStringType.koreanCharcter
            regexStr = "((ㄱ|ㄴ|ㄷ|ㄹ|ㅁ|ㅂ|ㅅ|ㅇ|ㅈ|ㅊ|ㅋ|ㅌ|ㅍ|ㅎ)(\\..+\\n{0,}\\s{0,})){1,14}"
            listRange = range
        }
        
        
        var lists : String? = nil
        var contRawOut = contentRaw
        var contSuffixOut = contentSuffix
        
        if listRange != nil {
            lists = contentRaw.substring(with: listRange!)
        
            // 이 지점에서 목록 문장 뒤에 있는 문제정보가 contentRaw에서 날라가 버리는 문제가 발생한다
            // 이는 꼭 바로잡아야 되는 문제이다. 그래서 수정하엿다. 그치만 출력함수가 안변하면 의미 없을 것이다. 2017. 5. 11. 꼭 바꾸길 (+)
            // 제대로 작동하는지 디버깅을 안해봐서 모르겠다. 담에 꼭해야함, <p>~~</p>처리도 함께
            contRawOut = contentRaw.substring(with: contentRaw.startIndex..<listRange!.lowerBound)
            if listRange!.upperBound < contentRaw.endIndex {
                contSuffixOut = contentRaw.substring(with: listRange!.upperBound..<contentRaw.endIndex)
                contRawOut = contentRaw.substring(with: contentRaw.startIndex..<listRange!.lowerBound)
            } else {
                contRawOut = contentRaw.substring(with: contentRaw.startIndex..<listRange!.lowerBound)
            }
        }
        
        return (contRawOut, contSuffixOut, lists, listType)
    }
    
    
    func listParser(listString: String?, listType: SelectStringType?) -> (rawLists: String, lists : [Templet.List]){
        
        var rawLists = ""
        var lists : [Templet.List] = []
        
        if listType != nil {
            
            var regex = ""
            
            switch listType! {
            case .koreanCharcter:
                regex = "ㄱ\\.|ㄴ\\.|ㄷ\\.|ㄹ\\.|ㅁ\\.|ㅂ\\.|ㅅ\\.|ㅇ\\.|ㅈ\\.|ㅊ\\.|ㅋ\\.|ㅌ\\.|ㅍ\\.|ㅎ\\."
            case .koreanLetter:
                regex = "^가\\.|^나\\.|^다\\.|^라\\.|^마\\.|^바\\.|^사\\.|^아\\.|^자\\.|^차\\.|^카\\.|^타\\.|^파\\.|^하\\."
                // ^ 표시가 없으면 문장의 ~한다.에 있는 다.를 다 읽어버리는 문제가 있을 것이어서 수정 2017. 5. 15.
            }
            
        
            rawLists = listString!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            let listsDictionary = sliceString(regexPattern: regex, string: rawLists)
            
            
            
            for listDictionary in listsDictionary {
                
                var newList = Templet.List()
                newList.specification = ""
                newList.content = listDictionary.value.trimmingCharacters(in: .whitespacesAndNewlines)
                newList.notContent = nil
                newList.listStringType = listType!  //여기 입력이 잘못되어 있어서 매우 긴 디버깅 시간이 걸림 2017. 5. 9.
                // 또 잘못되있었음 2017. 5. 15. 아주 그냥 상습범임
                newList.number = getKoreanCharacterOrLetterInListSelection(header: listDictionary.key).koreanCharacterAndLetterInt
                
                lists.append(newList)
            }
        }
        
        return (rawLists, lists)
    }
    
    
    // 진술 속의 "위 (①|②|③|④|⑤|⑥|⑦|⑧|⑨|⑩)" 부분을 태그로 전환해주는 함수
    func anotherSelectionPaser(_ statement : String) -> String {
        var resultString = statement
        
        if let anoSelInStateRange = statement.range(of: "위 (①|②|③|④|⑤|⑥|⑦|⑧|⑨|⑩)", options: .regularExpression) {
            
            // 태그안에 넣을 다른 선택지 숫자를 찾는 함수
            let numberRange = statement.substring(with: anoSelInStateRange).range(of: "(①|②|③|④|⑤|⑥|⑦|⑧|⑨|⑩)", options: .regularExpression)
            let anoSelNumber = statement.substring(with: anoSelInStateRange).substring(with: numberRange!).roundInt
            
            // 결과를 편집
            resultString = resultString.substring(with: statement.startIndex..<anoSelInStateRange.lowerBound) + "<anotherSelection>" + anoSelNumber.description + "</anotherSelection>" + resultString.substring(with: anoSelInStateRange.upperBound..<statement.endIndex)
            resultString = anotherSelectionPaser(resultString)
        }
        return resultString
    }
}
