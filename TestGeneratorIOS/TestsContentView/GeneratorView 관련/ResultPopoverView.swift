//
//  ResultPopoverView.swift
//  TestGeneratorIOS
//
//  Created by Masterbuilder on 2023/06/19.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import SwiftUI

struct ResultPopoverView: View {
    @Binding var isPresented: Bool
    @Binding var generatorViewMode: GeneratorViewMode
    @EnvironmentObject var generator: Generator
    @EnvironmentObject var generateHistory: GenerateHistory
    
    @State var answerRate: Float = 0.0
    
    var body: some View {
        VStack(spacing: 20) {
            let (c, w) = generator.seperateWorngSolve()
            
            if c.count + w.count == 0 {
                Text("한 문제도 풀지 않으셨습니다.")
                    .font(.title2)
                    .bold()
            } else {
                let answerRate: Float = c.count + w.count != 0 ? Float(c.count) / Float(w.count + c.count) * 100 : 0
                
                Text("풀이결과를 간단히 요약하면 아래와 같습니다.")
                    .font(.title2)
                    .bold()
                
                VStack(spacing: 10) {
                    HStack {
                        Image(systemName: "list.number")
                        Text("총 문제 수")
                        Spacer()
                        Text("\(generator.solvers.count)")
                    }
                    HStack {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.green)
                        Text("맞은 갯수")
                        Spacer()
                        Text("\(c.count)")
                    }
                    HStack {
                        Image(systemName: "xmark.circle")
                            .foregroundColor(.red)
                        Text("틀린 갯수")
                        Spacer()
                        Text("\(w.count)")
                    }
                    HStack {
                        Image(systemName: "percent")
                            .foregroundColor(.orange)
                        Text("정답율")
                        Spacer()
                        Text("\(String(format: "%.1f", answerRate))%")
                    }
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.orange)
                        Text("소요시간")
                        Spacer()
                        Text("\(generator.teimeConsumeString)")
                    }
                }
                .font(.body)
                .padding()
                
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.green)
                    .padding(.bottom, 20)
            }
            
            Button("닫기") {
                isPresented = false
                generatorViewMode = .result()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        // 실질적으로 저정을 담당하는 매우 중요한 구문. 그러나 원바이원에서는 이 뷰를 불러오지 못하는 이슈 있어 이를 이렇게 통일적으로 관리하고 못하고 있습니다. 추후 수정 필요합니다. 2023. 6. 25. (-)
//        .onAppear() {
//            generator.timeConsume =  Date().timeIntervalSince(generator.date) // 시험에 소요된 시간을 관리하는 구문
//            generator.teimeConsumeString =  generator.timeConsume.timeComponentsString()
//            generateHistory.generators.append(self.generator) // 시험이력을 추가하는 중요한 구문
//            print("현 시험 정보를 저장하였음. \(String(describing: generateHistory.generators.first?.solvers.count)) 문제 중 \(String(describing: generateHistory.generators.first?.getSolved().count)) 품")
//        }

    }
}

struct ResultPopoverView_Previews: PreviewProvider {
    @State static var isPresented = false
    @State static var generatorViewMode = GeneratorViewMode.result()
    @State static var generator = Generator()
    
    static var previews: some View {
        ResultPopoverView(isPresented: $isPresented, generatorViewMode: $generatorViewMode)
            .environmentObject(generator)
    }
}

