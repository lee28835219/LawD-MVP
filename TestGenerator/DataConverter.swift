//
//  DataConverter.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 1..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Cocoa

//How can I quickly and easily convert spreadsheet data to JSON? [closed]
//http://stackoverflow.com/questions/19187085/how-can-i-quickly-and-easily-convert-spreadsheet-data-to-json

//Read and write data from text file
//http://stackoverflow.com/questions/24097826/read-and-write-data-from-text-file
class DataConverter: NSObject {
    
    var answerFilename : String
    let answerPath : URL?
    var questionFilename : String
    let questionPath : URL?
    
    init(answerFilename: String, questionFilename : String) {
        self.answerFilename = answerFilename
        self.questionFilename = questionFilename
        
        //Accessing files in xcode
        //https://www.youtube.com/watch?v=71DnOYeqJuM
        //Mac OX 는 Bundle이라는 개념이 없는듯 하다, 프로젝트에 txt를 가지고 다니도록 하는 방법을 더 찾아봐야 한다 (+) 2017. 5. 1.
        
        //How can I add a file to an existing Mac OS X .app bundle?
        //http://stackoverflow.com/questions/14950440/how-can-i-add-a-file-to-an-existing-mac-os-x-app-bundle
        
        //일단 system의 document폴더 안의 TestGeneratorResource 에서 읽는 것으로 진행
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let dirTestGeneratorResource = dir.appendingPathComponent("TestGeneratorResource")
            print(dirTestGeneratorResource)
            
            self.answerPath = dirTestGeneratorResource.appendingPathComponent(self.answerFilename)
            self.questionPath = dirTestGeneratorResource.appendingPathComponent(self.questionFilename)
        } else {
            self.answerPath = nil
            self.questionPath = nil
        }
    }
}
