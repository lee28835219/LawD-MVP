//
//  GeneratorView.swift
//  TestGeneratorIOS
//
//  Created by Masterbuilder on 2023/06/20.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import SwiftUI

struct GeneratorView: View {
    var log = ""
    
    @EnvironmentObject var generateHistory : GenerateHistory
    // 유연한 시험생성 관리를 위해, 이 뷰에는 오로지 generator 인스턴스로 시작하며, 이는 
    @StateObject var generator : Generator // @StateObject는 이해가 가지 않으므로, 추후 꼭 공부해야 합니다. 2023. 6 .23. (-)
    @Binding var generatorViewMode : GeneratorViewMode // 이 뷰를 제어하는 가장 중요한 변수입니다.
    
    @State private var isResultPopoverPresented = false // test모드의 경우 제출 버튼 탭할 경우 result모드로 변경됨과 동시에 그 사이 resultPopoverView에서 간략히 제출과 관련된 사용자 선택사항을 처리하므로 해당 변수가 필요합니다.
    
    // 시험결과 메모하기 버튼 추가 2023. 9. 8.
    @State private var isMemoInputPresented = false
    @State private var memoText = ""
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {
            // 본문 부분입니다.
            VStack {
                // 시험에 관한 정보 부분으로, publish모드에서는 보여지지 않습니다.
                if case .test = generatorViewMode // 진행과정과 시험시간을 표시하는 부분으로, testMode일 때만 표시됩니다.
                {
                HStack {
                    // 진행과정
                    HStack {
                        Image(systemName: "chart.bar.fill")
                            .foregroundColor(.blue)
                        Text("푼 문제")
                        Text("\(generator.solvedCount)")
                            .font(.headline)
                        Text("/")
                        Text("총 문제")
                        Text("\(generator.solvers.count)") // 이 부분은 코딩 능력 부족으로 단순하게 푼 문제수를 관리하는 것으로, 좀더 구조적이고 분석가능한 방식으로 수정할 필요가 매우 큽니다. (-) 2023. 6. 22.
                        // Text("\(generator.getSolved().count) / \(generator.solvers.count)")
                            .font(.headline)
//                        Text("(진행율: \(Int((Double(generator.solvedCount) / Double(generator.solvers.count)) * 100))%)")
                        Text("(진행율: \(generator.solvers.count != 0 ? Int((Double(generator.solvedCount) / Double(generator.solvers.count)) * 100) : 0)%)") // 2023. 6. 25.
                    }
                    // 시험시간
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundColor(.blue)
                        Text("시험시간: \(isResultPopoverPresented ? generator.teimeConsumeString : generator.date.timeComponentsString())") // 제출버튼을 눌러 시험이 끝났음에도 시험시간이 계속진행되는 것이 어색하여 추가한 구문으로, 제출 버튼이 눌러지면 isResultPopoverPresented이 참이 되는 성질을 이용하였습니다. 그러나 이는 오로지 시험을 제출한다는 전제로 작성된 것이기에 향후 위 팝오버뷰에서 다양한 제어를 한다고 가정하면, 이는 수정될 필요 있습니다. (-) 2023. 6. 23.
                    }
                    .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                        // 현재 시간이 업데이트될 때마다 UI를 업데이트합니다.
                        // 위의 예시 코드에서는 onReceive를 사용하여 1초마다 UI를 업데이트하도록 설정하여 실시간으로 텍스트를 갱신합니다. 이를 통해 date와 현재 시간 간의 시, 분, 초 단위의 시간 차이를 실시간으로 표시할 수 있습니다. timeComponentsString(from:) 함수는 주어진 date와 현재 시간 간의 시간 차이를 계산하고, 해당 시간 차이를 시, 분, 초 단위로 변환하여 텍스트로 반환합니다. 2023. 6. 22. 챗지피티
                        generator.objectWillChange.send() // 어떤 의미인지 공부해야 함. generator.date는 변경이 없는데 뭐가 변한다는 건지? 2023. 6. 22. (-)
                    }
                }
            }
                else if case .result = generatorViewMode // 시험결과와 시험에 소요된 시간을 표시하는 부분으로, resultMode일 때만 표시됩니다.
                {
                    HStack {
                        // 시험결과
                        HStack {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.green)
                            Text("맞은 갯수")
                            Text("\(generator.seperateWorngSolve().correct.count)")
                                .font(.headline)
                            Text("/")
                            Image(systemName: "chart.bar.fill")
                                .foregroundColor(.blue)
                            Text("푼 문제 수")
                            Text("\(generator.solvedCount)") // 이 부분은 코딩 능력 부족으로 단순하게 푼 문제수를 관리하는 것으로, 좀더 구조적이고 분석가능한 방식으로 수정할 필요가 매우 큽니다. (-) 2023. 6. 22.
                            // Text("\(generator.getSolved().count) / \(generator.solvers.count)")
                                .font(.headline)
                            Text(generator.solvedCount > 0 ? "(정답율: \(Int((Double(generator.seperateWorngSolve().correct.count) / Double(generator.solvedCount)) * 100))%)" : "(정답율: 구할 수 없음)") // 위의 코드에서 solvedCount가 0보다 큰지 확인하여 조건을 설정하고, 그에 따라 "정답율"을 계산하거나 "구할 수 없음"을 출력하도록 처리하였습니다. 이제 수정된 코드를 사용하여 Text 뷰에서 "정답율"을 출력할 때 solvedCount가 0일 경우 "구할 수 없음"이 나타나도록 할 수 있습니다. 2023. 6. 22. 챗지피티
                        }
                        // 시험시간
                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.blue)
                            Text("소요시간: \( generator.timeConsume.timeComponentsString())")
                        }
                        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                            // 현재 시간이 업데이트될 때마다 UI를 업데이트합니다.
                            // 위의 예시 코드에서는 onReceive를 사용하여 1초마다 UI를 업데이트하도록 설정하여 실시간으로 텍스트를 갱신합니다. 이를 통해 date와 현재 시간 간의 시, 분, 초 단위의 시간 차이를 실시간으로 표시할 수 있습니다. timeComponentsString(from:) 함수는 주어진 date와 현재 시간 간의 시간 차이를 계산하고, 해당 시간 차이를 시, 분, 초 단위로 변환하여 텍스트로 반환합니다. 2023. 6. 22. 챗지피티
                            generator.objectWillChange.send() // 어떤 의미인지 공부해야 함. generator.date는 변경이 없는데 뭐가 변한다는 건지? 2023. 6. 22. (-)
                        }
                    }
                }
                
                // ★★★문제를 보여주는 가장 중요한 부분입니다.
                if case .test(let oneByOne) = generatorViewMode,oneByOne // test모드에서 oneByOne이 true인 경우 실행되는 코드입니다.
                {
                    // 직접 솔버를 불러오고 솔버에는 제어부분을 아래에 표시합니다.
                    if generator.solvers.first != nil {
                        SolverOneByOneView(generatorViewMode: $generatorViewMode, isResultPopoverPresented : $isResultPopoverPresented, solversIndex: 0)
                            .environmentObject(generator) // 이해가 가지 않으므로, 추후 꼭 공부해야 합니다. 2023. 6 .23. (-)
                            .environmentObject(generateHistory)
                    } else {
                        fatalError("한 문제도 없는 시험이 호출되었음.")
                    }
                }
                else // 그 외 모든 모드는 시험문제를 보기만 하던지 직접 문제를 풀던지 관계없이, 일단 리스트 형태로 시험문제를 보여주도록 구현하였습니다.
                {
                    // test모드에서 oneByOne이 true인 경우를 제외하고는 거의 대부분 genrator.solvers를 나열합니다.
                    // 다만, result모드에서 showWrongOnly가 true인 경우엔 generator.seperateWorngSolve().wrong 즉 틀린문제에 관한 결과만을 리스트로 나열하게 됩니다.
                    SolversListView(generatorViewMode: $generatorViewMode)
                        .environmentObject(generator) // 이해가 가지 않으므로, 추후 꼭 공부해야 합니다. 2023. 6 .23. (-)
                }
            }
            .onAppear() { // 디버깅용 텍스트 출력을 위한 부분일 뿐입니다. 2023. 6. 23.
                print(ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "GeneratorViewMode : \(generatorViewMode)에 관한 Solver들 리스트 업을 전체 \(generator.solvers.count)문제 중 일부에 관해 시작합니다."))
            }
            
            // 오버레이 버튼 부분으로, generatorViewMode에 따라 보여주는 버튼이 동적으로 변경되도록 구현되었습니다.
            if case .publish = generatorViewMode // 오버레이되는 정답보기 버튼 부분으로, publishMode 때만 표시되며, 선택 시 정답보여주는 모드를 토글합니다.
            {
                Button(action: {
                    generatorViewMode.toggleShowAnswer()
                    print("정답을 보여주는 모드를 토글")
                }) {
                    Label(
                            title: {
                                if case .publish(let showAnswer) = generatorViewMode {
                                    if showAnswer {
                                        Text("정답가리기")
                                    } else {
                                        Text("정답보기")
                                    }
                                } else {
                                    Text("정답보기")
                                }
                            },
                            icon: {
                                if case .publish(let showAnswer) = generatorViewMode {
                                    if showAnswer {
                                        Image(systemName: "eye.slash.fill")
                                    } else {
                                        Image(systemName: "eye.fill")
                                    }
                                } else {
                                    Image(systemName: "eye.fill")
                                }
                            }
                        )
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.secondary)
                    .cornerRadius(10)
                }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .alignmentGuide(.bottom) { d in d[.bottom] + 16 } // 아래쪽으로 16 포인트 띄움
                    .alignmentGuide(.trailing) { d in d[.trailing] - 16 } // 오른쪽으로 정렬
                    .offset(x: -16, y: 0) // 추가: 왼쪽으로 16포인트 이동
            }
            
            else if case .test(oneByOne: false) = generatorViewMode // 오버레이되는 시험 제출 버튼 부분으로, .test(oneByone: false) 때만 표시되고, true일 경에는 솔버원바원뷰에서 처리합니다.
            {
                Button(action: {
                    //  통합 관리를 위해 리절트 팝오버뷰 어피어 시점으로 변경필요 (-) 2023. 6. 25.
                    generator.timeConsume =  Date().timeIntervalSince(generator.date) // 시험에 소요된 시간을 관리하는 구문
                    generator.teimeConsumeString =  generator.timeConsume.timeComponentsString()
                    generator.solvers = generator.getSolved()
                    generateHistory.generators.append(self.generator) // ★★★★★ 시험이력을 추가하는 매우 매우 중요한 구문
                    print("현 시험 정보를 저장하였음. \(String(describing: generator.solversOriginal.count)) 문제 중 \(String(describing: generator.solvers.count)) 품")
                    
                    // 리절트팝오버뷰 호출
                    isResultPopoverPresented = true
                    
                }) {
                    Label(
                        title: { Text("제출") },
                        icon: { Image(systemName: "arrow.up.doc.fill") }
                    )
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.secondary)
                    .cornerRadius(10)
                }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .alignmentGuide(.bottom) { d in d[.bottom] + 16 } // 아래쪽으로 16 포인트 띄움
                    .alignmentGuide(.trailing) { d in d[.trailing] - 16 } // 오른쪽으로 정렬
                    .offset(x: -16, y: 0) // 추가: 왼쪽으로 16포인트 이동
                    .sheet(isPresented: $isResultPopoverPresented) {
                        ResultPopoverView(isPresented: $isResultPopoverPresented, generatorViewMode: $generatorViewMode)
                            .environmentObject(generator)
                    }
            }
            
            else if case .result = generatorViewMode // 오버레이되는 틀린문제만 보기 버튼 부분으로, resultMode 때만 표시됩니다. // 추후 구현 필요합니다. 2023. 6. 22. (-)
            {
                // 메모하기
                Button(action: {
                    isMemoInputPresented = true
                    print("메모하기 버튼 선택됨")
                }) {
                    Label(
                            title: {
                                Text("메모하기")
                            },
                            icon: {
                                    Image(systemName: "pencil.circle.fill")
                                }
                        )
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.secondary)
                    .cornerRadius(10)
                }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .alignmentGuide(.bottom) { d in d[.bottom] + 16 } // 아래쪽으로 16 포인트 띄움
                    .alignmentGuide(.trailing) { d in d[.trailing] - 16 } // 오른쪽으로 정렬
                    .offset(x: -16, y: 0) // 추가: 왼쪽으로 16포인트 이동
                
                // 틀린문제만 보기 토글
                Button(action: {
                    generatorViewMode.toggleShowWrongOnly()
                    print("틀린문제만 보기 버튼 토글")
                }) {
                    Label(
                            title: {
                                if case .result(let showWrongOnly) = generatorViewMode { //이를 관리할 변수 지정 필요합니다.
                                    if showWrongOnly {
                                        Text("모든 문제 보기")
                                    } else {
                                        Text("틀린 문제만 보기")
                                    }
                                } else {
                                    Text("틀린 문제만 보기")
                                }
                            },
                            icon: { // 추후 논리적으로 반대되는 이미지 추가하여 구현필요
                                if case .result(let showWrongOnly) = generatorViewMode {
                                    if showWrongOnly {
                                        Image(systemName: "line.horizontal.3.decrease.circle.fill")
                                    } else {
                                        Image(systemName: "line.horizontal.3.decrease.circle.fill")
                                    }
                                } else {
                                    Image(systemName: "line.horizontal.3.decrease.circle.fill")
                                }
                            }
                        )
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.secondary)
                    .cornerRadius(10)
                }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .alignmentGuide(.bottom) { d in d[.bottom] + 16 } // 아래쪽으로 16 포인트 띄움
                    .alignmentGuide(.trailing) { d in d[.leading] - 16 } // 오른쪽으로 정렬
                    .offset(x: 16, y: 0) // 추가: 왼쪽으로 16포인트 이동
                    .sheet(isPresented: $isMemoInputPresented) {
                        MemoInputView(isPresented: $isMemoInputPresented, memoText: $memoText)
                    }
            }
        }
    }
    
