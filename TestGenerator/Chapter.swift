//
//  Chapter.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 6. 7..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class Chapter: BookStructure {
    
    init(division : Division, sequence : Int, name : String, value : String) {
        super.init(up: division, sequence: sequence, seqString: sequence.description+"장", name: name, value: value)
    }
}
