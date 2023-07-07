//
//  Generator.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 4..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class Generator : ObservableObject, Identifiable {
    var id = UUID()
    @Published var key : String
    
    @Published var solvers : [Solver] //기존문제와 같으나, 만약 일부문제만 풀고 종료했다면, 그 문제만 가지게 되는 가장 중요한 배열입니다. .result에서의 관리 편의를 위해 두 개의 배열로 나누었습니다. 2023. 6. 25.
    @Published var solversOriginal : [Solver] //기존문제
//    간단히 구현하기 위해 여러가지 어래이 정의를 생각했으나, 여러 컴퓨팅자원낭비인 거 같아서, 파라미터를 이용한 제어를 구현하려 함 (-) 2023. 6. 21.
//    @Published var solversShuffled : [Solver]() //기존문제 순서 및 선택지 변경
//    @Published var solversChanged : [Solver] //변경문제
//    @Published var solversChnagedShffled : [Solver]() //기존문제 순서 및 선택지 변경

    
    @Published var solvedCount = 0

    var date : Date
    var timeConsume: TimeInterval = 0.0 // 시험 시간을 관리하는 변수 추가 2023. 6. 23.
    var teimeConsumeString: String = "00:00:00"
    
//    // 2023. 6. 19. swiftUI에서 코딩실력 미숙(-)으로 필요하다보니 추가로 test를 속성으로 추가하였다고 생각했습니다.,
//    2023. 6. 23. 그러나 스위프트유아이의 정신은,데이터 처리는 모델에서 이루어지는 것이므로, 이 변수를 여기에 정의하는 것은 매우 적절합니다.
    var test : Test? = nil // Test 클래스의 중요성에도 불구하고, 단순 참고용, 혹은 간단하게 초기화하기 위한 변수에 불과합니다. 왜나면 Generator는 Test의 래핑 클래스로 Question들의 모음 대신 Solver들의 모음을 관리하는 클래스이기 때문입니다.
    var changed : Bool = false
    var shuffled : Bool = false
    
    // Generator는 단순히 래핑이 목정이다보니, 초기화 함수는 불필요하나,
    // 그러나 유연한 제네레이터 생성 편의를 위해 초기화 함수를 만들기 시작하였습니다. 2023. 6. 20.
    init() {
        key = ""
        
        solvers = []
        solversOriginal = []
        
        date = Date()
    }
    
    // Test를 받을 경우 생성하는 초기화함수로, 기존 시험이력에서 제네레이터를 생성하기에 매우 편리합니다.
    convenience init(test : Test, gonnaChange: Bool, gonnaShuffle: Bool) {
        self.init()
        self.test = test
        
        // test.questions 배열에서 각 질문(que)에 대해 Solver 인스턴스를 생성하고, solvers와 solversChanged 배열에 추가하는 코드를 간결하게 만들려면 map 함수를 사용할 수 있습니다.
        solvers = test.questions.map { Solver($0, gonnaChange: gonnaChange) }
        if gonnaChange {
            self.changed = true
        }
        
        // gonnaShuffle이 참일 경우, 문제의 순서를 섞습니다.
        if gonnaShuffle {
            solvers = solvers.shuffled()
            shuffled = true
        }
        solversOriginal = solvers
        
        // 제네레이터의 문제번호와 테스트 문제번호를 일치시켜줍니다.
        // 만약 테스트의 questions 어레이 순서가 문제순서와 다를 경우 문제될 수 있어 수정 필요할 수 있습니다. 2023. 6. 24. (-)
        for (i, solver) in solvers.enumerated() {
            solver.number = i + 1
        }
        
        self.key = test.getKeySting()
}
    
    // solvrs 중 푼 문제만 찾아주는 함수
    func getSolved() -> [Solver] {
        let solved = solvers.filter { $0.isRight != nil }
        return solved
    }
    
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

