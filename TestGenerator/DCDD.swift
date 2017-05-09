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
        
        self.init(testDatabase : testDatabase,
                  testCategory: "변호사시험 모의시험",
                  catHelper : nil,
                  subject : "민사법",
                  answerFilename: "TestAnswer.json",
                  questionFilename: "Test.txt")
        
        let testSeperator = "=변호사시험=\\d+회=.+법=선택형="
        
        parseAnswerAndTestFromJsonFormat(testSeperator: testSeperator)
        parseQustionsFromTextFile(testSeperator: testSeperator
            , questionSeperator: "문\\s{0,}\\d+."
            , selectionSeperator: "(①|②|③|④|⑤|⑥|⑦|⑧|⑨|⑩)(.+\\n{0,}){1,9}"
            , numberOfSelections: 5
        )
        
        _ = saveTests()
        
        log = log + "Data Converter Log 종료 \(Date().HHmmss)"
        print(log)
    }
}
