//
//  TestDB
//  TestGenerator
//
//  Created by Master Builder on 2017. 3. 22..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation
class TestCategory : DataStructure {
    let testDatabase : TestDatabase
    
    let category : String //변호사시험
    let catHelper : String //모의
    
    // How do I format JSON Date String with Swift?
    // http://stackoverflow.com/questions/28748162/how-do-i-format-json-date-string-with-swift
    let createDate	: Date = Date()
    
    var testSubjects : [TestSubject] = []
    
    init(testDatabase: TestDatabase, category: String, catHelper: String? = nil) {
        
        self.testDatabase = testDatabase
        
        self.category = category
        if catHelper == nil {
            self.catHelper = ""
        } else {
            self.catHelper = catHelper!
        }
        
        
        
        var key : String = ""
        if let catHelperWrapped = catHelper {
            key = key + self.category + "-" + catHelperWrapped
        } else {
            key = key + self.category
        }
        
        for category in self.testDatabase.categories {
            if category.key == key {
                 fatalError("\(key)과 똑같은 시험이 이미 testDB \(testDatabase.key)에 있음")
                // 똑같은 변호사시험이라는 카테고리가 있어도 추가로 넣어도 상관없음, 7회라든지...
            }
        }
        
        
        
        super.init(UUID(), key)
        testDatabase.categories.append(self)
    }
}
