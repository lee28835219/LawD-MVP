//
//  DC변호사시험.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 7..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class DC변호사시험 : DataConverter {
    
    //    Read JSON file with Swift 3
    //    http://stackoverflow.com/questions/40438784/read-json-file-with-swift-3
    
    init?(_ testDatabase : TestDatabase) {
        
        let testName = "변호사시험"
        
        super.init(testDatabase: testDatabase,
                   answerFileName: "변호사시험=1~6회-정답.json",
                   questionFileNames: [
                                       "=변호사시험=공법=1회=선택형=.txt",
                                       "=변호사시험=공법=2회=선택형=.txt",
                                       "=변호사시험=공법=3회=선택형=.txt",
                                       "=변호사시험=공법=4회=선택형=.txt",
                                       "=변호사시험=공법=5회=선택형=.txt",
                                       "=변호사시험=공법=6회=선택형=.txt",
                                       "=변호사시험=형사법=1회=선택형=.txt",
                                       "=변호사시험=형사법=2회=선택형=.txt",
                                       "=변호사시험=형사법=3회=선택형=.txt",
                                       "=변호사시험=형사법=4회=선택형=.txt",
                                       "=변호사시험=형사법=5회=선택형=.txt",
                                       "=변호사시험=형사법=6회=선택형=.txt",
                                       "=변호사시험=민사법=1회=선택형=.txt",
                                       "=변호사시험=민사법=2회=선택형=.txt",
                                       "=변호사시험=민사법=3회=선택형=.txt",
                                       "=변호사시험=민사법=4회=선택형=.txt",
                                       "=변호사시험=민사법=5회=선택형=.txt",
//                                       "=변호사시험=민사법=6회=선택형=.txt"  // 정답입력이 잘못되어 수정함 2017. 5. 28.
//                                       "test.txt"
                                      ],
                   directory: "1. 변호사시험"
        )
        
        
        self.printLog = true
        
        
        let resultTuple = extractTestAndAnswerJson()
        setTestAndAnswerTemplet(resultTuple)
        
        
        
        
        let testSeperator = "=(\(testName))=(.+)=(\\d+)회=선택형"
        
        parseQustionsFromTextFile(testSep: testSeperator
            // "문\\s{0,}\\d+."의 형식으로 레겍스를 입력할 경우 .항목이 모든 문자를 가져오는 것으로 해석되버리므로 여기서는 꼭 \.표현으로 입력해주어야 함 2017. 5. 11.
            , queSep: "^문\\s{0,}\\d+\\."
            , selSep: "(①|②|③|④|⑤|⑥|⑦|⑧|⑨|⑩)(.+\\n{0,}){1,9}"
            , numberOfSels: 5
        )
        
        
        _ = uploadTests()
        
        
        
        
        log = ConsoleIO.closeLog(log, file: "\(#file)")
        if printLog {
            print(log)
        }
        
        
    }
}
