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
    
//    콘솔 로그는 노란색으로 작성됨
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
    /* Input */
    /* Input */
    
//     readLine()함수로 유효한 콘솔 입력을 받는 보조함수
//     내가짠 함수가 위의 ray 에 있는거보다 더 효윻ㄹ적인 듯~ 2017. 5. 20
    func getInput(_ prefix:String = "", _ plainMode : Bool = false) -> String {
//        var goon = true
//        챗지피티 goon 설명 2023. 6. 17.
//        `goon` 변수는 `getInput()` 함수 내에서 반복문을 제어하는 데 사용되는 변수입니다. `goon` 변수의 역할은 다음과 같습니다:
//
//        1. 초기값으로 `true`를 설정하여 반복문을 처음부터 실행하도록 합니다.
//        2. 반복문의 조건으로 사용되며, `goon` 값이 `true`인 경우에만 반복문이 실행됩니다.
//        3. 사용자로부터 유효한 입력을 받으면 `goon` 값을 `false`로 변경하여 반복문을 종료합니다.
//
//        즉, `goon` 변수는 사용자로부터 유효한 입력을 받을 때까지 반복적으로 입력을 요청하기 위한 메커니즘을 구현하기 위해 사용됩니다. 반복문을 제어함으로써 사용자가 올바른 입력을 제공할 때까지 프롬프트를 표시하고 입력을 요청합니다.
//
//        `goon` 변수는 `getInput()` 함수 내에서만 사용되고, 해당 함수의 내부 동작을 조정하는 데 필요한 임시적인 변수입니다. 함수 외부에서는 `goon` 변수를 사용할 필요가 없습니다.
//        while goon {
//            프롬프트 출력 부분을 담당
//            getInput() 함수는 두 가지 모드로 동작할 수 있습니다: 일반 모드(normal mode)와 평문 모드(plain mode).
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
            
//            표준 입력(Standard Input)으로부터 한 줄의 문자열을 읽어와 처리하는 부분
            guard let inputRawWrapped = readLine() else {
                writeMessage("유효하지 않은 입력")
                exit(0)
//                If EOF has already been reached when readLine() is called, the result is nil.
//                극단적인 에러처리이나 이를 대체할 다른 방법을 찾을 수 없다. 2023. 6. 12.
            }
            let input = inputRawWrapped.trimmingCharacters(in: .illegalCharacters) //trimmingCharacters(in:)은 Swift의 문자열(String) 타입에 기본적으로 제공되는 표준 함수입니다. 이 함수는 문자열의 앞뒤에 있는 특정 문자 집합을 제거하여 새로운 문자열을 반환하는 역할을 합니다.
            
//            goon = false
            return input.precomposedStringWithCompatibilityMapping //precomposedStringWithCompatibilityMapping은 String의 인스턴스 메서드로, 문자열에 있는 유니코드 조합 문자를 정준 분해(Decomposed Normalization Form D)된 문자열로 변환하는 기능을 제공합니다.
            
//        }
    }
    
