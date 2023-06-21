//
//  SolverView.swift
//  TestGeneratorIOS
//
//  Created by Masterbuilder on 2023/06/17.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import SwiftUI

struct SolverView: View {
    @StateObject var solver: Solver
    
    @EnvironmentObject var generator : Generator
    @EnvironmentObject var setUP : SetUP

//    @Binding var solved : Int
    
//    출력환경을 잡아주는 파라미터들입니다.
//    @Binding var testMode : Bool
    @Binding var generatorViewMode : GeneratorViewMode
    
    var showAnswer : Bool = false
    var showResult : Bool = false
    
    @State private var selectedNumber : Int?
    
    var body: some View {
        ScrollView {
            // 문제의 질문과 선택지를 보여주는 가장 기본적인 뷰입니다.
            VStack(alignment: .leading) {
                // 질문
//                let questionNumber = solver.question.number // 제네레이터의 셔플 생성을 대비해 문제 번호를 논리적으로 가져오도록 수정 필요합니다. 2023. 6. 21. (+)
                let questionNumber = solver.number
                Text("문. \(questionNumber) \(solver.questionContent)")
                    .font(.headline)
//                    .foregroundColor(getTextColor(selectedNumber: selectedNumber))
                    .onTapGesture { // testMode가 꺼져있을 경우엔 selectedNumber가 nil일 수 밖에 없어 의미없지만, 켜져있다면 이 작업을 통해 사용자가 자신이 선택한 선택지를 취소할 수 있습니다.
                        if solver.chosenSelection != nil {
                            solver.chosenSelection = nil
                            print("문. \(solver.question.number)이 선택되어 사용자의 선택을 nil로 초기화함.")
                            
                            // solver에 래핑했던 사용자의 선택도 초기화해야 하므로, 이를 작성하였습니다. 추후 이 부분에 누락된 부분이 있는지 확인 필요합니다. (-) 2023. 6. 22.
                            solver.chosenSelectionNumber = nil
                            solver.chosenSelection = nil
                            solver.isRight = nil
                            solver.duration = nil
                            
                            // 이 부분은 코딩 능력 부족으로 단순하게 푼 문제수를 관리하는 것으로, 좀더 구조적이고 분석가능한 방식으로 수정할 필요가 매우 큽니다. (-) 2023. 6. 22.
                            if generator.solvedCount > 0 {
                                generator.solvedCount = generator.solvedCount - 1
                            }
                        }
                    }
                
                //선택지
                ForEach(Array(solver.selectionsContent.enumerated()), id: \.offset) { (index, selCon) in
                    // testMode일 때 선택지를 선택했을 경우 논리적 작업을 수행합니다. 그 내용의 가장 중요한 부분은 기존 nil이던 selectedSNumber를 사용자가 선택한 번호로 변경하는 것이며, 이를 이용해 뒤에서 사용한 구문을 통해 사용자가 선택한 선택지를 화면에 나타내 줄 수 도 있습니다.
                    VStack {
                        SelectionView(selectionContent: selCon, showNumber: index+1)
                        .environmentObject(generator)
                        .onTapGesture { if case .test = generatorViewMode
                            {
                            // 사용자가 선택한 선택지에 관한 정보를 solver로 래핑하여 저장하는 부분입니다.
                            solver.chosenSelectionNumber = index + 1
                            solver.chosenSelection = solver.selections[index]
                            if solver.chosenSelection == solver.answerSelectionModifed {
                                solver.isRight = true
                                print("[O] 사용자가 문. \(questionNumber)에서 정답(\((index+1).roundInt))을 선택하여 맞았음.")
                            } else {
                                solver.isRight = false
                                print("[X] 사용자가 문. \(questionNumber)에서 \((index+1).roundInt)를 선택했으나, 정답은 \(solver.ansSelNumber)이므로 틀렸음.")
                            }
                            
//                            solver.duration = solver.date - Date()   // 문제를 풀기 시작한 시간이어서 이곳에 넣기는 부적절합니다. 추후 한문제씩 푸는 기능을 추가할 때 이를 dl 곳에 넣어야 할 필요가 있습니다. (-) 2023. 6. 22.
                            
                            // 이 부분은 코딩 능력 부족으로 단순하게 푼 문제수를 관리하는 것으로, 좀더 구조적이고 분석가능한 방식으로 수정할 필요가 매우 큽니다. (-) 2023. 6. 22.
                            if selectedNumber == nil {
                                generator.solvedCount = generator.solvedCount + 1 // 푼 문제수를 관리하기 위해 제네레이터에서 래핑하는 푼 문제수 변수를 업데이트 합니다. 다만, 선택지를 변경해가며 여러번 누루는 경우를 방지하기 위해 selectedNumber가 nil이 아닐 경우에만 카운터를 올리고, 그 후 뒤에서 selectedNumber를 숫자로 업데이트 합니다.
                            }
                            selectedNumber = solver.chosenSelectionNumber
                        }
                        }
                        .foregroundColor(selectedNumber == index + 1 ? .blue : .primary) // 숫자가 입력된 selectedNumber를 이용해 사용자가 선택한 선택지를 화면에 나타내 주는 부분입니다.
                        // 숫자가 입력된 selectedNumber를 이용해 사용자가 선택한 선택지를 화면에 나타내 주는 기능에 추가하여 퍼블리쉬 모드 중 showAnswer가 참이면 선택지를 정오에 맞춰 변경해주는 기능을 추가해야 합니다. 2023. 6. 22. (-)
                    }
                }
                
                //            문제를 보여줄 떄 정답과 사용자가 선택한 선택지를 같이 보여줄 수 있는 기능입니다.
                //            보여줄 때 레이아웃이 가운데로 몰리는 버그있어 수정 필요 2023. 6. 16. (+)
                if case .result = generatorViewMode {
                    Spacer()
                    // selectedNumber가 있으면 사용자가 선택한 결과를 보여줍니다.
                    if let selectedNumber = selectedNumber {
                        VStack {
                            HStack {
                                Text("[선택한 답안지]")
                                    .font(.headline)
                                Spacer()
                            }
                            SelectionView(selectionContent: solver.selectionsContent[selectedNumber-1], showNumber: selectedNumber)
                                .foregroundColor(getTextColor(selectedNumber: selectedNumber))
                                       
                            HStack {
                                if let isRight = solver.isRight {
                                    if isRight {
                                        HStack {
                                            VStack {
                                                Image(systemName: "checkmark")
                                                Spacer()
                                            }
                                            Text("정답입니다!!!!")
                                            Spacer()
                                        }
                                        .foregroundColor(getTextColor(selectedNumber: selectedNumber))
                                    } else {
                                        VStack {
                                            HStack {
                                                VStack {
                                                    Image(systemName: "xmark")
                                                    Spacer()
                                                }
                                                Text("틀렸습니다.")
                                                Spacer()
                                            }
                                            .foregroundColor(getTextColor(selectedNumber: selectedNumber))
                                            Spacer()
                                            HStack {
                                                Text("[정답]")
                                                    .font(.headline)
                                                Spacer()
                                            }
                                            SelectionView(selectionContent: solver.ansSelContent, showNumber: solver.ansSelNumber)
                                                .foregroundColor(getTextColor(selectedNumber: solver.ansSelNumber)) // 좀더 안정적으로 적용 위해 해당 함수를 논리적으로 정합하게 수정필요합니다. 2023. 6. 23. (-)
                                        }
                                        
                                    }
                                } else {
                                    fatalError("selectedNumber가 없는데 isRight가 논리적으로 존재할 수 없음.")
                                }
                            }
                        }
                    }
                }
                
                // 정답은 result 모드에서는 항상 보여주기보다 문제 정오 여부에 따라 동적으로 보여줄지 정하는 게 좋을 것같아 주석처리합니다. 2023. 6. 22.
                // 다만, publish 모드의 경우 정답보는 것을 사용자가 원할 때 이를 보여줄 수 있도록 기능을 추가합니다.
                if generatorViewMode == GeneratorViewMode.publish(showAnswer: true) {
                    VStack {
                        Spacer()
                        HStack {
                            Text("[정답]")
                                .font(.headline)
                            Spacer()
                        }
                        SelectionView(selectionContent: solver.ansSelContent, showNumber: solver.ansSelNumber)
                            .foregroundColor(getTextColor(selectedNumber: selectedNumber))
                    }
                }
                
                if case .publish = generatorViewMode {
                    HStack {
                        Spacer()
                        Button(action: {
                            let newSolvers = solver.generateRandomSolvers(count: setUP.numberOfGenerateSolvers)
                            generator.solvers = newSolvers
                            generatorViewMode = .test()
                        }) {
                            HStack {
                                Image(systemName: "note.text.badge.plus") // 노트 아이콘 이미지
                                Text("문제생성")
                            }
                        }
                    }
                }
                Spacer()
                
            }
        }
    }
    
//    선택한 선택지의 정답여부를 시각적으로 보여주기 위해 작성했습니다.
//    아래 코드는 selectedNumber가 nil인 경우 기본 폰트 색상인 .primary를 반환하고, selectedNumber가 1인 경우 녹색인 .green을 반환하며, 그 외의 숫자일 경우 빨간색인 .red를 반환합니다.
    private func getTextColor(selectedNumber: Int?) -> Color {
        if (generatorViewMode != GeneratorViewMode.publish(showAnswer: true) && generatorViewMode != GeneratorViewMode.publish(showAnswer: false)) {
            if let selectedNumber = selectedNumber {
                if selectedNumber == solver.ansSelNumber {
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
//
//    static var previews: some View {
////        @Binding var solvedCount: Int = 3
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
//        return SolverView(solver: Solver(question, gonnaChange: true), solvedCount:  .constant(3), generatorViewMode: .constant(GeneratorViewMode.test))
//    }
//}
