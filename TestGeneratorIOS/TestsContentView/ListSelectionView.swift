//
//  ListSelectionView.swift
//  TestGeneratorIOS
//
//  Created by Masterbuilder on 2023/06/25.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import SwiftUI

struct ListSelectionView: View {
    @EnvironmentObject var generator : Generator
    
    let listsNumberString : String
    let listSelectionContent : String
    
    var body: some View {
        HStack {
            VStack() {
                Text(" \(listsNumberString). ")
                Spacer()
            }
            VStack() {
                let wrappedText = listSelectionContent.map { String($0) }.joined(separator: " ")
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

struct ListSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ListSelectionView(listsNumberString: "ㄱ", listSelectionContent: "인간은 평등하지 않다.")
    }
}