//    `getValidNumber` 함수는 사용자로부터 입력을 받아 유효한 숫자를 반환하는 함수입니다. 이 함수를 사용하면 `prefix` 문자열을 출력한 후 사용자로부터 숫자를 입력받아, 입력이 유효한 범위 내에 있을 때까지 계속해서 입력을 요청할 수 있습니다.
    func getValidNumber(prefix: String, min : Int, max: Int?) -> Int? {
        let input = getInput(prefix+", stop[]")
        
        if input.count == "".count {
            return nil
        }
        
        let number = Int(input)
        
        if number == nil {
            writeMessage(to: .error, "숫자를 입력하세요")
            return getValidNumber(prefix: prefix, min : min, max: max)
        }
        
        if max != nil {
            if number! < min || number! > max! {
                    writeMessage(to: .error, "범위에 맞는 숫자를 입력하세요")
                    return getValidNumber(prefix: prefix, min : min, max: max)
            }
        } else {
            if number! < min {
                writeMessage(to: .error, "정확한 숫자를 입력하세요")
                return getValidNumber(prefix: prefix, min : min, max: max)
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
    /* Output */
    /* Output */
    
//    getHelp 함수는 HelpInstruction 열거형에 따라 도움말 정보를 반환하는 함수입니다. getHelp 함수는 HelpInstruction에 따라 도움말 정보를 동적으로 생성하여 반환합니다. 이를 통해 사용자에게 해당 도움말을 제공할 수 있습니다.
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
    
//    `writeMessage` 함수는 출력 메시지를 지정된 출력 유형에 따라 터미널에 출력하는 역할을 수행합니다. 아래는 함수의 동작을 설명한 내용입니다:
//
//    - `to` 매개변수는 출력 유형을 나타내는 `OutputType` 열거형 값을 기본값으로 가집니다.
//    - `message` 매개변수는 출력할 메시지를 나타냅니다.
//    - `switch` 문을 사용하여 `to` 값에 따라 출력을 수행합니다.
//      - `.input` 유형의 경우, 디버그 모드 여부를 확인하여 색이 지정된 문자열 또는 일반 문자열로 메시지를 출력합니다.
//      - `.notice`, `.alert`, `.standard`, `.important`, `.title`, `.publish` 유형의 경우, 디버그 모드 여부를 확인하여 색이 지정된 문자열로 메시지를 출력합니다.
//      - `.error` 유형의 경우, 디버그 모드 여부를 확인하여 색이 지정된 문자열 또는 일반 문자열로 메시지를 출력합니다.
//    - 출력은 `print` 함수 또는 `fputs` 함수를 사용하여 터미널에 이루어집니다.
//
//    이 함수를 사용하면 다양한 출력 유형에 따라 메시지를 색상으로 강조하여 터미널에 출력할 수 있습니다.
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
    
//    unknown 함수는 알 수 없는 명령어를 처리하기 위한 함수입니다.
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
    
//    세 개의 메서드는 로그 작업을 수행하는 정적 메서드입니다. 이 세 가지 메서드를 사용하여 로그 작업을 수행하고, 필요한 경우 색상을 지정하여 출력할 수 있습니다.
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
//위의 코드는 `ANSIColors`라는 열거형을 정의하는 부분입니다. 이 열거형은 ANSI 컬러 코드를 나타내는 문자열 값을 각각의 케이스에 연결하여 정의합니다. 각 케이스는 해당 색상에 대한 ANSI 컬러 코드를 포함합니다.
//연관 값을 사용하여 색상 이름을 반환하는 `name()` 메서드와 모든 색상 케이스를 배열로 반환하는 `all()` 메서드도 있습니다.
//이 열거형을 사용하면 텍스트를 출력할 때 ANSI 컬러 코드를 사용하여 색상을 변경할 수 있습니다. 예를 들어, `.red` 케이스를 선택하면 텍스트가 빨간색으로 출력됩니다.
//그리고 콘솔 환경에서 NSAttributedString을 사용하여 색상을 적용하는 것은 어려울 수 있습니다. NSAttributedString은 주로 GUI 환경에서 텍스트 스타일링을 위해 사용되며, 텍스트 렌더링을 담당하는 시스템 프레임워크와 밀접하게 연결되어 있습니다. 콘솔 환경에서 ANSI 컬러 코드를 직접 사용하는 것이 간단하고 효과적입니다. ANSI 컬러 코드를 사용하면 텍스트의 색상을 변경하고 스타일을 지정할 수 있습니다.
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
// func +는 `ANSIColors` 열거형 값과 문자열을 결합하여 ANSI 컬러 코드를 생성하는 연산자 오버로딩 함수입니다. 이 함수는 `left`에 해당하는 `ANSIColors` 열거형 값을 가져와 해당 색상의 ANSI 코드와 `right` 문자열을 결합하여 색상이 적용된 문자열을 반환합니다.
//예를 들어, 다음과 같이 사용할 수 있습니다:
//    let redText = ANSIColors.red + "Red Text"
//    print(redText)
//위의 코드는 "Red Text"라는 문자열을 빨간색으로 출력합니다. `ANSIColors.red`는 빨간색에 해당하는 ANSI 컬러 코드이며, 연산자 오버로딩 함수를 통해 문자열과 결합됩니다.
//이러한 연산자 오버로딩을 사용하면 색상이 적용된 텍스트를 더 쉽게 생성할 수 있습니다.
func + (left: ANSIColors, right: String) -> String {
    return left.rawValue + right
}
