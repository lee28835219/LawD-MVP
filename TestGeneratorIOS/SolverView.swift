//
//  SolverView.swift
//  TestGeneratorIOS
//
//  Created by Masterbuilder on 2023/06/17.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import SwiftUI

struct SolverView: View {
    let solver: Solver
    
    @Binding var solved : Int
    
//    출력환경을 잡아주는 파라미터들입니다.
    @Binding var publishMode : Bool
    
    @Binding var showAnswer : Bool
    
    @Binding var showResult : Bool
    
    @State private var selectedNumber : Int?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                //            문제의 질문과 선택지를 보여주는 가장 기본적인 뷰입니다.
                Text("문. \(solver.question.number) \(solver.question.content)")
                    .font(.headline)
                    .foregroundColor(getTextColor(question: solver.question, selectedNumber: selectedNumber, showResult: showResult))
                    .onTapGesture {
                        print("문. \(solver.question.number)를 선택함.")
//                        selectedNumber = nil
//                        showAnswer = false
//                        showResult = false
                        if selectedNumber != nil {
                            selectedNumber = nil
                            solved = solved - 1
                        }
                    }
                
                ForEach(solver.question.selections.indices) { index in let selection = solver.question.selections[index]
                    StatementView(statement: selection, showNumber: selection.number)
                    //                        사용자의 탭을 처리하는 구문으로, publishMode일 경우 작동하지 않습니다.
                        .onTapGesture {
                            if !publishMode {
                                //                            showAnswer = true
                                selectedNumber = index + 1
                                if let selectedNumber = selectedNumber {
                                    solver.date = Date()
                                    if selectedNumber == solver.question.answer {
                                        print("[O] 문. \(solver.question.number)에서 \(selection.number.roundInt), 즉 \(selectedNumber)를 선택하였는데, 이는 정답임.")
                                        solver.isRight = true
                                        solved = solved + 1
                                    } else {
                                        print("[X] 문. \(solver.question.number)에서 \(selection.number.roundInt), 즉 \(selectedNumber)를 선택하였는데, 이는 오답임.")
                                        solver.isRight = false
                                        solved = solved + 1
                                    }
                                } else {
                                    print("선택된 번호가 없습니다.")
                                }
                            }
                        }
                        .foregroundColor(selectedNumber == index + 1 ? .blue : .primary)
                    
                }
                
                //            문제를 보여줄 떄 정답을 같이 보여줄 수 있는 기능입니다.
                //            보여줄 때 레이아웃이 가운데로 몰리는 버그있어 수정 필요 2023. 6. 16. (+)
                if showAnswer {
                    Spacer()
                    VStack {
                        HStack {
                            Text("[정답]")
                                .font(.headline)
                            Spacer()
                        }
                        
                        StatementView(statement: solver.question.answerSelection!, showNumber: solver.question.answer)
                            .foregroundColor(getTextColor(question: solver.question, selectedNumber: solver.question.answer, showResult: showResult))
                    }
                }
                
                //            문제를 보여줄 때 Solver의 결과를 보여줄 수 있는 기능입니다.
                if showResult {
                    Spacer()
                    VStack {
                        HStack {
                            Text("[풀이결과]")
                                .font(.headline)
                            Spacer()
                        }
                        
                        StatementView(statement: Statement(revision: 0, key: "", question: solver.question, content: getResultStr()), showNumber: nil)
                            .foregroundColor(getTextColor(question: solver.question, selectedNumber: selectedNumber, showResult: showResult))

                    }
                }
                
                Spacer()
                
            }
        }
    }
    
//    선택한 선택지의 정답여부를 시각적으로 보여주기 위해 작성했습니다.
//    아래 코드는 selectedNumber가 nil인 경우 기본 폰트 색상인 .primary를 반환하고, selectedNumber가 1인 경우 녹색인 .green을 반환하며, 그 외의 숫자일 경우 빨간색인 .red를 반환합니다.
    private func getTextColor(question: Question, selectedNumber: Int?, showResult: Bool) -> Color {
        if showResult {
            if let selectedNumber = selectedNumber {
                if selectedNumber == question.answer {
                    return .green
                } else {
                    return .red
                }
            } else {
                return .primary
            }
        } else {
            return .primary
        }
    }
    
    private func getResultStr() -> String {
        let str : String
        switch solver.isRight {
            case true:
                str = "(O) 맞습니다!"
            case false:
            if let selectedNumber = selectedNumber {
                        str = "(X) 정답은 \(solver.question.answer.roundInt)이나 \(selectedNumber.roundInt)을(를) 선택하여 틀렸습니다."
                    } else {
                        str = "(X) 정답은 \(solver.question.answer.roundInt)이나 선택하지 않아 틀렸습니다."
                    }
            case nil:
                str = "(-) 풀지않은 문제입니다."
            case .some(_):
                fatalError("solver.isRight는 .some일 수 없음.")
        }
        return str
    }
}

