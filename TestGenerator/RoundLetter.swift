//
//  RoundLetter.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 6. 7..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class RoundLetter: BookStructure {
    
    init(seqRoundNumber: SeqRoundNumber, sequence : Int, name : String, value : String) {
        var str = ""
        
        switch sequence {
        case 1:
            str = "㉠"
        case 2:
            str = "㉡"
        case 3:
            str = "㉢"
        case 4:
            str = "㉣"
        case 5:
            str = "㉤"
        case 6:
            str = "㉥"
        case 7:
            str = "㉦"
        case 8:
            str = "㉧"
        case 9:
            str = "㉨"
        case 10:
            str = "㉩"
        default:
            str = "㉩"
        }
        
        super.init(up : seqRoundNumber, sequence: sequence, seqString:str, name: name, value: value)
    }
}
