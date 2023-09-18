//
//  TestsView.swift
//  TestGeneratorIOS
//
//  Created by Masterbuilder on 2023/06/17.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import SwiftUI

// 민사법
struct TestsView : View {
    var log = ""
    
    // 유연한 시험생성 관리를 위해, 이 뷰에서 불러오는 시험들이란, Test 클래스를 만족하는 모든 인스턴스들입니다.
    @State var tests : [Test] = []
    
    // 따라서 반드시 Test().testSubject는 존재할 필요 없습니다.
    // 근데 왜 이 변수가 존재하는지 공부필요합니다. 2023. 6. 23. (-)
    let selectedSubject: TestSubject
    
    //    @State var generator = Generator()  //아무레도 이 부분은 여기서 정의하는게 괜히 삽질인거 같아 주석처리하였습니다. 2023. 6. 19.
    
    @EnvironmentObject var generateHistory : GenerateHistory
    
//    @State var testMode : Bool = false // GeneratorView를 거쳐 SolverView까지 전달되는 단순출력 혹은 문제풀기 파라미터로 기존 publishMode에서, true일 떄 시험을 본다는 의미가 더 중요하므로 testMode로 이름을 바꾸고 작동 방식을 뒤집었습니다. 2023. 6. 22.
    @State var generatorViewMode : GeneratorViewMode = GeneratorViewMode.test() // 2023. 6. 22. 이넘으로 관리 시작
    
    @State private var isPopupPresented = false // 풀기 버튼 선택 시 팝업을 띄워 시험 진행을 콘트롤 합니다.
//    @State private var isNavigationLinkActive = false //  Swift UI에서 Button과 NavigationLink를 함께 사용하면서 발생하는 이런 이슈는 널리 알려져 있습니다. Button을 눌렀을 때 NavigationLink도 같이 동작하는 문제는 NavigationLink가 Button을 둘러싼 상황에 발생합니다. 이를 해결하기 위한 일반적인 방법은 NavigationLink를 숨긴 상태로 사용하는 것입니다. 숨겨진 NavigationLink는 isActive 파라미터를 사용하여 프로그래밍 방식으로 활성화될 수 있습니다. 2023. 6. 21. 챗지피티 (-)
    @State private var selectedTest: Test? = nil //. Button과 NavigationLink를 같이 사용하되 서로 독립적으로 동작하도록 하려면, Button의 액션을 통해 팝업을 띄우고, 다른 View의 터치 이벤트를 통해 NavigationLink를 트리거하는 방법을 사용해야 합니다. 이를 위해 onTapGesture를 사용했습니다. 위 코드는 각 테스트 키를 클릭하면 selectedTest를 해당 테스트로 설정하며, 이는 바인딩된 NavigationLink를 트리거하여 GeneratorView를 엽니다. 반면, '풀기' 버튼을 클릭하면 팝업이 표시됩니다. 두 액션은 독립적으로 작동합니다. 2023. 6. 21. 챗지피티
    @State private var selectedTestTemp: Test? = nil // TestStartPopupView에서 바인딩된 리스트에서 사용자가 선택한 test전달을 위해 추가한 변수입니다. 2023. 6. 25. 챗지피티는 이 부분 통신까지 섬세하게 고려하지 않아 버그가 발생했습니다. 2023. 6. 25.
    
    @State var oneByOne : Bool = false
    @State var gonnaChange : Bool = false
    @State var gonnaShuffle : Bool = false // 추후 문제섞기 기능 추가 필요할수 있습니다. 2023. 6. 21. / 2023. 6. 26. 구현함. (+)
    
    var body: some View {
        List(tests, id: \.self) { test in
            HStack{
                Text(test.getKeySting())
                    .onTapGesture {
//                        generatorViewMOde = false // 단순히 문제를 보기만 하는 것이므로, 테스트모드를 꺼줘야 합니다.
                        generatorViewMode = GeneratorViewMode.publish(showAnswer: false)
                        self.selectedTest = test
                    }
                Spacer()
                
                // 리스트의 뒷 부분에 버튼으로 문제"풀기" 버튼을 구현한 부분입니다.
                Button(action: {
                    print("\(test.getKeySting())의 풀기가 선택되었습니다.")
                    selectedTestTemp = test
                    isPopupPresented = true
//                    selectedTest = test
//                    generatorViewMode = .test(oneByOne: oneByOne) // 2023. 6. 23. 단순히 이 구문 변경만으로 전체 제네레이터 모드 변경 가져올지 그 영향도 검토해야 합니다. (-), 6. 24. 아마도 작동 안하는 듯 하여 수정중입니다.
                    print(ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "테스츠뷰에서 \(generatorViewMode)에 관한 제네레이터를 불러올 준비가 되었습니다."))
//                    print(ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "테스츠뷰의 oneByOne 변수는 \(oneByOne)입니다."))
                }) {
                    HStack {
                        Image(systemName: "pencil.circle.fill")
                        Text("풀기")
                    }
                }
            }
            .background(
                NavigationLink( // 사용자의 선택을 받아 시험문제를 생성한 후 풀기를 시작하는 이 앱의 가장 중요한 동장을 구동하는 부분입니다.
                    destination:
                        GeneratorView(
                            generator: Generator(test: selectedTest ?? test, gonnaChange: gonnaChange, gonnaShuffle:  gonnaShuffle),
                            generatorViewMode: $generatorViewMode)
                        .onAppear {
                                // generatorViewMode의 디폴트 값이 .test()이므로, 따로 이곳에서 할당할 필요가 없긴 합니다.
//                                generatorViewMode = .test(oneByOne: oneByOne) // 2023. 6. 24. 단순히 이 구문 추가로 전체 제네레이터 모드 변경 가져옵니다!! "풀기"버튼 탭 시 모드 변경이었던 기존 코드를 제네레이터 뷰 불러올 떄 모드 변경하는 것으로 수정해보았으나 전혀 작동하지 않습니다.

                            },
                    tag: test,
                    selection: $selectedTest
                ) {
                    EmptyView()
                }
                .hidden()
                .environmentObject(generateHistory)
            )
            .sheet(isPresented: $isPopupPresented) {
                // 팝업을 표시하는 뷰
                TestStartPopupView(isPopupPresented: $isPopupPresented, selectedTest: $selectedTest, selectedTestTemp: $selectedTestTemp, generatorViewMode: $generatorViewMode, oneByOne : $oneByOne, gonnaChange: $gonnaChange, gonnaShuffle: $gonnaShuffle)
            }
        }
        .navigationTitle(selectedSubject.subject)
        .onAppear() {
            checkTargetTest()
        }
    }

    
    func checkTargetTest() {
        // 향후 유연한 테스트들 관리를 위해 미리 추가한 구문입니다. 이 부분 기능 구현 추가해야 합니다. 2023. 6. 21. (-)
        if selectedSubject != nil {
            self.tests = selectedSubject.tests
        }
    }
}

struct SubjectView_Previews: PreviewProvider {
    static var previews: some View {
        let selectedSubject = TestSubject(testCategory: TestCategory(testDatabase: TestDatabase(UUID()), category: "변호사시험"), subject: "민사법")
        for i in 1...12 {
            selectedSubject.tests.append(Test(createDate: Date(), testSubject: TestSubject(testCategory: TestCategory(testDatabase: TestDatabase(UUID()), category: "변호사시험"), subject: "민사법"), revision: 0, isPublished: false, number: i))
            
        }
        return TestsView(selectedSubject: selectedSubject)
    }
}
