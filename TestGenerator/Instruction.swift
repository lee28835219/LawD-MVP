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

enum InstQuestion : String {
    case publish = "[p]ublish"
    case publishOriginal = "[p]ublish [o]riginal"
    case publishShuffled = "[p]ublish [s]huffled"
    case solve = "sol[v]e"
    case solveShuffled = "sol[v]e [s]huffled"
    case solveControversal = "sol[v]e [c]ontroversl"
}


enum InstKey : String {
    
    case all = "all[1]"
    case question = "question[5]"
    
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
    
    case all = "all[1]"
    case category = "category[2]"
    case subject = "subject[3]"
    case test = "test[4]"
    case question = "question[5]"
    
    case unknown
    
    
    static let allValues = [all.rawValue, category.rawValue, subject.rawValue, test.rawValue, question.rawValue]
    
    init(_ value : String) {
        switch value {
            
        case "1":
            self = .all
        case "a":
            self = .all
            
        
        case "c":
            self = .category
        case "2":
            self = .category
        
        case "3":
            self = .subject
        case "s":
            self = .subject
        
        case "4":
            self = .test
        case "t":
            self = .test
            
        case "q":
            self = .question
        case "5":
            self = .question
            
        default:
            self = .unknown
        }
    }
}

enum InstSave : String {
    
    case all = "all[1]"
    case test = "test[4]"
    
    case unknown
    
    
    static let allValues = [all.rawValue, test.rawValue]
    
    init(_ value : String) {
        switch value {
            
        case "1":
            self = .all
            
        case "4":
            self = .test
            
        default:
            self = .unknown
        }
    }
}




enum InstGoon : String {
    
    case yes = "yes[.]"
    case skip = "skip[,]"
    case stop = "stop[~]"
    case all = "all"
    
    case unknown
    
    
    static let allValues = [yes.rawValue, skip.rawValue, stop.rawValue, all.rawValue]
    
    init(_ value : String) {
        switch value {
            
        case "y":
            self = .yes
        case ".":
            self = .yes
            
        case ",":
            self = .skip
        case "ㅏ":
            self = .skip
            
        case "~":
            self = .stop
        
        case "all":
            self = .all
            
        default:
            self = .unknown
        }
    }
}

enum InstSolve : String {
    
    case show = "show[=]"
    case solve = "solve[\\]"
    case noteQuestion = "note question[;]"
    case tagQuestion = "tag question[']"
    case modifyQuestoin = "modify question[/]"
    case next = "next[]"
    case exit = "exit[~]"
    
    
    static let allValues = [show.rawValue, solve.rawValue, noteQuestion.rawValue, tagQuestion.rawValue, modifyQuestoin.rawValue, next.rawValue, exit.rawValue]
    
    init(_ value : String) {
        switch value {
            
        case "w":
            self = .show
        case "=":
            self = .show
            
        case "s":
            self = .solve
        case "\\":
            self = .solve
            
        case "n":
            self = .noteQuestion
        case ";":
            self = .noteQuestion
            
        case "t":
            self = .tagQuestion
        case "'":
            self = .tagQuestion
            
        case "/":
            self = .modifyQuestoin
        case "ㅡ":
            self = .modifyQuestoin
            
        case "":
            self = .next
        case "":
            self = .next
        
        case "x":
            self = .exit
        case "~":
            self = .exit
        
        default:
            self = .next
        }
    }
}
enum InstEdit : String {
    
    case show = "show[=]"
    case notQuestion = "not question[1]"
    case notLists = "not lists[2]"
    case notSelections = "not selections[3]"
    case originalQuestion = "original question[4]"
    case originalLists = "original lists[5]"
    case originalSelection = "original selections[6]"
    case next = "next[]"
    case exit = "exit[~]"
    
    case unknown
    
    
    static let allValues = [show.rawValue, notQuestion.rawValue ,notLists.rawValue ,notSelections.rawValue ,originalQuestion.rawValue ,originalLists.rawValue ,originalSelection.rawValue, next.rawValue, exit.rawValue]
    
    init(_ value : String) {
        switch value {
            
        case "=":
            self = .show
            
        case "1":
            self = .notQuestion

        case "2":
            self = .notLists

        case "3":
            self = .notSelections

        case "4":
            self = .originalQuestion

        case "5":
            self = .originalLists
            
        case "6":
            self = .originalSelection
            
        case "":
            self = .next
        
        case "~":
            self = .exit
            
            
        default:
            self = .unknown
        }
    }
}