// 2023. 6. 25. 익스텐션으로 관리합니다.
//    //위의 함수는 주어진 TimeInterval을 시, 분, 초로 분해하고, "hh:mm:ss" 형식의 문자열로 변환하여 반환합니다. 시간, 분, 초 값들을 String(format: "%02d:%02d:%02d", ...)을 사용하여 두 자리 수로 표현하도록 포맷팅합니다. 따라서, Text("소요시간: \(timeComponentsString(from: generator.timeConsume))")와 같이 사용하여 generator.timeConsume의 값을 "hh:mm:ss" 형식으로 표현할 수 있습니다. 2023. 6. 22. 챗지피티
//    func timeComponentsString(from timeInterval: TimeInterval) -> String {
//        let hours = Int(timeInterval) / 3600
//        let minutes = Int(timeInterval) % 3600 / 60
//        let seconds = Int(timeInterval) % 60
//
//        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
//    }
//
//    func timeComponentsString(from date: Date) -> String {
//        let interval = Date().timeIntervalSince(date)
//        let timeInterval = Int(interval)
//
//        let seconds = timeInterval % 60
//        let minutes = (timeInterval / 60) % 60
//        let hours = (timeInterval / 3600)
//
//        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
//    }
}

//struct GeneratorView_Previews: PreviewProvider {
//    static var previews: some View {
//        GeneratorView(generator: Generator(), generatorViewMode: Binding.constant(GeneratorViewMode.test))
//    }
//}


extension TimeInterval {
    func timeComponentsString() -> String {
        let hours = Int(self) / 3600
        let minutes = Int(self) % 3600 / 60
        let seconds = Int(self) % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

extension Date {
    func timeComponentsString() -> String {
        let interval = Date().timeIntervalSince(self)
        let timeInterval = Int(interval)
        
        let seconds = timeInterval % 60
        let minutes = (timeInterval / 60) % 60
        let hours = (timeInterval / 3600)
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
