//
//  TestDatabase.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 9..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Cocoa

class TestDatabase: DataStructure {
    
    var log = ""
    
    let createDate	: Date = Date()
    
    var categories : [TestCategory] = []
    var tagAddress : [(tag : String, dataType : DataType, foreignKey : String)] = []
    
    
    override init(_ key: String = "Default") {
        super.init(key)
    }
    
    func removeVoidPointer() -> [String] {
        var result = [String]()
        
        for cat in categories {
            for sub in cat.testSubjects {
                if sub.tests.count == 0 {
                    result.append(sub.key)
                }
            }
        }
        
        for cat in categories {
            if cat.testSubjects.count == 0 {
                result.append(cat.key)
            }
        }
        
        for removeKey in result {
            self.categories = self.categories.filter(){$0.key != removeKey}
        }
        
        for removeKey in result {
            for (_,cat) in categories.enumerated() {
//                categories[index] = categories[index].testSubjects.
                print(cat.testSubjects.filter(){$0.key != removeKey})
            }
        }
        
        
        
        return result
    }
    
}


enum DataType {
    case Question
    case Selection
    case List
}
