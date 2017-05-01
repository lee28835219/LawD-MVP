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
    
    var filename : String
    let path : URL?
    
    init(filename: String) {
        self.filename = filename
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            self.path = dir.appendingPathComponent(self.filename)
        } else {
            self.path = nil
        }
    }
    
}
