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
        self.init(filename: "법조윤리 1회-7회 정답.json")
        
        // 정답을 파싱
        do {
            if let path = self.path {
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
            fatalError("error")
        }
        
        // 문제를 파싱
        
        
        
        
    }
}
