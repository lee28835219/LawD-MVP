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

import Foundation

class DCDD : DataConverter {
    
    convenience init?(_ testDatabase : TestDatabase) {
        
        self.init(testDatabase: testDatabase,
                  answerFileName: "공인중개사-정답.json",
                  questionFileNames: ["공인중개사-문제.txt"]
        )
        
    }
}
