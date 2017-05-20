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
    
    
    static var isDebug = false
    static let colorLog = ANSIColors.yellow
    let colorStandard = ANSIColors.white
    let colorError = ANSIColors.red
    let colorPublish = ANSIColors.cyan
    let colorNotice = ANSIColors.magenta
    let colorHelp = ANSIColors.green
    let colorInput = ANSIColors.white
    
    

    
    /* Input */
    
    // 유효한 입력을 받는 보조함수
    // 내가짠 함수가 위의 ray 에 있는거보다 더 효윻ㄹ적인 듯~ 2017. 5. 20
    func getInput(_ prefix:String = "") -> String {
        var goon = true
        while goon {
            let str = prefix != "" ? "> \(prefix) $ " : "$ "
            if ConsoleIO.isDebug{
                print(str, terminator: "")
            } else {
                print(colorInput+str, terminator: "")
            }
            
            let inputRaw = readLine()
            
            guard let inputRawWrapped = inputRaw else {
                writeMessage("유효하지 않은 입력")
                continue
            }
            
            let input = inputRawWrapped.trimmingCharacters(in: .illegalCharacters)
            
            goon = false
            return input
        }
    }

    
    func getIntstruction(_ value : String) -> (instruction: InstMain, value:String) {
        return (InstMain(value),value)
    }
    
    func getKey(_ value : String) -> (instruction: InstKey, value:String) {
        return (InstKey(value),value)
    }
    
    func getPublish(_ value : String) -> (instruction: InstPublish, value:String) {
        return (InstPublish(value),value)
    }
    
    func getSave(_ value : String) -> (instruction: InstSave, value:String) {
        return (InstSave(value),value)
    }
    
    func getInstGoon(_ value : String) -> (instruction: InstGoon, value:String) {
        return (InstGoon(value),value)
    }
    
    
    /* Output */
    
    func getHelp(_ instruction : HelpInstruction) -> String {
        
        var values : [Any] = []
        
        switch instruction {
        case .InstMain:
            values = InstMain.allValues
        case .InstKey:
            values = InstKey.allValues
        case .InstPublish:
            values = InstPublish.allValues
        case .InstSave:
            values = InstSave.allValues
        case .InstGoon:
            values = InstGoon.allValues
        }
        
        var str = ""
        for (index,value) in values.enumerated() {
            if ConsoleIO.isDebug {
                if index == 0 {
                    str = "? \(value)"
                } else {
                    str = str + ", \(value)"
                }
            } else {
                if index == 0 {
                    str = "? \(value)"
                } else {
                    str = str + ", \(value)"
                }
            }
        }
        return str
    }
    
    
    func writeMessage(to: OutputType = .standard, _ message: String = "") {
        switch to {
        case .input:
            if ConsoleIO.isDebug {
                print(message)
            } else {
                print(colorInput+message)
            }
        case .notice:
            if ConsoleIO.isDebug {
                print(message)
            } else {
                print(colorNotice+message)
            }
        case .standard:
            if ConsoleIO.isDebug {
                print(message)
            } else {
                print(colorStandard+message)
            }
        case .publish:
            if ConsoleIO.isDebug {
                print(" \(message)")
            } else {
                print(colorPublish+" \(message)")
            }
        case .error:
            // 어떤 원리로 폰트가 변화하는지 확인해야 한다. 2017. 5. 18.
            if ConsoleIO.isDebug {
                fputs("! \(message)\n", stderr)
            } else {
                fputs(colorError+"! \(message)\n", stderr)
            }
        }
    }
    
    
    
    func unkown(_ value: String, _ isMain : Bool = false) {
        if value != "" {
            writeMessage(to: .error, "\(value)은 알 수 없는 명령어")
            return
        } else {
            if isMain {
                return
            } else {
                writeMessage(to: .standard, "명령 종료")
                return
            }
        }
    }
    
    class func newLog(_ file : String) -> String {
        if isDebug{
            return "\(file) 시작 \(Date().HHmmSS)\n"
        } else {
            return colorLog + "\(file) 시작 \(Date().HHmmSS)\n"
        }
    }
    
    class func writeLog(_ log : String, funcName : String, outPut : String) -> String {
        if isDebug{
            return  log + "  \(funcName) : \(outPut)\n"
        } else {
            return colorLog + log + "  \(funcName) : \(outPut)\n"
        }
    }
    
    class func closeLog(_ log : String, file : String) -> String {
        if isDebug{
            return log + "\(file) 종료 \(Date().HHmmSS)\n"
        } else {
            return colorLog + log + "\(file) 종료 \(Date().HHmmSS)\n"
        }
    }
    
    
}

enum OutputType {
    case input
    case notice
    case standard
    case publish
    case error
}


// Color ouput with Swift command line tool
// http://stackoverflow.com/questions/27807925/color-ouput-with-swift-command-line-tool
enum ANSIColors: String {
    case black = "\u{001B}[0;30m"
    case red = "\u{001B}[0;31m"
    case green = "\u{001B}[0;32m"
    case yellow = "\u{001B}[0;33m"
    case blue = "\u{001B}[0;34m"
    case magenta = "\u{001B}[0;35m"
    case cyan = "\u{001B}[0;36m"
    case white = "\u{001B}[0;37m"
    
    func name() -> String {
        switch self {
        case .black: return "Black"
        case .red: return "Red"
        case .green: return "Green"
        case .yellow: return "Yellow"
        case .blue: return "Blue"
        case .magenta: return "Magenta"
        case .cyan: return "Cyan"
        case .white: return "White"
        }
    }
    
    static func all() -> [ANSIColors] {
        return [.black, .red, .green, .yellow, .blue, .magenta, .cyan, .white]
    }
}

func + (left: ANSIColors, right: String) -> String {
    return left.rawValue + right
}