//struct SolverView_Previews: PreviewProvider {
//    @State static var solved : Int = 0
//    
//    @State static var publishMode = false
//    
//    @State static var showAnswer = true
//    @State static var showResult = true
//    
//    static var previews: some View {
//        let question = Question(revision: 0, test: nil, number: 1, questionType: .Select, questionOX: .Correct, content: "상계에 관한 설명 중 옳은 것은?", answer: 3)
//        
//        question.notContent = "상계에 관한 설명 중 옳지 않은 것은?"
//        question.contentNote = "(다툼이 있는 경우에는 판례에 의함)"
//        question.raw = "\n상계에 관한 설명 중 옳은 것은? (다툼이 있는 경우에는 판례에 의함)\n①고의의 불법행위로 인한 손해배상채권을 자동채권으로 하는 상계는 허용되지 않는다.\n②피용자의 고의의 불법행위로 인하여 사용자책임이 성립하는 경우, 사용자는 피해자의 사용자에 대한 손해배상채권을 수동채권으로 하여 상계할 수 있다.\n③채권의 일부양도가 이루어진 경우, 그 분할된 채권에 대하여 양도인에 대한 반대채권으로 상계하고자 하는 채무자는 양도인을 비롯한 각 분할채권자 중 어느 누구라도 상계의 상대방으로 지정하여 상계할 수 있다.\n④상대방이 제3자에 대하여 가지는 채권을 수동채권으로 하여 상계할 수 있다.\n⑤상계의 대상이 될 수 있는 자동채권과 수동채권이 서로 동시이행관계에 있다면 특별한 사정이 없는 한 상계가 허용되지 않는다.\n\n"
//        
//        let sel1 = Selection(revision: 0, question: question, number: 1, content: "고의의 불법행위로 인한 손해배상채권을 자동채권으로 하는 상계는 허용되지 않는다.")
//        sel1.notContent = "고의의 불법행위로 인한 손해배상채권을 수동채권으로 하는 상계는 허용되지 않는다."
//        
//        let sel2 = Selection(revision: 0, question: question, number: 2, content: "피용자의 고의의 불법행위로 인하여 사용자책임이 성립하는 경우, 사용자는 피해자의 사용자에 대한 손해배상채권을 수동채권으로 하여 상계할 수 있다.")
//        sel2.notContent = "피용자의 고의의 불법행위로 인하여 사용자책임이 성립하는 경우, 사용자는 피해자의 사용자에 대한 손해배상채권을 자동채권으로 하여 상계할 수 없다."
//        
//        let sel3 = Selection(revision: 0, question: question, number: 3, content: "채권의 일부양도가 이루어진 경우, 그 분할된 채권에 대하여 양도인에 대한 반대채권으로 상계하고자 하는 채무자는 양도인을 비롯한 각 분할채권자 중 어느 누구라도 상계의 상대방으로 지정하여 상계할 수 있다.")
//        sel3.notContent = "채권의 일부양도가 이루어진 경우, 그 분할된 채권에 대하여 양도인에 대한 반대채권으로 상계하고자 하는 채무자는 양도인을 비롯한 각 분할채권자 중 어느 누구라도 상계의 상대방으로 지정하여 상계할 수 없다."
//        
//        let sel4 = Selection(revision: 0, question: question, number: 4, content: "상대방이 제3자에 대하여 가지는 채권을 수동채권으로 하여 상계할 수 있다.")
//        sel4.notContent = "상대방이 제3자에 대하여 가지는 채권을 수동채권으로 하여 상계할 수 없다."
//        
//        let sel5 = Selection(revision: 0, question: question, number: 5, content: "상계의 대상이 될 수 있는 자동채권과 수동채권이 서로 동시이행관계에 있다면 특별한 사정이 없는 한 상계가 허용되지 않는다.")
//        sel5.notContent = "상계의 대상이 될 수 있는 자동채권과 수동채권이 서로 동시이행관계에 있다면 특별한 사정이 없는 한 상계가 허용된다."
//
//        
//        return SolverView(solver: Solver(question), solved: solved, publishMode: $publishMode, showAnswer: $showAnswer, showResult: $showResult)
//    }
//}
