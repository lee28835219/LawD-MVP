//
//  QuestionView.swift
//  TestGeneratorIOS
//
//  Created by Masterbuilder on 2023/06/14.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import SwiftUI

// 실질적으로 사용자 경험을 정의하는 가장 중요한 뷰입니다.
// 2023. 6.초부터 SwiftUI를 학습하여 이를 연습장 삼아 작성하였음.

struct QuestionView: View {
    let question: Question
        
//    출력환경을 잡아주는 파라미터들입니다.
    @State var publishMode = false
    @State var showAnswer : Bool = false
    
    @State private var selectedNumber : Int?
    
    var body: some View {
        VStack(alignment: .leading) {
            
//            문제의 질문과 선택지를 보여주는 가장 기본적인 뷰입니다.
            Text("문. \(question.number) \(question.content)")
                .font(.headline)
                .foregroundColor(getTextColor(question: question, selectedNumber: selectedNumber))
                .onTapGesture {
                    print("문. \(question.number)를 선택함.")
                    selectedNumber = nil
                    showAnswer = false
                }
            
            ForEach(question.selections.indices) { index in let selection = question.selections[index]
//              2023. 6. 16. 챗지피티에서 짠 코드로, indices라는 속성을 이용하였습니다.
//                `indices`는 Swift의 내장된 컬렉션 타입에서 제공하는 속성으로, 해당 컬렉션의 유효한 인덱스 범위를 나타내는 시퀀스입니다. `indices`는 해당 컬렉션의 인덱스를 순회하거나 인덱스에 접근하는 데 사용될 수 있습니다.
//
//                예를 들어, 배열의 경우 `indices`를 사용하여 배열의 모든 인덱스를 반복하거나 특정 인덱스에 접근할 수 있습니다. 아래는 `indices`를 사용한 예시입니다:
//
//                ```swift
//                let array = ["Apple", "Banana", "Cherry"]
//
//                for index in array.indices {
//                    print("Index: \(index), Value: \(array[index])")
//                }
//                ```
//
//                위 코드는 `array` 배열의 모든 인덱스를 반복하며, 각 인덱스와 해당 인덱스의 값을 출력합니다.
//
//                따라서 `QuestionView`의 `ForEach` 루프에서 `question.selections.indices`를 사용하여 선택지의 모든 인덱스를 반복하고, 해당 인덱스를 통해 선택지에 접근하는 것이 가능해집니다.
//
//                더 많은 도움이 필요하시면 언제든지 알려주세요!selection in
                
                StatementView(statement: selection, showNumber: selection.number)
//                        사용자의 탭을 처리하는 구문으로, publishMode일 경우 작동하지 않습니다.
                    .onTapGesture {
                        if !publishMode {
                            showAnswer = true
                            selectedNumber = index + 1
                            if let selectedNumber = selectedNumber {
                                if selectedNumber == question.answer {
                                    print("[O] 문. \(question.number)에서 \(selection.number.roundInt), 즉 \(selectedNumber)를 선택하였는데, 이는 정답임.")
                                } else {
                                    print("[X] 문. \(question.number)에서 \(selection.number.roundInt), 즉 \(selectedNumber)를 선택하였는데, 이는 오답임.")
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
                    
                    StatementView(statement: question.answerSelection!, showNumber: question.answer)
                        .foregroundColor(getTextColor(question: question, selectedNumber: question.answer))
                }
            }
            
            Spacer()
            
        }
    }
    
//    선택한 선택지의 정답여부를 시각적으로 보여주기 위해 작성했습니다.
//    아래 코드는 selectedNumber가 nil인 경우 기본 폰트 색상인 .primary를 반환하고, selectedNumber가 1인 경우 녹색인 .green을 반환하며, 그 외의 숫자일 경우 빨간색인 .red를 반환합니다.
    private func getTextColor(question: Question, selectedNumber: Int?) -> Color {
        if let selectedNumber = selectedNumber {
            if selectedNumber == question.answer {
                return .green
            } else {
                return .red
            }
        }
        return .primary
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        let question = Question(revision: 0, test: nil, number: 1, questionType: .Select, questionOX: .Correct, content: "상계에 관한 설명 중 옳은 것은?", answer: 3)
        
        question.notContent = "상계에 관한 설명 중 옳지 않은 것은?"
        question.contentNote = "(다툼이 있는 경우에는 판례에 의함)"
        question.raw = "\n상계에 관한 설명 중 옳은 것은? (다툼이 있는 경우에는 판례에 의함)\n①고의의 불법행위로 인한 손해배상채권을 자동채권으로 하는 상계는 허용되지 않는다.\n②피용자의 고의의 불법행위로 인하여 사용자책임이 성립하는 경우, 사용자는 피해자의 사용자에 대한 손해배상채권을 수동채권으로 하여 상계할 수 있다.\n③채권의 일부양도가 이루어진 경우, 그 분할된 채권에 대하여 양도인에 대한 반대채권으로 상계하고자 하는 채무자는 양도인을 비롯한 각 분할채권자 중 어느 누구라도 상계의 상대방으로 지정하여 상계할 수 있다.\n④상대방이 제3자에 대하여 가지는 채권을 수동채권으로 하여 상계할 수 있다.\n⑤상계의 대상이 될 수 있는 자동채권과 수동채권이 서로 동시이행관계에 있다면 특별한 사정이 없는 한 상계가 허용되지 않는다.\n\n"
        
        let sel1 = Selection(revision: 0, question: question, number: 1, content: "고의의 불법행위로 인한 손해배상채권을 자동채권으로 하는 상계는 허용되지 않는다.")
        sel1.notContent = "고의의 불법행위로 인한 손해배상채권을 수동채권으로 하는 상계는 허용되지 않는다."
        
        let sel2 = Selection(revision: 0, question: question, number: 2, content: "피용자의 고의의 불법행위로 인하여 사용자책임이 성립하는 경우, 사용자는 피해자의 사용자에 대한 손해배상채권을 수동채권으로 하여 상계할 수 있다.")
        sel2.notContent = "피용자의 고의의 불법행위로 인하여 사용자책임이 성립하는 경우, 사용자는 피해자의 사용자에 대한 손해배상채권을 자동채권으로 하여 상계할 수 없다."
        
        let sel3 = Selection(revision: 0, question: question, number: 3, content: "채권의 일부양도가 이루어진 경우, 그 분할된 채권에 대하여 양도인에 대한 반대채권으로 상계하고자 하는 채무자는 양도인을 비롯한 각 분할채권자 중 어느 누구라도 상계의 상대방으로 지정하여 상계할 수 있다.")
        sel3.notContent = "채권의 일부양도가 이루어진 경우, 그 분할된 채권에 대하여 양도인에 대한 반대채권으로 상계하고자 하는 채무자는 양도인을 비롯한 각 분할채권자 중 어느 누구라도 상계의 상대방으로 지정하여 상계할 수 없다."
        
        let sel4 = Selection(revision: 0, question: question, number: 4, content: "상대방이 제3자에 대하여 가지는 채권을 수동채권으로 하여 상계할 수 있다.")
        sel4.notContent = "상대방이 제3자에 대하여 가지는 채권을 수동채권으로 하여 상계할 수 없다."
        
        let sel5 = Selection(revision: 0, question: question, number: 5, content: "상계의 대상이 될 수 있는 자동채권과 수동채권이 서로 동시이행관계에 있다면 특별한 사정이 없는 한 상계가 허용되지 않는다.")
        sel5.notContent = "상계의 대상이 될 수 있는 자동채권과 수동채권이 서로 동시이행관계에 있다면 특별한 사정이 없는 한 상계가 허용된다."

        
        return QuestionView(question: question ,publishMode: false ,showAnswer: true)
    }
}
