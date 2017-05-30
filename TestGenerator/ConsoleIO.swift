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
    let colorImportant = ANSIColors.cyan
    let colorError = ANSIColors.red
    let colorTitle = ANSIColors.green
    let colorPublish = ANSIColors.cyan
    let colorNotice = ANSIColors.magenta
    let colorAlert = ANSIColors.red
    let colorHelp = ANSIColors.blue
    let colorInput = ANSIColors.white
    
    

    
    /* Input */
    
    // 유효한 입력을 받는 보조함수
    // 내가짠 함수가 위의 ray 에 있는거보다 더 효윻ㄹ적인 듯~ 2017. 5. 20
    func getInput(_ prefix:String = "", _ plainMode : Bool = false) -> String {
        var goon = true
        while goon {
            if !plainMode {
                let str = prefix != "" ? "> \(prefix) $ " : "$ "
                if ConsoleIO.isDebug{
                    print(str, terminator: "")
                } else {
                    print(colorInput+str, terminator: "")
                }
            } else {
                if ConsoleIO.isDebug{
                    print(prefix, terminator: "")
                } else {
                    print(colorInput+prefix, terminator: "")
                }
            }
            
            let inputRaw = readLine()
            
            guard let inputRawWrapped = inputRaw else {
                writeMessage("유효하지 않은 입력")
                continue
            }
            
            let input = inputRawWrapped.trimmingCharacters(in: .illegalCharacters)
            
            goon = false
            return input.precomposedStringWithCompatibilityMapping
        }
    }
    
    func checkNumberRange(prefix: String, min : Int, max: Int?) -> Int {
        let input = getInput(prefix)
        let number = Int(input)
        
        if number == nil {
            writeMessage(to: .error, "숫자를 입력하세요")
            return checkNumberRange(prefix: prefix, min : min, max: max)
        }
        
        if max != nil {
            if number! < min || number! > max! {
                    writeMessage(to: .error, "범위에 맞는 숫자를 입력하세요")
                    return checkNumberRange(prefix: prefix, min : min, max: max)
            }
        } else {
            if number! < min {
                writeMessage(to: .error, "정확한 숫자를 입력하세요")
                return checkNumberRange(prefix: prefix, min : min, max: max)
            }
        }
        
        return number!
    }

    
    func getInstMain(_ value : String) -> (instruction: InstMain, value:String) {
        return (InstMain(value),value)
    }
    
    func getKey(_ value : String) -> (instruction: InstKey, value:String) {
        return (InstKey(value),value)
    }
    
    func getQuestionsGet(_ value : String) -> (instruction: InstQuestionsGet, value:String) {
        return (InstQuestionsGet(value),value)
    }
    
    func getSave(_ value : String) -> (instruction: InstSave, value:String) {
        return (InstSave(value),value)
    }
    
    func getInstGoon(_ value : String) -> (instruction: InstGoon, value:String) {
        return (InstGoon(value),value)
    }
    
    func getInstQuestion(_ value : String) -> (instruction: InstQuestion, value:String) {
        return (InstQuestion(value),value)
    }
    
    func getInstSolveType(_ value : String) -> (instruction: InstSolveType, value:String) {
        return (InstSolveType(value),value)
    }
    
    func getEdit(_ value : String) -> (instruction: InstEdit, value:String) {
        return (InstEdit(value),value)
    }
    
    
    /* Output */
    
    func getHelp(_ instruction : HelpInstruction) -> String {
        
        var values : [Any] = []
        
        switch instruction {
        case .InstMain:
            values = InstMain.allValues
        case .InstKey:
            values = InstKey.allValues
        case .InstQuestionsGet:
            values = InstQuestionsGet.allValues
        case .InstSave:
            values = InstSave.allValues
        case .InstGoon:
            values = InstGoon.allValues
        case .InstQuestion:
            values = InstQuestion.allValues
        case .InstSolveType:
            values = InstSolveType.allValues
        case .InstEdit:
            values = InstEdit.allValues
        }
        
        var str = ""
        for (index,value) in values.enumerated() {
            if index == values.count - 1 {
                str = str + ", \(value) ? "
            } else if index == 0 {
                str = "\(value)"
            } else {
                str = str + ", \(value)"
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
                print("- \(message)")
            } else {
                print(colorNotice+"- \(message)")
            }
        case .alert:
            if ConsoleIO.isDebug {
                print(message)
            } else {
                print(colorAlert+message)
            }
        case .standard:
            if ConsoleIO.isDebug {
                print(message)
            } else {
                print(colorStandard+message)
            }
        case .important:
            if ConsoleIO.isDebug {
                print(message)
            } else {
                print(colorImportant+message)
            }
        case .title:
            if ConsoleIO.isDebug {
                print(" \(message)")
            } else {
                print(colorTitle+" \(message)")
            }
        case .publish:
            if ConsoleIO.isDebug {
                print("  \(message)")
            } else {
                print(colorPublish+"  \(message)")
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
    case alert
    case standard
    case important
    case title
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
