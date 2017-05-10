//
//  DDDD.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 8..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//
//
//  DC변호사시험민사법.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 7..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Cocoa

class DCDD : DataConverter {
    
    convenience init?(_ testDatabase : TestDatabase) {
        
        self.init(testDatabase: testDatabase,
                  answerFilename: "공인중개사-정답.json",
                  questionFilename: "공인중개사-문제.txt"
        )
        
        let resultTuple = extractTestAndAnswerJson()
        setTestAndAnswerTemplet(resultTuple)
        
        
        
        _ = saveTests()
        
        
        log = log + "Data Converter Log 종료 \(Date().HHmmss)"
        print(log)
        

    }
}
