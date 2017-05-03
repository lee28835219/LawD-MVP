//
//  DC법조윤리문제.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 1..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Cocoa

class DC법조윤리: DataConverter {
    var 정답 = [법조윤리]()
    
//    var object = [questionKey : Int, answer : Int)]()
    // testname : ( questionNumber, answer)
    
    //    Read JSON file with Swift 3
    //    http://stackoverflow.com/questions/40438784/read-json-file-with-swift-3

    
    convenience init() {
        self.init(testName: "법조윤리", answerFilename: "법조윤리 1회-7회 정답.json", questionFilename: "법조윤리 1회-7회 문제.txt")
        
        // 정답을 파싱
        do {
            if let path = self.answerPath {
                print(path)
                let data = try Data(contentsOf: path)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let obj = json as? [String:Any] {
                    for test in obj {
                        if let queData = test.value as? [[String:Any]] {
                            for answerPair in queData {
                                if let queNo = answerPair["문번"] as? Int {
                                    if let ans = answerPair["정답"] as? Int {
                                        print(test.key,queNo,"-", ans)
                                        // Swift How to get integer from string and convert it into integer
                                        // http://stackoverflow.com/questions/30342744/swift-how-to-get-integer-from-string-and-convert-it-into-integer
                                        guard let testNumber = Int(test.key.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) else {
                                            fatalError("법조윤리 정답 파싱 error")
                                        }
                                        let temp정답 = 법조윤리(test: test.key, testNumber: testNumber, questionNumber: queNo, answer: ans, question: "")
                                        정답.append(temp정답)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } catch {
            fatalError("법조윤리 정답 파싱 error")
        }
        print(testName," 정답 입력 완료")
        
        // 문제를 파싱
        
        //Read and write data from text file
        //http://stackoverflow.com/questions/24097826/read-and-write-data-from-text-file
        
        var wholeStringUn : String?
        do {
            if let path = self.questionPath {
                print(path)
                wholeStringUn = try String(contentsOf: path, encoding: String.Encoding.utf8)
            }
        } catch {
            fatalError("법조윤리 문제 파싱 error")
        }
        guard let wholeString = wholeStringUn else {
            fatalError("can't find test string")
        }
        
        print("-------------")
        var residualString = wholeString
        var testHeader : String? = nil
        
        while true {
            let headerRangeUn = residualString.range(of: "=-=변호사윤리 시험기출 \\d회 \\d{3}.+=-=", options: .regularExpression)
            guard let headerRange = headerRangeUn else
            {
                print("---시험 파싱완료")
                break
            }
            if testHeader == nil {
                testHeader = residualString.substring(with: headerRange)
                residualString = residualString.substring(with: headerRange.upperBound..<residualString.endIndex)
                continue
            }
            
            let testName = testHeader
            let testString = residualString.substring(with: residualString.startIndex..<headerRange.lowerBound)
            
            testHeader = residualString.substring(with: headerRange)
            residualString = residualString.substring(with: headerRange.upperBound..<residualString.endIndex)
        }
        
        
        for (indexTest, test) in testString.enumerated() {
            for (indexQuestion, question) in questionString.enumerated() {
                print(indexTest, " : ", indexQuestion)
            }
        }
        
        
        
//        print(testString ?? "법조윤리 문제 파싱 error")
        
        //시험문제를 분설
        // =-=변호사윤리 시험기출 \d회 \d{3}.+=-=
        
//        var regex : NSRegularExpression?
//        
//        var pattern = "=-=변호사윤리 시험기출 \\d회 \\d{3}.+=-="
//        
//        do {
//            regex = try NSRegularExpression(pattern: pattern, options: [])
//        } catch {
//            print(error)
//        }
//        
//        let range = NSMakeRange(0, testString.characters.count)
//        let testMatchesUnwrapped = regex?.matches(in: testString, options: [], range: range)
//        
//        guard let testMatches =  testMatchesUnwrapped else {
//            fatalError("can't find any question")
//        }
//        
//        var testGroups = [String]()
//        
////        var residualTestString = testString
//        
//        for test in testMatches {
//            let range = test.range
//            let testGroup = (testString as NSString).substring(with: range)
//            print(testGroup)
//        }
//        let rangs = testString.range(of: pattern, options: .regularExpression)
//        
//        
//        
//        print(testString.substring(with: rangs!))
//        rangs?.lowerBound
        
        
        
        
        // https://www.raywenderlich.com/86205/nsregularexpression-swift-tutorial
        // NSRegularExpression Tutorial: Getting Started
        
//        var regex : NSRegularExpression?
//        
//        
//        //    let regex = NSRegularExpression(pattern: pattern, options: .allZeros, error: nil)
//        do {
//            regex = try NSRegularExpression(pattern: pattern, options: [])
//        } catch {
//            print(error)
//        }
//        
//        let range = NSMakeRange(0, string.characters.count)
//        //    let range = NSMakeRange(0, countElements(string))
//        let matches = (regex?.matches(in: string, options: [], range: range))! as [NSTextCheckingResult]
//        //    let matches = regex?.matchesInString(string, options: .allZeros, range: range) as [NSTextCheckingResult]
//        
//        return matches.map {
//            let range = $0.range
//            return (string as NSString).substring(with: range)
//        }
//
        
        
    }
}
