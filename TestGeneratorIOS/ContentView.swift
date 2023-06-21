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
    @State private var selectedTab = 0

    @State private var problemCount = ""
    @State private var isModified = false


        
    var body: some View {
        TabView(selection: $selectedTab) {
            // 시험 탭
            NavigationView {
                List(storageManager.testDatabase.categories, id: \.self) { category in
                    NavigationLink(destination: CategoryView(selectedCategory: category)) {
                        HStack{
                            Image(systemName: "cabinet.fill")
                            Text(" [\(category.category)]")
                        }
                    }
                        .environmentObject(storageManager)
                        .environmentObject(generateHistory)
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("시험목록")
            }
                .tabItem {
                    Label("시험", systemImage: "list.bullet")
                }
                .tag(0)
            
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
                .tag(1)
            
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
                .tag(2)
            
            HistoryContentView()
                .environmentObject(storageManager)
                .environmentObject(generateHistory)
                .tabItem {
                    Label("나의 이력", systemImage: "person.fill")
                }
                .tag(3)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("생성할 문제 수")
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
