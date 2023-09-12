//
//  HistoryContentView.swift
//  TestGeneratorIOS
//
//  Created by Masterbuilder on 2023/06/22.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import SwiftUI

struct HistoryContentView: View {
    @EnvironmentObject var generateHistory: GenerateHistory
    @State private var generatorViewMode = GeneratorViewMode.result()
    
    var body: some View {
        NavigationView {
//            HStack {
//                Image(systemName: "hammer.fill")
//                Text("기능 추가 예정")
//            }
        List(generateHistory.generators) { generator in
            let title: String = {
                    var updatedTitle = " " + (generator.key.isEmpty ? "사용자정의 시험" : generator.key)
                    if generator.changed {
                        updatedTitle += " 🔄"
                    }
                    if generator.shuffled {
                        updatedTitle += " 🔀"
                    }
                    return updatedTitle
                }()
            
            NavigationLink(destination: GeneratorView(generator: generator, generatorViewMode: $generatorViewMode)) {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                    Spacer()
                    HStack {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.green)
                        Text("\(generator.seperateWorngSolve().correct.count)")
                        Text("/")
                        Image(systemName: "chart.bar.fill")
                            .foregroundColor(Color.indigo)
                        Text("\(generator.solvedCount)")
                        Text("  ")
                        Image(systemName: "clock.fill")
                            .foregroundColor(Color.cyan)
                        Text(generator.teimeConsumeString)
                    }
                    Spacer()
                    Text(generator.date.HHmm2 + "에 풀었음")
                        .frame(maxWidth: .infinity, alignment: .trailing) // 푼 일시를 오른쪽으로 정렬
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("시험이력")
        }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("시험이력")
        }
    }
}




struct HistoryContentView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryContentView()
            .environmentObject(Generator())
    }
}
