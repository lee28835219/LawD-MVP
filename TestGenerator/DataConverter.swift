//
//  DataConverter.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 1..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

//How can I quickly and easily convert spreadsheet data to JSON? [closed]
//http://stackoverflow.com/questions/19187085/how-can-i-quickly-and-easily-convert-spreadsheet-data-to-json

//Read and write data from text file
//http://stackoverflow.com/questions/24097826/read-and-write-data-from-text-file

class DataConverter: NSObject {
    var log : String
    var printLog = false
    
    var testDatabase : TestDatabase
    var testCategories : [Templet.TestCategory] = []
    
    var answerFileName : String
    var questionFileNames : [String]
    let answerPath : URL?
    var questionPaths = [URL?]()
    
    var directory : String?
    
    //    private var _headerAndResidualStrings : [String : String] = [:]
    
    init(testDatabase : TestDatabase,
         answerFileName: String,
         questionFileNames : [String],
         directory : String? = nil) {
        
        self.log = ConsoleIO.newLog("\(#file)")
        self.testDatabase = testDatabase
        self.answerFileName = answerFileName
        self.questionFileNames = questionFileNames
        
        //Accessing files in xcode
        //https://www.youtube.com/watch?v=71DnOYeqJuM
        //Mac OX 는 Bundle이라는 개념이 없는듯 하다, 프로젝트에 txt를 가지고 다니도록 하는 방법을 더 찾아봐야 한다 (+) 2017. 5. 1.
        
        //How can I add a file to an existing Mac OS X .app bundle?
        //http://stackoverflow.com/questions/14950440/how-can-i-add-a-file-to-an-existing-mac-os-x-app-bundle
        
        //일단 system의 document폴더 안의 TestGeneratorResource 에서 읽는 것으로 진행
        if let dirDocument = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            var dir = dirDocument.appendingPathComponent("TestGenerator").appendingPathComponent("Data").appendingPathComponent("Resource")
            if directory != nil {
                dir = dir.appendingPathComponent(directory!)
            }
            self.answerPath = dir.appendingPathComponent(self.answerFileName)
            for quFileName in self.questionFileNames {
                self.questionPaths.append(dir.appendingPathComponent(quFileName))
            }
        } else {
            fatalError("파일을 파싱해서 저장하려는 Document 폴더가 존재하지 않음")
        }
    }
}


