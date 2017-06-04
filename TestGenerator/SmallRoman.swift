//
//  SmallRoman.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 6. 7..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class SmallRoman: BookStructure {
    
    init(roundLetter : RoundLetter, sequence : Int, name : String, value : String) {
        
        
        var seqStr : String
        
        switch sequence {
        case 1:
            seqStr = "ⅰ"
        case 2:
            seqStr = "ⅱ"
        case 3:
            seqStr = "ⅲ"
        case 4:
            seqStr = "ⅳ"
        case 5:
            seqStr = "ⅴ"
        case 6:
            seqStr = "ⅵ"
        case 7:
            seqStr = "ⅶ"
        case 8:
            seqStr = "ⅷ"
        case 9:
            seqStr = "ⅸ"
        case 10:
            seqStr = "ⅹ"
        case 11:
            seqStr = "ⅺ"
        case 12:
            seqStr = "ⅻ"
        default:
            seqStr = "0"
        }
        
        super.init(up : roundLetter, sequence: sequence, seqString: seqStr, name: name, value: value)
    }
}
