//
//  SeqNumber.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 6. 7..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class SeqNumber: BookStructure {
    init(roman: Roman, sequence : Int, name : String, value : String) {
        
        super.init(up: roman,sequence: sequence, seqString: sequence.description, name: name, value: value)
    }
}
