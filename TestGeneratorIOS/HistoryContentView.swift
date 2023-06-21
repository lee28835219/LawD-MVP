//
//  HistoryContentView.swift
//  TestGeneratorIOS
//
//  Created by Masterbuilder on 2023/06/22.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import SwiftUI

struct HistoryContentView: View {
    @EnvironmentObject var generateHistory : GenerateHistory

    @State private var isShowingPopover = false
    
    @State var selectedGenerator = Generator()
    
    var body: some View {
        VStack {
            Spacer()
            Button(action: {
                isShowingPopover = true
            }) {
                Label("시험이력", systemImage: "list.bullet")
            }
            .sheet(isPresented: $isShowingPopover) {
                List(generateHistory.generators) { generator in
                    Text(generator.key + generator.date.HHmmSS + " 총 \(generator.solvers.count) 중 \(generator.getSolved().count) 풀어 \(generator.getSolved().filter { $0.isRight! }.count)를 맞춤.")
                        .onTapGesture {
                            isShowingPopover = false
                            selectedGenerator = generator
                        }
                }
            }
            
            Spacer()
            HStack {
                Image(systemName: "hammer.fill")
                Text("기능 추가예정")
            }
            .font(.title)
            Spacer()
        }
    }
}

struct HistoryContentView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryContentView()
            .environmentObject(Generator())
    }
}
