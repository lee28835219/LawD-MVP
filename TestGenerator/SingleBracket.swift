//
//  SingleBracket.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 6. 7..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class SingleBracket: BookStructure {
    
    init(doubleBracket: DoubleBracket, sequence : Int, name : String, value : String) {
        
        super.init(up: doubleBracket, sequence:  sequence, seqString:sequence.description+")", name: name, value: value)
    }
}
