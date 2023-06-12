//
//  Generator.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 4..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class Generator : ObservableObject {

    let key = ""
    
    @Published var solvers = [Solver]()
    @Published var solversChanged = [Solver]()

    var testDate : Date? = nil
    var timeConsume : Int? = nil
    
    // Generator는 단순히 래핑이 목정이다보니, 초기화 함수는 불필요함.
    
//    // 2023. 6. 19. swiftUI에서 코딩실력 미숙(-)으로 필요하다보니 추가로 test를 속성으로 추가함.
//    let test : Test? = nil
    
    func seperateWorngSolve() -> (correct : [Solver], wrong : [Solver]) {
        
        let wrong = solvers.filter(){$0.isRight == false}
        let right = solvers.filter(){$0.isRight == true}
        
        return (right,wrong)
    }
    
    func shuffleSolvers() {
        solvers.shuffle()
    }
    
    func getSolveDurationAverage() -> Double? {
        let solveds = solvers.filter(){$0.isRight != nil}
        
        if solveds.count == 0 {
            return nil
        }
        
        var sum : Double = 0
        for solved in solveds {
            if solved.duration == nil {
                fatalError("\(solved.question.key) duration은 푼 문제에 대해서 nil일 수 없음")
            }
            sum = sum + solved.duration!
        }
        
        return sum / Double(solveds.count)
    }
    
    
    func getTestinSolvers() -> [Test] {
        let question = getQustioninSovers()
        return question.compactMap { $0.test }.unique
//        2023. 6. 15.
//        위의 코드에서 compactMap { $0.test }를 사용하여 question 배열의 각 요소의 test 속성을 추출하고, nil이 아닌 값을 반환합니다. 이후에 unique를 수행하여 중복된 값을 제거한 최종 결과를 얻습니다.
//
//        compactMap은 배열에서 옵셔널 값을 추출하고, nil이 아닌 값을 반환하는 동작을 수행합니다. 따라서 question 배열의 각 요소에서 test 값을 추출하고, nil이 아닌 경우에만 반환합니다. nil인 경우에는 해당 값을 제외하게 됩니다.
//
//        이를 통해 test가 nil인 경우 해당 값을 제외하고 중복을 제거한 최종 결과를 얻을 수 있습니다.
    }
    
    func getQustioninSovers() -> [Question]{
        return solvers.map(){$0.question}.unique
    }
}

// Does there exist within Swift's API an easy way to remove duplicate elements from an array?
// http://stackoverflow.com/questions/25738817/does-there-exist-within-swifts-api-an-easy-way-to-remove-duplicate-elements-fro
// 담에 공부하자 2017. 5. 21. (-)
// 챗지피티는 Array(Set(array))를 추천하는 듯 함. 2023. 6. 17.
// 주어진 코드의 경우, unique라는 이름의 계산된 속성으로 배열을 확장하여 사용합니다. 내부적으로 Set을 사용하여 중복을 제거하고, arrayOrdered라는 배열을 사용하여 중복이 제거된 요소를 유지하며 순서대로 저장합니다.
// 제안한 방법은 배열을 변환하지 않고 기존 배열의 순서를 유지하면서 중복을 제거하는 것과는 다릅니다. 대신, 배열의 순서를 유지하지 않고 중복이 제거된 요소를 반환합니다. 따라서 결과적으로는 중복을 제거하는 역할은 수행하지만, 요소의 순서가 중요한 경우에는 unique 속성이 아닌 Array(Set(array))와 같은 방법을 사용하는 것이 좋습니다.
extension Array where Element:Hashable {
    var unique: [Element] {
        var set = Set<Element>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(value) {
                set.insert(value)
                arrayOrdered.append(value)
            }
        }
        
        return arrayOrdered
    }
}

