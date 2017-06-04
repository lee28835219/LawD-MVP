//
//  SeqRoundNumber.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 6. 7..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class SeqRoundNumber: BookStructure {
    
    init(singleBracket: SingleBracket, sequence : Int, name : String, value : String) {
        
        super.init(up: singleBracket, sequence: sequence, seqString: sequence.roundInt, name: name, value: value)
    }
}
