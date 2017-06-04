//
//  Division.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 6. 7..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class Division: BookStructure {
    var chapters : [Chapter] = []
    
    init(book : Book, sequence : Int, name : String, value : String) {
        
        super.init(up : book, sequence: sequence, seqString: sequence.description+"편", name: name, value: value)
        
    }
}
