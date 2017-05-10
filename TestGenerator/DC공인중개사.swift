//
//  DC공인중개사.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 1..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Cocoa

class DC공인중개사: DCDD {
    
    convenience init?(_ testDatabase : TestDatabase) {
        
        
        self.init(testDatabase: testDatabase,
                  answerFilename: "공인중개사-정답.json",
                  questionFilename: "공인중개사-문제.txt"
        )
        
        
        
        log = log + "Data Converter Log 종료 \(Date().HHmmss)"
        print(log)
        
    }
}


