//
//  GeneratorViewModeEnum.swift
//  TestGeneratorIOS
//
//  Created by Masterbuilder on 2023/06/23.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import Foundation

enum GeneratorViewMode : Equatable {
    case publish(showAnswer: Bool = false)

    case test(oneByOne: Bool = false)
    
    case result(showWrongOnly: Bool = false)

    mutating func toggleShowAnswer() {
            switch self {
            case .publish(let showAnswer):
                self = .publish(showAnswer: !showAnswer)
            default:
                break
            }
        }
    
    mutating func toggleOneByOne() {
            switch self {
            case .test(let oneByOne):
                self = .test(oneByOne: !oneByOne)
            default:
                break
            }
        }
    
    mutating func toggleShowWrongOnly() {
            switch self {
            case .result(let showWrongOnly):
                self = .result(showWrongOnly: !showWrongOnly)
            default:
                break
            }
        }
}



