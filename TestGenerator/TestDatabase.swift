//
//  TestDatabase.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 9..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Cocoa

class TestDatabase: DataStructure {
    
    let createDate	: Date = Date()
    
    var categories : [TestCategory] = []
    var tagAddress : [(tag : String, dataType : DataType, foreignKey : String)] = []
    
    
    override init(_ key: String = "Default") {
        super.init(key)
    }
    
}


enum DataType {
    case Question
    case Selection
    case List
}
