//
//  GeneratorView.swift
//  TestGeneratorIOS
//
//  Created by Masterbuilder on 2023/06/17.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import SwiftUI

struct GeneratorView20230620: View {
    @ObservedObject var generator: Generator // 이게 결국 Test의 래퍼이므로, 기존 TestView 파일을 이 파일로 변경함
    
    @State var title : String? = nil
    @State var solved : Int = 0
    
    @State var publishMode = true
    @State var testMode = false
    @State var gonnaShuffle : Bool = false
    
    @State var showAnswer = false
    @State var showResult = false
    
    @State private var isTestStartPopoverPresented = false
    @State private var isResultPopoverPresented = false
    @State private var currentTime: Date = Date() // currentTime 변수 추가

//    selectedTest를 이용해 제네레이터를 생성하기 위해서 부득이 초기화함수 두개를 작성했음... 그러나 2023. 6. 19. 챗지피는...
//    SwiftUI에서는 뷰 클래스에 이니셜라이저(Initializer)를 구현하는 것이 일반적으로 권장되지 않습니다. SwiftUI는 선언적인 방식으로 뷰를 작성하기 위해 뷰 계층 구조를 자동으로 구성하고 관리하는 데에 주력하며, 이를 위해 뷰의 초기화와 구성을 담당하는 수명 주기 관리를 자동으로 처리합니다.
//    대부분의 경우, SwiftUI에서 뷰를 작성할 때 body 프로퍼티를 구현하여 뷰의 외형을 선언하고, SwiftUI 프레임워크에서 제공하는 뷰 수명 주기 관리 기능을 활용합니다. body 프로퍼티에서 뷰의 구성을 설명하고 뷰를 업데이트하는 데 필요한 로직을 추가할 수 있습니다.
//    그러나 경우에 따라서는 이니셜라이저를 사용해야 할 수도 있습니다. 예를 들어, 외부 데이터 또는 종속성을 받아 뷰를 초기화해야 하는 경우에는 이니셜라이저를 사용할 수 있습니다. 이 경우 init 키워드를 사용하여 이니셜라이저를 구현하고, 초기화하는 데 필요한 데이터를 전달할 수 있습니다.
    
    init(generator: Generator, publishMode: Bool = true, testMode: Bool = false) {
        self._generator =  State(initialValue: Generator()) // 대체 이 코드는 무슨의미인가? 자꾸 에러가 나서 챗지피티의 추천으로 넣었으나 그 의미를 꼭 공부해야 함. 2023. 6. 19. (-)
        self.publishMode = publishMode
        self.testMode = testMode
    }
    
    init(selectedTest: Test) {
        _generator = State(initialValue: Generator()) // 대체 이 코드는 무슨의미인가? 자꾸 에러가 나서 챗지피티의 추천으로 넣었으나 그 의미를 꼭 공부해야 함. 2023. 6. 19. (-)
        _title = State<String?>(initialValue: selectedTest.key)
        for que in selectedTest.questions {
            self.generator.solvers.append(Solver(que))
            self.generator.solversChanged.append(Solver(que, gonnaShuffle: true))
        }
    }
    
    var body: some View {
        ZStack {
//            문제를 열거하는 가장 기본적인 뷰입니다.
            VStack {
                if !gonnaShuffle {
                    SwiftUI.List(generator.solvers, id: \.self) { solver in
                        //                    QuestionView(question: question,publishMode: publishMode, showAnswer: false) // 2023. 6. 17. 주석처리.
                        SolverView(solver: solver, solved: $solved, publishMode: $publishMode, showAnswer: $showAnswer, showResult: $showResult)
                    }
                } else {// 이게 안 먹는 듯. (-) 2023. 6. 19.
                    SwiftUI.List(generator.solversChanged, id: \.self) { solver in
                                            SolverView(solver: solver, solved: $solved, publishMode: $publishMode, showAnswer: $showAnswer, showResult: $showResult)
                                        }
                }
            }
            
//            publishMode일 경우에만, 문제풀기 버튼을 오버레이 합니다.
            if publishMode {
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            isTestStartPopoverPresented = true
//                            showResult = true
//                            showAnswer = true
                        }) {
                            Label(
                                title: { Text("풀기") },
                                icon: { Image(systemName: "square.and.pencil.circle.fill") }
                            )
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.secondary)
                            .cornerRadius(10)
                        }
                        .sheet(isPresented: $isTestStartPopoverPresented) {
                            TestStartPopoverView(isPresented: $isTestStartPopoverPresented,publishMode: $publishMode, testMode: $testMode, gonnaShuffle: $gonnaShuffle, generator: $generator)
                        }
                    }
                }
                .padding()
            }

               
            
//            testhMode일 경우에만, 제출 버튼을 오버레이 합니다.
            if testMode {
                VStack {
                    Spacer()
                    HStack {
                            Text("\(solved) / \(generator.solvers.count)")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.secondary)
                                .cornerRadius(10)
                            Spacer()
                            // 실시간 시간 표시
//                            let timeDifference = currentTime.timeIntervalSince(Date())
//                            let timeString = currentTimeFormatter.string(from: Date(timeIntervalSinceReferenceDate: -timeDifference))
//                            Text(timeString)
//                                .font(.headline)
//                                .foregroundColor(.white)
//                                .padding()
//                                .background(Color.secondary)
//                                .cornerRadius(10)
//                                .onAppear {
//                                    startTimer()
//                                }
                            Spacer()
                            
                            Button(action: {
                                isResultPopoverPresented = true
                                showResult = true
                                showAnswer = true
                            }) {
                                Label(
                                    title: { Text("제출") },
                                    icon: { Image(systemName: "arrow.up.doc") }
                                )
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.secondary)
                                .cornerRadius(10)
                            }
                            .sheet(isPresented: $isResultPopoverPresented) {
                                ResultPopoverView(isPresented: $isResultPopoverPresented,testMode: $testMode, generator: $generator)
                            }
                        }
                        
                }
                    .padding()
            }

        }
//        .navigationTitle(generator.key) // 네비게이션을 사용하는 스위프트유아이에서 추가로 필요한 상수로 이를 위해 클래스에 추가함. 2023. 6. 17. 그러나 이를 동적으로 정의할 예정이므로, 삽질임 (-)
        .navigationTitle(getGeneratorTitle())
    }
    
    private func getGeneratorTitle() -> String {
        var str = ""
        if publishMode {
            str = _title.wrappedValue ?? ""
        } else if testMode {
//            str = "총 \(generator.solvers.count) 문제 중 \(solved) 문제 품."
            str = "총 \(generator.solvers.count) 문제 풀이 중"
        } else if showResult {
            let (c, w) = generator.seperateWorngSolve()
            str = "\(c.count + w.count) 문제 풀어 \(c.count) 문제 맞춤"
        }
        return str
    }
    
    // 챗지피티까 짜눈 시간 업데이트 두개 이며 추후 공부해야 함. 2023. 6. 19. (-)
    private func startTimer() {
            // 1초마다 현재 시간 업데이트
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                currentTime = Date()
            }
        }
        
    private var currentTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }
}


//struct GeneratorView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestView(selectedTest: Test(createDate: Date(), testSubject: TestSubject(testCategory: TestCategory(testDatabase: TestDatabase(UUID()), category: "변호사시험"), subject: "민사법"), revision: 0, isPublished: true, number: 1))
//    }
//}
