//
//  QShufflingManager.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 4..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class QShufflingManager {
    let question : Question
    //초기화 단계에서 꼭 정답의 존재를 확인해야 함
    var answerSelectionModifed : Selection
    
    init?(question: Question) {
        self.question = question
    }
    
}
