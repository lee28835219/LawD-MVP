//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"




let string = "제3회 법조윤리시험 정답가안 "
if let number = Int(string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
    // Do something with this number
    print(number)
}