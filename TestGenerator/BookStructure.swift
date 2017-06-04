//
//  Book.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 6..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Cocoa

class BookStructure : NSObject {
    let up : BookStructure?
    var downs : [BookStructure] = []
    let key : String
    let sequence : Int
    let seqString : String
    let seqSub : String? = nil
    var name : String
    let nameSub : String? = nil
    var value : String
    let valSub : String? = nil
    let sections : [String] = []
    let cases : [String] = []
    
    init(up : BookStructure?, sequence : Int, seqString : String, name : String, value : String) {
        self.sequence = sequence
        self.seqString = seqString
        self.name = name
        self.value = value
        
        if up == nil {
            self.key = ""
        } else {
            self.key = up!.key + "=" + self.seqString
        }
        self.up = up
    }
    
}
