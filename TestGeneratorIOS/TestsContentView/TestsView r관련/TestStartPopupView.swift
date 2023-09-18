//
//  TestStartPopupView.swift
//  TestGeneratorIOS
//
//  Created by Masterbuilder on 2023/06/19.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import SwiftUI

struct TestStartPopupView: View {
    @Binding var isPopupPresented : Bool
    @Binding var selectedTest: Test?
    @Binding var selectedTestTemp: Test?
    
    @Binding var generatorViewMode : GeneratorViewMode
    @Binding var oneByOne: Bool  //자꾸 원하는데로 작동하지 않아, 그냥 모드를 바인딩해서 받아오기로 수정했으나, 이 파라미터도 사용자가 네베게이션 뷰를 뒤로 왓을 때, 토글의 디폴트 값을 유지하기 위해 필요합니다.
    
    // oneByone 변수와 다르게 이 변수들은 직접 테스츠뷰로 전달된 후, 제네레이터를 불러올 때 사용됩니다.
    @Binding var gonnaChange: Bool
    @Binding var gonnaShuffle : Bool // 아직 구현되지 않아 구현이 필요합니다. 2023. 6 .24. (-)

    var body: some View {
        VStack {
            Spacer()
            VStack {
                if let selectedTestTemp = selectedTestTemp {
                    Text("\(selectedTestTemp.getKeySting())")
                    Text("총 \(selectedTestTemp.questions.count)문제를 풀기 시작할까요?")
                } else {
                    fatalError("잘못된 시험을 선택한 채 testStartPopup을 호출하였음.")
                }            }
                .font(.title2)
                .bold()
            Spacer()
            let minLen = CGFloat(0) // !!!레이아웃이 엉망이 되어 부득이 추가한 구문을 추후 동적으로 할당 필요합니다. 2023. 6. 21. (-)
            
            // "한 문제씩" 토글
            HStack {
                Spacer(minLength: minLen)
                Toggle(isOn: $oneByOne) {
                    HStack {
                        Image(systemName: "chevron.right.circle.fill")
                        Text("한 문제씩")
                    }
                }
                Spacer(minLength: minLen)
            }
            .toggleStyle(SwitchToggleStyle(tint: .accentColor))
            
            // "문제변경" 토글
            HStack {
                Spacer(minLength: minLen)
                Toggle(isOn: $gonnaChange) {
                    HStack {
//                        Image(systemName: "arrow.triangle.2.circlepath") // '문제변경' 텍스트에 대한 아이콘
                        Text("🔄")
                        Text("문제변경")
                    }
                }
                Spacer(minLength: minLen)
            }
            .toggleStyle(SwitchToggleStyle(tint: .accentColor))
            
            // "순서섞기" 토글
            HStack {
                Spacer(minLength: minLen)
                Toggle(isOn: $gonnaShuffle) {
                    HStack {
//                        Image(systemName: "shuffle") // '순서섞기' 텍스트에 대한 아이콘
                        Text("🔀")
                        Text("순서섞기")
                    }
                }
                Spacer(minLength: minLen)
            }
            .toggleStyle(SwitchToggleStyle(tint: .accentColor))
            
            // 시작 및 취소 버튼
            Spacer()
            HStack{
                Spacer()
                // 시작 버튼
                Button(action: {
                    isPopupPresented = false // Trigger the NavigationLink
                    generatorViewMode = .test(oneByOne: oneByOne)
                    selectedTest = selectedTestTemp // TestsView에서 선택하여 바인딩하여 보내준 selectedTest 변수에, 위 뷰가 이 뷰를 호출하면서 검토를 부탁한 selectedTestTemp 변수를 사용자의 시작 버튼 탭을 트리거로 확정하는 구문입니다. 이로 인해 기존 nil이던 selectedTest 변수는 정해지며(다른 방법으로는 리스트의 텍스트뷰 탭할 경우 정해지는 경우입니다) test모드의 제네레이터가 실행될 것입니다.,
                    print("TestStartPopup의 시작 버튼이 선택되었으므로, \(selectedTest?.getKeySting() ?? "알수 없는 시험") 문제풀이를 시작.")
                    print("한문제씩: \(oneByOne)")
                    print("문제변경: \(gonnaChange)")
                }) {
                    HStack {
                        Image(systemName: "play.fill")  // '시작' 버튼에 대한 아이콘
                        Text("시작")
                    }
                }
                Spacer()
                Button(action: {
                    isPopupPresented = false
                }) {
                    HStack {
                        Image(systemName: "xmark")  // '취소' 버튼에 대한 아이콘
                        Text("취소")
                    }
                }
                Spacer()
            }
            Spacer()
        }
        .padding()
//        .onAppear() {
//            if let selectedTest = selectedTest {
//                test = selectedTest
//            } else {
//                fatalError("잘못된 테스트를 선택하여 테스트스타트팝업을 호출함.")
//            }
//        }
    }
}

//struct TestStartPopoverView_Previews: PreviewProvider {
//    static var previews: some View {
//        let isPopupPresented = Binding.constant(true)
//        let test = Test(createDate: Date(), testSubject: TestSubject(testCategory: TestCategory(testDatabase: TestDatabase(UUID()), category: "변호사시험"), subject: "민사법"), revision: 0, isPublished: true, number: 1)
//        let selectedTest = Binding.constant(test as Test?)
//
//        let oneByOne = Binding.constant(false)
//        let gonnaChange = Binding.constant(true)
//        let gonnaShuffle = Binding.constant(false)
//
//        return TestStartPopupView(isPopupPresented: isPopupPresented, selectedTest: selectedTest, test: test, g: oneByOne, gonnaChange: gonnaChange, gonnaShuffle: gonnaShuffle)
//    }
//}
