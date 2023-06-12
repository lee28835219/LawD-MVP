//
//  TestStartPopoverView.swift
//  TestGeneratorIOS
//
//  Created by Masterbuilder on 2023/06/19.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import SwiftUI

struct TestStartPopoverView: View {
    @Binding var isPresented: Bool
    @Binding var publishMode: Bool
    @Binding var testMode: Bool
    @Binding var gonnaShuffle: Bool
    
    @Binding var generator : Generator
    
    var body: some View {
//        VStack {
        if generator.solvers.count > 0 {
            Button(action: {
                //                    withAnimation() { // 애니메이션 옵션 설정, 작동하지 않아 수정 필요 2023. 6. 19. (-)
                isPresented.toggle()
                publishMode.toggle()
                testMode = true
                gonnaShuffle = false
            }) {
                Label(
                        title: { Text("기존문제") },
                        icon: { Image(systemName: "square.and.pencil.circle.fill") } // 아이콘 추가
                    )
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.secondary)
                    .cornerRadius(10)
            }
            Button(action: {
                isPresented.toggle()
                publishMode.toggle()
                testMode = true
                gonnaShuffle = true
            }) {
                Label(
                        title: { Text("변경문제") },
                        icon: { Image(systemName: "square.and.pencil.circle.fill") } // 아이콘 추가
                    )
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.secondary)
                    .cornerRadius(10)
            }
        }
//                Button(action: {
//                    publishMode.toggle()
//                    testMode.toggle()
//                    withAnimation() { // 애니메이션 옵션 설정, 작동하지 않아 수정 필요 2023. 6. 19. (-)
//                        isPopoverPresented.toggle()
//                    }
//                }) {
//                    Text("선택지순서변경")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.secondary)
//                        .cornerRadius(10)
//                }
//                Button(action: {
//                    publishMode.toggle()
//                    testMode.toggle()
//                    withAnimation() { // 애니메이션 옵션 설정, 작동하지 않아 수정 필요 2023. 6. 19. (-)
//                        isPopoverPresented.toggle()
//                    }
//                }) {
//                    Text("선택지순서변경 + 문제변경")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.secondary)
//                        .cornerRadius(10)
//                }
//            } else {
//                fatalError("잘못된 시험문제 풀기 호출")
//            }
//            Spacer()
//            Button("닫기") {
//                isPopoverPresented = false
//                testMode.toggle()
//            }
        Button("닫기") {
            isPresented = false
            publishMode.toggle()
        }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

//struct TestStartPopoverView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestStartPopoverView()
//    }
//}
