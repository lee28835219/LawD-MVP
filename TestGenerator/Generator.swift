//
//  Generator.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 4..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class Generator {
    
    var solvers = [Solver]()
    var testDate : Date? = nil
    var timeConsume : Int? = nil
    
    
    func seperateWorngSolve() -> (correct : [Solver],wrong : [Solver]) {
        let wrong = solvers.filter(){$0.isRight == false}
        let right = solvers.filter(){$0.isRight == true}
        
        
        return (right,wrong)
    }
    
    func shuffleSolvers() {
        solvers.shuffle()
    }
    
    func getTestinSolvers() -> [Test] {
        let question = getQustioninSovers()
        return question.map(){$0.test}.unique
    }
    
    func getQustioninSovers() -> [Question]{
        return solvers.map(){$0.question}.unique
    }
}
