//
//  MemoInputView.swift
//  TestGeneratorIOS
//
//  Created by Masterbuilder on 2023/09/08.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import SwiftUI

import SwiftUI

struct MemoInputView: View {
    @Binding var isPresented: Bool
    @Binding var memoText: String

    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $memoText)
                    .padding()
                    .onChange(of: memoText) { newValue in
                        memoText = newValue
                    }
                                    
                
                Button("저장") {
                    isPresented = false
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()
            }
            .navigationTitle("메모")
            .navigationBarItems(trailing: Button("취소") {
                isPresented = false
            })
        }
    }
}

struct MemoInputView_Previews: PreviewProvider {
    static var previews: some View {
        MemoInputView(isPresented: .constant(true), memoText: .constant(""))
    }
}
