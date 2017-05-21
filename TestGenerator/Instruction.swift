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

enum HelpInstruction {
    case InstMain
    case InstKey
    case InstPublish
    case InstSave
    case InstGoon
    case InstSolve
    case InstEdit
}

enum InstMain : String {
    
    case help = "help"
    case exit = "exit"
    case keys = "[k]eys"
    case publish = "[p]ublish"
    case publishOriginal = "[p]ublish [o]riginal"
    case publishShuffled = "[p]ublish [s]huffled"
    case solve = "sol[v]e"
    case solveShuffled = "sol[v]e [s]huffled"
    case solveControversal = "sol[v]e [c]ontroversl"
    case edit = "[e]dit"
    case save = "save"
    case refresh = "refresh"
    
    case unknown
    
    // Get all enum values as an array
    // http://stackoverflow.com/questions/32952248/get-all-enum-values-as-an-array
    
    static let allValues = [help.rawValue, exit.rawValue, keys.rawValue, publish.rawValue, publishOriginal.rawValue ,publishShuffled.rawValue, solve.rawValue, solveShuffled.rawValue, solveControversal.rawValue, edit.rawValue, save.rawValue, refresh.rawValue]
    
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
        
        case "po":
            self = .publishOriginal
        case "ㅔㅐ":
            self = .publishOriginal
        
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
            
        case "vc":
            self = .solveControversal
        case "ㅍㅊ":
            self = .solveControversal
            
            
        case "e":
            self = .edit
        case "ㄷ":
            self = .edit
            
            
        case "ㄴㅁㅍㄷ":
            self = .save
        case "save":
            self = .save
            
            
        case "refresh":
            self = .refresh
        case "ㄱㄷㄹㄱㄷㄴㅗ":
            self = .refresh
            
            
        default:
            self = .unknown
        }
    }
}

enum SolveQuestionInstructionType : String {
    case publish = "[p]ublish"
    case publishOriginal = "[p]ublish [o]riginal"
    case publishShuffled = "[p]ublish [s]huffled"
    case solve = "sol[v]e"
    case solveShuffled = "sol[v]e [s]huffled"
    case solveControversal = "sol[v]e [c]ontroversl"
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




enum InstGoon : String {
    
    case yes = "[y]es"
    case skip = "s[k]ip"
    case stop = "[s]top"
    case all = "all"
    
    case unknown
    
    
    static let allValues = [yes.rawValue, skip.rawValue, stop.rawValue, all.rawValue]
    
    init(_ value : String) {
        switch value {
            
        case "y":
            self = .yes
        case "ㅛ":
            self = .yes
            
        case "k":
            self = .skip
        case "ㅏ":
            self = .skip
            
        case "s":
            self = .stop
        case "ㄴ":
            self = .stop
        
        case "all":
            self = .all
        case "ㅁㅣㅣ":
            self = .all
            
        default:
            self = .unknown
        }
    }
}

enum InstSolve : String {
    
    case resolve = "[r]esolve"
    case noteQuestion = "[n]ote question"
    case tagQuestion = "[t]ag question"
    case modifyQuestoin = "[m]odify question"
    case next = "next[]"
    case exit = "e[x]it"
    
    case unknown
    
    
    static let allValues = [resolve.rawValue, noteQuestion.rawValue, tagQuestion.rawValue, modifyQuestoin.rawValue, next.rawValue, exit.rawValue]
    
    init(_ value : String) {
        switch value {
            
        case "r":
            self = .resolve
        case "ㄱ":
            self = .resolve
            
        case "n":
            self = .noteQuestion
        case "ㅜ":
            self = .noteQuestion
            
        case "t":
            self = .tagQuestion
        case "ㅅ":
            self = .tagQuestion
            
        case "m":
            self = .modifyQuestoin
        case "ㅡ":
            self = .modifyQuestoin
            
        case "":
            self = .next
        case "":
            self = .next
        
        case "x":
            self = .exit
        case "ㅌ":
            self = .exit
        
        default:
            self = .unknown
        }
    }
}
enum InstEdit : String {
    
    case notQuestion = "not [q]uestion"
    case notLists = "not [l]ists"
    case notSelections = "not [s]elections"
    case originalQuestion = "[o]riginal [q]uestion"
    case originalLists = "[o]riginal [l]ists"
    case originalSelection = "[o]riginal [s]elections"
    case next = "next[]"
    case exit = "e[x]it"
    
    case unknown
    
    
    static let allValues = [notQuestion.rawValue ,notLists.rawValue ,notSelections.rawValue ,originalQuestion.rawValue ,originalLists.rawValue ,originalSelection.rawValue, next.rawValue, exit.rawValue]
    
    init(_ value : String) {
        switch value {
            
        case "q":
            self = .notQuestion
        case "ㅂ":
            self = .notQuestion

        case "l":
            self = .notLists
        case "ㅣ":
            self = .notLists

        case "s":
            self = .notSelections
        case "ㄴ":
            self = .notSelections

        case "oq":
            self = .originalQuestion
        case "ㅐㅂ":
            self = .originalQuestion

        case "ol":
            self = .originalLists
        case "ㅐㅣ":
            self = .originalLists

        case "os":
            self = .originalSelection
        case "ㅐㄴ":
            self = .originalSelection
            
        case "":
            self = .next
        
        case "x":
            self = .exit
        case "ㅌ":
            self = .exit
            
            
        default:
            self = .unknown
        }
    }
}

