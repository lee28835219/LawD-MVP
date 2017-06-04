//
//  Roman.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 6. 7..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class Roman: BookStructure {
    
    init(title : Title, sequence : Int, name : String, value : String) {
        
        
        var seqStr : String
        
        switch sequence {
        case 1:
            seqStr = "Ⅰ"
        case 2:
            seqStr = "Ⅱ"
        case 3:
            seqStr = "Ⅲ"
        case 4:
            seqStr = "Ⅳ"
        case 5:
            seqStr = "Ⅴ"
        case 6:
            seqStr = "Ⅵ"
        case 7:
            seqStr = "Ⅶ"
        case 8:
            seqStr = "Ⅷ"
        case 9:
            seqStr = "Ⅸ"
        case 10:
            seqStr = "Ⅹ"
        case 11:
            seqStr = "Ⅺ"
        case 12:
            seqStr = "Ⅻ"
        default:
            seqStr = "0"
        }
        
        super.init(up : title, sequence: sequence, seqString: seqStr, name: name, value: value)
    }
}
