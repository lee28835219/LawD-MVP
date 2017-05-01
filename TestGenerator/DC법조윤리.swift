//
//  DC법조윤리문제.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 1..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Cocoa

class DC법조윤리: DataConverter {
    var 정답 = [법조윤리정답]()
    
//    var object = [questionKey : Int, answer : Int)]()
    // testname : ( questionNumber, answer)
    
    //    Read JSON file with Swift 3
    //    http://stackoverflow.com/questions/40438784/read-json-file-with-swift-3

    
    convenience init() {
        self.init(answerFilename: "법조윤리 1회-7회 정답.json", questionFilename: "법조윤리 1회-7회 문제.txt")
        
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
                                        let temp정답 = 법조윤리정답(test: test.key, questionNumber: queNo, answer: ans)
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
        
        // 문제를 파싱
        
        //Read and write data from text file
        //http://stackoverflow.com/questions/24097826/read-and-write-data-from-text-file
        
        do {
            if let path = self.questionPath {
                print(path)
                let questionString = try String(contentsOf: path, encoding: String.Encoding.utf8)
                print(questionString)
            }
        } catch {
            fatalError("법조윤리 문제 파싱 error")
        }
        
        // =-=변호사윤리 시험기출 \d회 \d{3}.+=-=
        // 문\s{0,}\d+.
        
        // ㄱ\..+\n{0,}\s{0,}ㄴ\..+\n{0,}\s{0,}ㄷ\..+\n{0,}\s{0,}
        // ㄱ\..+\n{0,}\s{0,}ㄴ\..+\n{0,}\s{0,}ㄷ\..+\n{0,}\s{0,}ㄹ\..+\n{0,}\s{0,}
        // ㄱ\..+\n{0,}\s{0,}ㄴ\..+\n{0,}\s{0,}ㄷ\..+\n{0,}\s{0,}ㄹ\..+\n{0,}\s{0,}ㅁ\..+\n{0,}\s{0,}
        // ㄱ\..+\n{0,}\s{0,}ㄴ\..+\n{0,}\s{0,}ㄷ\..+\n{0,}\s{0,}ㄹ\..+\n{0,}\s{0,}ㅁ\..+\n{0,}\s{0,}ㅂ\..+\n{0,}\s{0,}
        // ㄱ\..+\n{0,}\s{0,}ㄴ\..+\n{0,}\s{0,}ㄷ\..+\n{0,}\s{0,}ㄹ\..+\n{0,}\s{0,}ㅁ\..+\n{0,}\s{0,}ㅂ\..+\n{0,}\s{0,}ㅅ\..+\n{0,}\s{0,}
        
        // 가\..+\n{0,}\s{0,}나\..+\n{0,}\s{0,}다\..+\n{0,}\s{0,}
        // 가\..+\n{0,}\s{0,}나\..+\n{0,}\s{0,}다\..+\n{0,}\s{0,}라\..+\n{0,}\s{0,}
        // 가\..+\n{0,}\s{0,}나\..+\n{0,}\s{0,}다\..+\n{0,}\s{0,}라\..+\n{0,}\s{0,}마\..+\n{0,}\s{0,}
        // 가\..+\n{0,}\s{0,}나\..+\n{0,}\s{0,}다\..+\n{0,}\s{0,}라\..+\n{0,}\s{0,}마\..+\n{0,}\s{0,}바\..+\n{0,}\s{0,}
        // 가\..+\n{0,}\s{0,}나\..+\n{0,}\s{0,}다\..+\n{0,}\s{0,}라\..+\n{0,}\s{0,}마\..+\n{0,}\s{0,}바\..+\n{0,}\s{0,}사\..+\n{0,}\s{0,}
        
        // ①.+\n{0,}\s{0,}②.+\n{0,}\s{0,}③.+\n{0,}\s{0,}④.+
        
        // NSRegularExpression Tutorial: Getting Started
        // https://www.raywenderlich.com/86205/nsregularexpression-swift-tutorial
        // https://regexone.com
        
        
        
    }
}
