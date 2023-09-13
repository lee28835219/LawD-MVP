//
//  ContentView.swift
//  TestGeneratorIOS
//
//  Created by Masterbuilder on 2023/06/13.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    @EnvironmentObject private var setUP: SetUP
    @EnvironmentObject private var storageManager: StorageManager
    @EnvironmentObject var generateHistory : GenerateHistory
    @State private var selectedTab = 2  // 디폴트 탭 설정

    @State private var problemCount = ""
    @State private var isModified = false
        
    var body: some View {
        TabView(selection: $selectedTab) {
            
            // -2. 판례 탭
            NavigationView {
                let cases = ["헌법", "민법", "민사소송법", "상법", "형법", "형사소송법", "행정법"]
                SwiftUI.List(cases, id: \.self) { casE in
                    NavigationLink(destination: Text("개발예정"))
                    {
                        HStack{
                            Image(systemName: "cabinet.fill")
                            Text(" [\(casE)]")
                                .onTapGesture {
                                    print("\(casE) 선택됨")
                                }
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("판례목록")
            }
                .tabItem {
                    Label("판례", systemImage: "newspaper")
                }
                .tag(0)
            
            // -1. 변호사시험, 공인중개사시험, ... 탭
            NavigationView {
                List(storageManager.testDatabase.categories, id: \.self) { category in
                    NavigationLink(destination: CategoryView(selectedCategory: category)) {
                        HStack{
                            Image(systemName: "cabinet.fill")
//                                .foregroundColor(.purple)
                            Text(" [\(category.category)]")
                                .bold()
                            if category.category == "변호사시험" {
                                Image(systemName: "plus.message.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                        .environmentObject(storageManager)
                        .environmentObject(generateHistory)
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("시험목록")
            }
                .tabItem {
                    Label("시험풀기", systemImage: "list.bullet")
                }
                .tag(1)
            
            // 2. 교과서 탭  ..comment out, 2023. 9. 8.
            // 주석서를 기초로 만드려 했으나, 컨텐츠가 너무 많아 포기한 것... 이걸 다시 살릴 수 있을까? 그 때가 컨텐츠를 다 채우려 할 때일 것.
            /*
                NavigationView {
                    let books = ["헌법", "민법", "민사소송법", "상법", "형법", "형사소송법", "행정법"]
                    List(books, id: \.self) { books in
                        NavigationLink(destination:                     Text("개발예정"))
                        {
                            HStack{
                                Image(systemName: "cabinet.fill")
                                Text(" [\(books)]")
                            }
                        }
                        
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle("교과서목록")
                }
                .tabItem {
                    Label("교과서", systemImage: "text.book.closed")
                }
                .tag(2)
             */
            
            // 0. 담벼락 탭
            WhatsNewView()
                .tabItem {
                    Label("새소식", systemImage: "flame.fill")
                }
                .tag(2)
            
            // 1. 이력 탭
            HistoryContentView()
                .environmentObject(storageManager)
                .environmentObject(generateHistory)
                .tabItem {
                    Label("시험이력", systemImage: "person.fill")
                }
                .tag(3)
            
            // 2. 설정 탭
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("생성할 문제 수")
                        .font(.title2)
                        .bold()
                    TextField("숫자", text: $problemCount)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .frame(width: 200)
                    Button(action: {
                        if let count = Int(problemCount) {
                            setUP.numberOfGenerateSolvers = count
                            isModified = true // 수정되었다는 상태를 true로 설정
                        } else {
                            print("올바른 숫자를 입력해주세요.")
                        }
                    }) {
                        Text("확인")
                            .bold()
                    }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .alert(isPresented: $isModified) {
                            Alert(
                                title: Text("수정 완료"),
                                message: Text("설정이 수정되었습니다."),
                                dismissButton: .default(Text("확인"))
                            )
                        }
                    Spacer()
                }
                Spacer()
                HStack {
                    Image(systemName: "hammer.fill")
                    Text("설정 추가예정")
                }
                .font(.title)
                Spacer()
                
                
            }
                .tabItem {
                    Label("설정", systemImage: "gearshape")
                }
                .tag(4)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(StorageManager(TestDatabase(UUID())))
            .environmentObject(GenerateHistory())
    }
}
