//
//  Solver+Extension.swift
//  TestGenerator
//
//  Created by Masterbuilder on 2023/06/17.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import Foundation

//http://stackoverflow.com/questions/24026510/how-do-i-shuffle-an-array-in-swift
//How do I shuffle an array in Swift?
//담에 구조를 공부합시다. 2017. 4. 8.
extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            self.swapAt(firstUnshuffled, i)
//            swap(&self[firstUnshuffled], &self[i]) 2023. 6. 1.
        }
    }
}
extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}

//Creating random Bool in Swift 2
//http://stackoverflow.com/questions/34240931/creating-random-bool-in-swift-2
//Swift 4.2 이상에서는 Bool.random() 함수를 사용하는 대신 Bool.randomElement() 함수를 사용할 수 있습니다. 이 함수는 Bool 타입의 배열에서 임의의 요소를 반환합니다. 따라서, 배열이 아닌 단일 Bool 값에 대해서도 사용할 수 있습니다.
//extension Bool {
//    static func random() -> Bool {
//        return arc4random_uniform(2) == 0
//    }
//}
