//
//  Book.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 6. 7..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class Book: BookStructure {
    
    init(up: BookStructure?, sequence: Int, name: String, value: String) {
        super.init(up: up, sequence: sequence, seqString: sequence.description, name: name, value: value)
    }
}
