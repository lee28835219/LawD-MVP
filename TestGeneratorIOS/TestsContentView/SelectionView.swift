//
//  StatementView.swift
//  TestGeneratorIOS
//
//  Created by Masterbuilder on 2023/06/16.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import SwiftUI


struct SelectionView: View {
//    @Binding var solvedCount : Int
    
    @EnvironmentObject var generator : Generator
    
    let selectionContent : String
    let showNumber : Int
    
    var body: some View {
        HStack {
            VStack() {
                Text(showNumber.roundInt)
                Spacer()
            }
            VStack() {
                let wrappedText = selectionContent.map { String($0) }.joined(separator: " ")
                //                        단어단위 줄바꿈 밖에 안되서 사용한 고육지책인데,
                //                        이를 텍스트 뷰 옵션에서 해결할 방법을 찾아야 한다. (-) 2023. 6. 15.
                Text(" " + wrappedText)
                    .font(.body)
                    .kerning(-2) // 위 줄바꿈 고육지책 땜빵용
                    .padding(1)
                    .lineLimit(nil)
                
                Spacer()
            }
                
            Spacer()
        }
    }
}

struct StatementView_Previews: PreviewProvider {
    static var previews: some View {
//        let statement = Statement(revision: 0, key: "", question: Question(revision: 0, test: nil, number: 1, questionType: .Select, questionOX: .Correct, content: "상계에 관한 설명 중 옳은 것은?", answer: 3), content: "채권의 일부양도가 이루어진 경우, 그 분할된 채권에 대하여 양도인에 대한 반대채권으로 상계하고자 하는 채무자는 양도인을 비롯한 각 분할채권자 중 어느 누구라도 상계의 상대방으로 지정하여 상계할 수 있다.")
        let selectionContent = "채권의 일부양도가 이루어진 경우, 그 분할된 채권에 대하여 양도인에 대한 반대채권으로 상계하고자 하는 채무자는 양도인을 비롯한 각 분할채권자 중 어느 누구라도 상계의 상대방으로 지정하여 상계할 수 있다."
        
        return SelectionView(selectionContent: selectionContent, showNumber: 3)
        
    }
}
