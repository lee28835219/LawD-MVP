//
//  DC법조윤리문제.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 1..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Cocoa

class DC법조윤리: DataConverter {
    
    //    Read JSON file with Swift 3
    //    http://stackoverflow.com/questions/40438784/read-json-file-with-swift-3

    convenience init?(_ testDB : TestDB) {
        self.init(testDB: testDB, testCategory: "변호사윤리시험", answerFilename: "변호사윤리시험-1회~7회-법조윤리-정답.json", questionFilename: "변호사윤리시험-1회~7회-법조윤리-문제.txt")
        
        

        let testSeperator = "=-=변호사윤리 시험기출 \\d+회 \\d+=-="
        
        parseAnswerAndTestFromJsonFormat(testSeperator: testSeperator)
        parseQustionsFromTextFile(testSeperator: testSeperator
            , questionSeperator: "문\\s{0,}\\d+."
            , selectionSeperator: "(①|②|③|④|⑤|⑥|⑦|⑧|⑨|⑩)(.+\\n{0,}){1,9}"
            , numberOfSelections: 4
        )
        
        _ = saveTests()
        
        print(log)

        
    }
}


