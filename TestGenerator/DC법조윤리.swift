//
//  DC법조윤리문제.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 1..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Cocoa

class DC법조윤리: DataConverter {
    
//    var object = [questionKey : Int, answer : Int)]()
    // testname : ( questionNumber, answer)
    
    //    Read JSON file with Swift 3
    //    http://stackoverflow.com/questions/40438784/read-json-file-with-swift-3

    convenience init() {
        self.init(testCategory: "변호사윤리시험", testSubject: "법조윤리", answerFilename: "법조윤리 1회-7회 정답.json", questionFilename: "법조윤리 1회-7회 문제.txt")
        // 정답을 파싱
        do {
            if let path = self.answerPath {
                //                print(path)
                let data = try Data(contentsOf: path)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let obj = json as? [String:Any] {
                    for test in obj {
                        if let queData = test.value as? [[String:Any]] {
                            for answerPair in queData {
                                if let queNo = answerPair["문번"] as? Int {
                                    if let ans = answerPair["정답"] as? Int {
                                        // Swift How to get integer from string and convert it into integer
                                        // http://stackoverflow.com/questions/30342744/swift-how-to-get-integer-from-string-and-convert-it-into-integer
                                        guard let testNumber = Int(test.key.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) else {
                                            fatalError("법조윤리 정답 파싱 error")
                                        }
                                        let temp정답 = 정답(test: test.key, testNumber: testNumber, questionNumber: queNo, answer: ans)
                                        정답들.append(temp정답)
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
        //        print(testName," 정답 입력 완료")

        
        
        // 문제를 파싱
        
        //Read and write data from text file
        //http://stackoverflow.com/questions/24097826/read-and-write-data-from-text-file
        
        
        print("--법조윤리 문제 파싱시작")
        
        let wholeTestString = getText(path: self.questionPath)
        sliceTestString(regexPattern: "=-=변호사윤리 시험기출 \\d회 \\d{3}.+=-=", string: wholeTestString)
        
        
        let test1 = 시험들[0]
        
        for test in 시험들 {
            sliceQuestionString(regexPattern: "문\\s{0,}\\d+.", residualString: test1.string!, test: test, headerUn: nil)
        }
        
        for test in 시험들 {
            for (index,que) in test.questions.enumerated() {
                print("oooooooo ",test.category,test.subject,test.number,index+1)
                print(que.string)
            }
        }
        
        
    }
}
