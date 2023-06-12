//
//  SubjectView.swift
//  TestGeneratorIOS
//
//  Created by Masterbuilder on 2023/06/17.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import SwiftUI

// 민사법
struct SubjectView: View {
    let selectedSubject: TestSubject
//    @State var generator = Generator()  //아무레도 이 부분은 여기서 정의하는게 괜히 삽질인거 같아 주석처리함 2023. 6. 19.
    
    var body: some View {
        SwiftUI.List(selectedSubject.tests, id: \.self) { test in
//            NavigationLink(destination: TestView(selectedTest: test)) { //2023. 6. 17. GenratorView로 변경함.
            NavigationLink(destination: GeneratorView(selectedTest: test)) {
                Button(action: {
                        print("\(test.key)가 클릭됨.")
                    }) {
                        Text(test.key)
                            .font(.body)
                            .foregroundColor(Color.black)
                    }
                    .buttonStyle(DefaultButtonStyle())
//                    .onTapGesture {
//                        print("\(test.key)가 클릭됨.")
//                    }
            }
                .navigationTitle(selectedSubject.subject)
//            온 텝 제스처는 네비게이션 링크와 충돌하는 듯 합니다. 그 작동원리를 이해해야할 필요 있습니다. 2023. 6. 19. (-)
//                .onTapGesture {
//                    print("\(test.key)가 클릭됨.")
//                }
        }
    }
}

//struct SubjectView_Previews: PreviewProvider {
//    static var previews: some View {
//        SubjectView()
//    }
//}
