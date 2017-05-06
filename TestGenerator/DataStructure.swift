//
//  DataStructure.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 6..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

// http://stackoverflow.com/questions/27043853/what-is-differant-import-cocoa-and-import-foundation-in-xcodes-playground
// what is differant 'import Cocoa' and 'import Foundation' in Xcode's Playground

import Cocoa

// Quick Guide to Swift Delegates
// https://useyourloaf.com/blog/quick-guide-to-swift-delegates/

class DataStructure: NSObject {

    let key : String
    var specification : String = ""
    var modifiedDate : Date = Date()
    var tags = [String]()
    
    init(_ key: String) {
        self.key = key
    }
}
