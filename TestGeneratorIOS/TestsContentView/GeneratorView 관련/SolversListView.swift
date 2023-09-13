//
//  SolverListView.swift
//  TestGeneratorIOS
//
//  Created by Masterbuilder on 2023/06/23.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import SwiftUI

struct SolversListView: View {
    @EnvironmentObject var generator : Generator  // @Binding일 경우 오류가 나서, 수정했습니다. @StateObject는 @Binding으로 받아야 하는 것으로 알고 있어 이 구문이 도저히이해가 가지 않으므로, 추후 꼭 공부해야 합니다. 2023. 6 .23. (-)
    @Binding var generatorViewMode : GeneratorViewMode
    
    @State var title : String = ""
    
    var body: some View {
        List(generatorViewMode == .result(showWrongOnly: true) ? generator.seperateWorngSolve().wrong : generator.solvers) { solver in
            SolverView(solver: solver, generatorViewMode: $generatorViewMode)
                .environmentObject(generator)  // 이해가 가지 않으므로, 추후 꼭 공부해야 합니다. 2023. 6 .23. (-)
                .onAppear() { // 디버깅용 텍스트 출력을 위한 부분일 뿐입니다.
//                    if solver.question.number == 1 {
//                        print("/* [generatorView]에서 출력한 generator의 첫번쨰 문제(에러체크용) */")
//                        print(solver.log)
//                        print("문제 1. \(solver.questionContent)")
//                        for (index, listcon) in solver.listsContent.enumerated() {
//                            print("  \(solver.listsNumberString[index]) \(listcon)")
//                        }
//                        for (index, selcon) in solver.selectionsContent.enumerated() {
//                            print(" \((index + 1).roundInt) \(selcon)")
//                        }
//                        print("정답: \((solver.ansSelNumber).roundInt) \(solver.ansSelContent)")
//                    }
                    if solver.question.number == 2 && solver.question.questionType == QuestionType.Find {
                        print("/* [generatorView]에서 출력한 generator의 두번쨰 문제(파인트 타입 에러체크용) */")
                        print(solver.log)
                        print("문제 2. \(solver.questionContent)")
                        for (index, listcon) in solver.listsContent.enumerated() {
                            print("  \(solver.listsNumberString[index]) \(listcon)")
                        }
                        for (index, selcon) in solver.selectionsContent.enumerated() {
                            print(" \((index + 1).roundInt) \(selcon)")
                        }
                        print("정답: \((solver.ansSelNumber).roundInt) \(solver.ansSelContent)")
                    }
                }
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

struct SolverListView_Previews: PreviewProvider {
    static var previews: some View {
        SolversListView(generatorViewMode: .constant(.test()))
            .environmentObject(Generator())
    }
}
