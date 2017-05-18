//
//  ConsoleIO.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 18..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

// Command Line Programs on macOS Tutorial
// https://www.raywenderlich.com/128039/command-line-programs-macos-tutorial



class ConsoleIO {
    var isDebug = false
    
    // 헬프
    func printHelp(_ instruction : Instruction) {
        
        var values : [Any] = []
            
        switch instruction {
        case .InstMain:
            values = InstMain.allValues
        case .InstKey:
            values = InstKey.allValues
        case .InstShow:
            values = InstShow.allValues
        }
        
        var str = ""
        for (index,value) in values.enumerated() {
            if isDebug {
                if index == 0 {
                    str = "? \(value)"
                } else {
                    str = str + ", \(value)"
                }
            } else {
                if index == 0 {
                    str = "\u{001B}[;2m? \(value)"
                }
                str = str + ", \u{001B}[;2m\(value)"
            }
        }
        print(str)
    }
    
    func getIntstruction(_ value : String) -> (instruction: InstMain, value:String) {
        return (InstMain(value),value)
    }
    
    func getKey(_ value : String) -> (instruction: InstKey, value:String) {
        return (InstKey(value),value)
    }
    
    func getShow(_ value : String) -> (instruction: InstShow, value:String) {
        return (InstShow(value),value)
    }
    
    
    func writeMessage(_ message: String, to: OutputType = .publish) {
        switch to {
        case .standard:
            if isDebug {
                print("> \(message)")
            } else {
                print("\u{001B}[;m\(message)")
            }
        case .publish:
            if isDebug {
                print(" \(message)")
            } else {
                print("\u{001B}[0;21m\(message)")
            }
        case .error:
            // 어떤 원리로 폰트가 변화하는지 확인해야 한다. 2017. 5. 18.
            if isDebug {
                fputs("! \(message)\n", stderr)
            } else {
                fputs("\u{001B}[0;31m\(message)\n", stderr)
            }
        }
    }
    
    
    func getInput(_ prefix:String = "") -> String {
        
        let keyboard = FileHandle.standardInput
        
        if isDebug{
            print("\(prefix)$ ", terminator: "")
        } else {
            print("\u{001B}[;91m\(prefix)$ ", terminator: "")
        }
        
        let inputData = keyboard.availableData
        
        let strData = String(data: inputData, encoding: String.Encoding.utf8)!
        
        return strData.trimmingCharacters(in: CharacterSet.newlines)
    }
    
    func unkown(_ value: String) {
        if value != "" {
            if isDebug {
                fputs("! \(value)은 알 수 없는 명령어\n", stderr)
            } else {
                fputs("\u{001B}[0;31m\(value)은 알 수 없는 명령어\n", stderr)
            }
        }
    }
}

enum OutputType {
    case standard
    case publish
    case error
}
