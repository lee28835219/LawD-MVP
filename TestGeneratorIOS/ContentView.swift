//
//  ContentView.swift
//  TestGeneratorIOS
//
//  Created by Masterbuilder on 2023/06/13.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    @EnvironmentObject private var storageManager: StorageManager
    @State private var selectedTab = 0
        
    var body: some View {
        TabView(selection: $selectedTab) {
            // 시험 탭
            NavigationView {
                SwiftUI.List(storageManager.testDatabase.categories, id: \.self) { category in
                    NavigationLink(destination: CategoryView(selectedCategory: category)) {
                        HStack{
                            Image(systemName: "cabinet.fill")
                            Text(" [\(category.category)]")
                        }
                    }
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
                SwiftUI.List(books, id: \.self) { books in
                    NavigationLink(destination:                     Text("개발예정"))
                    {
                        Text(books)
                    }
                    
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("주석서")
            }
                .tabItem {
                    Label("교과서", systemImage: "text.book.closed")
                }
                .tag(1)
            
            NavigationView {
                let cases = ["헌법", "민법", "민사소송법", "상법", "형법", "형사소송법", "행정법"]
                SwiftUI.List(cases, id: \.self) { casE in
                    NavigationLink(destination:                     Text("개발예정"))
                    {
                        Text(casE)
                            .onTapGesture {
                                print("\(casE) 선택됨")
                            }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("판례")
            }
                .tabItem {
                    Label("판례", systemImage: "newspaper")
                }
                .tag(2)
            
            Text("개발예정")
                .tabItem {
                    Label("나의 이력", systemImage: "person.fill")
                }
                .tag(3)
            
            Text("설정")
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
    }
}
