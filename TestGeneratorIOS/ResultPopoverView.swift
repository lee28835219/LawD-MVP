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
    @Binding var testMode : Bool
    @Binding var generator : Generator
    
    @State var answerRate : Float = 0.0
    @State var answerCountFor150 : Float = 0.0
    

    var body: some View {
        VStack {
            let (c, w) = generator.seperateWorngSolve()
            
            if c.count + w.count == 0 {
                Text("한 문제도 풀지 않았습니다.")
                    .padding()
            } else {
                let answerRate: Float = c.count + w.count != 0 ? Float(c.count) / Float(w.count + c.count) * 100 : 0
                let answerCountFor150: Float = c.count + w.count != 0 ? Float(c.count) / Float(w.count + c.count) * 150 : 0
                //                        let solvedTimeAverage: Float = generator.getSolveDurationAverage() ?? 0
                
                Text("[풀이결과]")
                    .font(.headline)
                    .padding()
                
                
                Text("총 \(generator.solvers.count) 문제 중 \(w.count + c.count) 문제를 풀었고,\n이 중  \(c.count) 문제를 맞추어서\n정답율은 \(String(format: "%.1f", answerRate))%입니다.")
                    .padding()
                    .multilineTextAlignment(.center)
                
                //                        Text("150개 풀었다고 가정 시 : \(Int(answerCountFor150))개 맞음")
                //                            .padding()
                
                //                        Text("풀이에 평균적으로 걸린 시간 : \(String(format: "%.1f", solvedTimeAverage)) 초")
                //                            .padding()
            }
            
            Button("닫기") {
                isPresented = false
                testMode.toggle()
            }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}
        

//struct ResultPopupView_Previews: PreviewProvider {
//    @State static var isPresented = false
//    @State static var testMode = true
//    @State static var generator = Generator()
//
//    static var previews: some View {
//        ResultPopoverView(isPresented: $isPresented, testMode: testMode, generator: $generator)
//    }
//}
