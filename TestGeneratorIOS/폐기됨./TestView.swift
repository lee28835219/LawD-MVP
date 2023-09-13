//
//  TestView.swift
//  TestGeneratorIOS
//
//  Created by Masterbuilder on 2023/06/16.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import SwiftUI

struct TestView: View {
    let selectedTest: Test
    @State var generator: Generator? = nil // 이게 결국 Test의 래퍼이므로, 이 파일을 Generator 파일로 수정할 것임.
    
    @State var publishMode = true
    @State var gernerator : Generator?
    
    var body: some View {
        ZStack {
//            문제를 열거하는 가장 기본적인 뷰입니다.
            VStack {
                SwiftUI.List(selectedTest.questions, id: \.self) { question in
//                    QuestionView(question: question,publishMode: publishMode, showAnswer: false) // 2023. 6. 17. 주석처리.
//                    SolverView(solver: Solver(question, gonnaShuffle: false), testMode: publishMode, showAnswer: false)
                }
            }
            
//            publishMode일 경우에만, 문제풀기 버튼을 오버레이 합니다.
            if publishMode {
                VStack {
                    Spacer()
                    HStack {
                        let firstQuestion = selectedTest.questions.first
                        if let question = firstQuestion {
                            // 한꺼번에 기존문제를 푸는 버튼입니다.
                            NavigationLink(destination: TestView(selectedTest: selectedTest, publishMode: false)) {
                                Text("한꺼번에 문제풀기")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.secondary)
                                    .cornerRadius(10)
                            }
                            // 한꺼번에 변경된 문제를 푸는 버튼입니다.
                            NavigationLink(destination: TestView(selectedTest: selectedTest, publishMode: false, gernerator: Generator())) {
                                Text("한꺼번에 변경된 문제풀기")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.secondary)
                                    .cornerRadius(10)
                            }
                            // 한문제씩 문제를 푸는 버튼입니다.
//                            NavigationLink(destination: QuestionView(question: question)) {
//                            NavigationLink(destination: SolverView(solver: Solver(question, gonnaShuffle: false), publishMode: publishMode, showAnswer: false)) {
                                Text("한문제씩 문제풀기")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.secondary)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
            }
        }
//        .navigationTitle(selectedTest.key)
//    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView(selectedTest: Test(createDate: Date(), testSubject: TestSubject(testCategory: TestCategory(testDatabase: TestDatabase(UUID()), category: "변호사시험"), subject: "민사법"), revision: 0, isPublished: true, number: 1))
    }
}
