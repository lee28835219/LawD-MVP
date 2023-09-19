//
//  QuestionData.swift
//  LawD MVP
//
//  Created by Masterbuilder on 2023/09/19.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import Foundation

class QuestionData : Encodable {
    let id : UUID
    
    init(id: UUID) {
        self.id = id
    }
}
