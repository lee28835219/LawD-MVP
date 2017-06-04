//
//  Title.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 6. 7..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class Title: BookStructure {
    
    init(chapter : Chapter, sequence : Int, name : String, value : String) {
        
        super.init(up: chapter, sequence: sequence, seqString: sequence.description+"절", name: name, value: value)
        
    }
}
