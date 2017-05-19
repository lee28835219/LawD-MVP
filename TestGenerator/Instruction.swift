//
//  Instruction.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 10..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation


// 2017. 5. 9. 어떻게 하면 이넘 기술을 잘이용해서 Input을 잘 관리할 수 있는지 기술을 생각해야 한다. (+)

//enum Instruction : [String] {
//    case help
//        return ["h"]
//    case exit
//        return ["exit"]
//    case ShowTestCategory
//        return ["tcat"]
//}

enum Instruction {
    case InstMain
    case InstKey
    case InstPublish
    case InstSave
}

enum InstMain : String {
    
    case help = "help"
    case exit = "exit"
    case keys = "[k]eys"
    case publish = "[p]ublish"
    case publishShuffled = "[p]ublish[s]huffled"
    case solve = "sol[v]e"
    case solveShuffled = "sol[v]e[s]huffled"
    case edit = "edit"
    case save = "save"
    
    case unknown
    
    // Get all enum values as an array
    // http://stackoverflow.com/questions/32952248/get-all-enum-values-as-an-array
    
    static let allValues = [help.rawValue, exit.rawValue, keys.rawValue, publish.rawValue, publishShuffled.rawValue, solve.rawValue, edit.rawValue, save.rawValue]
    
    init(_ value : String) {
        switch value {
            
        case "help":
            self = .help
        case "ㅗㄷㅣㅔ":
            self = .help
            
            
        case "exit":
            self = .exit
        case "ㄷㅌㅑㅅ":
            self = .exit
            
        case "k":
            self = .keys
        case "ㅏ":
            self = .keys
            
        case "p":
            self = .publish
        case "ㅔ":
            self = .publish
        
        case "ps":
            self = .publishShuffled
        case "ㅔㄴ":
            self = .publishShuffled
            
            
        case "v":
            self = .solve
        case "ㅍ":
            self = .solve
        
        case "vs":
            self = .solveShuffled
        case "ㅍㄴ":
            self = .solveShuffled
            
            
        case "edit":
            self = .edit
        case "ㄷㅇㅑㅅ":
            self = .edit
            
        case "ㄴㅁㅍㄷ":
            self = .save
        case "save":
            self = .save
            
            
        default:
            self = .unknown
        }
    }
}

enum InstKey : String {
    
    case all = "[a]ll"
    case question = "[q]uestion"
    
    case unknown
    
    
    static let allValues = [all.rawValue, question.rawValue]
    
    init(_ value : String) {
        switch value {
            
        case "a":
            self = .all
            
        case "q":
            self = .question
            
        default:
            self = .unknown
        }
    }
}

enum InstPublish : String {
    
    case all = "[a]ll"
    case category = "[c]ategory"
    case subject = "[s]ubject"
    case test = "[t]est"
    case question = "[q]uestion"
    
    case unknown
    
    
    static let allValues = [all.rawValue, category.rawValue, subject.rawValue, test.rawValue, question.rawValue]
    
    init(_ value : String) {
        switch value {
            
        case "a":
            self = .all
        case "ㅁ":
            self = .all
            
        
        case "c":
            self = .category
        case "ㅊ":
            self = .category
        
        case "s":
            self = .subject
        case "ㄴ":
            self = .subject
        
        case "t":
            self = .test
        case "ㅅ":
            self = .test
            
        case "q":
            self = .question
        case "ㅂ":
            self = .question
            
        default:
            self = .unknown
        }
    }
}

enum InstSave : String {
    
    case all = "[a]ll"
    case test = "[t]est"
    
    case unknown
    
    
    static let allValues = [all.rawValue, test.rawValue]
    
    init(_ value : String) {
        switch value {
            
        case "a":
            self = .all
            
        case "t":
            self = .test
            
        default:
            self = .unknown
        }
    }
}


