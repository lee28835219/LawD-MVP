//
//  solverOneByOneView.swift
//  TestGeneratorIOS
//
//  Created by Masterbuilder on 2023/06/24.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import SwiftUI

struct SolverOneByOneView: View {
    @EnvironmentObject var generateHistory : GenerateHistory
    @EnvironmentObject var generator : Generator
    @Binding var generatorViewMode : GeneratorViewMode
    @Binding var isResultPopoverPresented : Bool // test모드의 경우 제출 버튼 탭할 경우 result모드로 변경됨과 동시에 그 사이 resultPopoverView에서 간략히 제출과 관련된 사용자 선택사항을 처리하므로 해당 변수가 필요합니다.
    
    @State var solversIndex : Int
    @State var title = ""
    
    var body: some View {
        VStack {
            // 1문제 출력합니다.
            List(generator.solvers.indices, id: \.self) { index in // 컴퓨팅 능력 낭비이나, 솔버스리스트뷰와 동일한 레이아웃을 위해 사용하였습니다.
                if solversIndex == index {
                    let solver = generator.solvers[index]
                    SolverView(solver: solver, generatorViewMode: $generatorViewMode)
                        .environmentObject(generator)
                        .tag(index)
                }
            }
            
            // 제어버튼 입니다.
            HStack {
                // solversIndex가 0이면 뒤로 버튼을 보이지 않게 합니다.
                if solversIndex != 0 {
                    Button(action: {
                        // 뒤로 가기 액션
                        solversIndex += 1
                    }) {
                        Label(
                            title: { Text("뒤로") },
                            icon: { Image(systemName: "arrowshape.left.fill") }
                        )
                    }
                }
                
                Spacer()
                
                // solversIndex가 마지막일 경우 "제출" 버튼을 보여줍니다.
                if solversIndex == generator.solvers.count - 1 {
                    Button(action: {
                        //  통합 관리를 위해 리절트 팝오버뷰 어피어 시점으로 변경필요 (-) 2023. 6. 25.
                        generator.timeConsume =  Date().timeIntervalSince(generator.date) // 시험에 소요된 시간을 관리하는 구문
                        generator.teimeConsumeString =  generator.timeConsume.timeComponentsString()
                        generator.solvers = generator.getSolved()
                        generateHistory.generators.append(self.generator) // ★★★★★ 시험이력을 추가하는 매우 매우 중요한 구문
                        print("현 시험 정보를 저장하였음. \(String(describing: generator.solversOriginal.count)) 문제 중 \(String(describing: generator.solvers.count)) 품")
                        
                        // 결과 화면 호출
                        generatorViewMode = .result()
                        
                        // 리절트팝오버뷰 호출 구문이나 잘 작동하지 않습니다. 수정 필요 (-) 2023. 6. 25.
//                        isResultPopoverPresented = true
                    }) {
                        Label(
                            title: { Text("제출") },
                            icon: { Image(systemName: "arrow.up.doc.fill") }
                        )
                    }
                } else {
                    Button(action: {
                        // 앞으로 가기 액션
                        solversIndex += 1
                    }) {
                        HStack {
                            Text("앞으로")
                            Image(systemName: "arrowshape.right.fill")
                        }
                    }
                }
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle(title) // 왜 여기의 내용이 generatorView에서 나오는지 확인 필요합니다. (-) 2023. 6. 26.
        .navigationBarTitleDisplayMode(.inline)
        .onAppear() {
            title = generator.key
            if generator.changed {
                title = title + " 🔄 문제변경"
            }
            if generator.shuffled {
                title = title + " 🔀 순서섞기"
            }
        }
    }
}

//struct solverOneByOneView_Previews: PreviewProvider {
//    static var previews: some View {
//        SolverOneByOneView()
//    }
//}
