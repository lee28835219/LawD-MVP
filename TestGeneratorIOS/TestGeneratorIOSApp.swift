//
//  TestGeneratorIOSApp.swift
//  TestGeneratorIOS
//
//  Created by Masterbuilder on 2023/06/13.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import SwiftUI
//import Foundation


@main
struct TestGeneratorIOSApp: App {
    @StateObject private var storageManager: StorageManager

    init() {
        print("Hello! TestGenerator Starts!")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        print("\(#file) 시작 -", dateFormatter.string(from: Date()))
        
        let testDatabase = TestDatabase(UUID())
        let storageManager = StorageManager(testDatabase)
        
        // 각 db를 내림차순으로 정렬
        testDatabase.categories.sort { $0.category > $1.category } // 카테고리는 내림차순
        for cat in testDatabase.categories {
            cat.testSubjects.sort { $0.subject < $1.subject } // 과목은 오름차순
            for sub in cat.testSubjects {
                sub.tests.sort { $0.key > $1.key } // 시험은 내림차순으로 하여 최신 시험이 위로
            }
        }
        
        print(storageManager.log)
        _storageManager = StateObject(wrappedValue: storageManager)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(storageManager)
        }
    }
    
    func setupInitialData() -> StorageManager {
        let testDatabase = TestDatabase(UUID())
        let storageManager = StorageManager(testDatabase)
        
        print("Hello! TestGenerator Starts!")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        print("\(#file) 시작 -", dateFormatter.string(from: Date()))
  
        //각 db를 내림차순으로 정렬
        testDatabase.categories.sort { $0.category > $1.category } //카테고리는 내림차순
        for cat in testDatabase.categories {
            cat.testSubjects.sort { $0.subject < $1.subject } //과목은 오름차순
            for sub in cat.testSubjects {
                sub.tests.sort { $0.key > $1.key } //시험은 내림차순으로 하여 최신 시험이 위로, 다만 시험을 관리하는 이름을 추가해서 안정적으로 관리하자 (-) 2023. 6. 14.
            }
        }
        return storageManager
    }
}

// 2023. 6. 13. 챗지피티
//
//SwiftUI에서는 iOS 13부터 사용 가능한 `@main` 어트리뷰트를 사용하여 앱의 진입점을 지정합니다. AppDelegate를 사용하는传统的인 iOS 앱 개발과는 달리 SwiftUI 앱은 `@main` 어트리뷰트를 사용하여 진입점을 지정하고, `App` 구조체를 활용하여 앱의 구조를 정의합니다.
//
//SwiftUI 앱에서 초기 데이터 설정을 수행하는 방법은 다소 다를 수 있으며, 주로 `@main` 어트리뷰트에서 앱의 진입점을 설정한 후 `App` 구조체 내에서 초기화 작업을 수행합니다. 이를 위해 `onAppear` 수식어를 사용하여 해당 뷰가 표시될 때 초기화 작업을 수행하도록 할 수 있습니다.
//
//다음은 SwiftUI에서 초기 데이터 설정을 수행하는 예시입니다:
//
//```swift
//import SwiftUI
//
//@main
//struct MyApp: App {
//
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//                .onAppear {
//                    setupInitialData()
//                }
//        }
//    }
//
//    func setupInitialData() {
//        // 여기에서 초기 데이터 설정 작업을 수행
//        // 예를 들어, 네트워크 요청을 통해 데이터를 가져오거나, 로컬 데이터베이스에서 데이터를 로드하는 등의 작업을 수행할 수 있습니다.
//    }
//}
//```
//
//위의 예시에서 `setupInitialData()` 함수는 초기 데이터 설정 작업을 수행합니다. `ContentView`가 표시될 때 (`onAppear` 수식어), 이 함수가 호출되어 초기 데이터 설정이 수행됩니다.
//
//SwiftUI에서는 `App` 구조체 내에서 초기화 작업을 수행하도록 설계되어 있으며, `onAppear` 수식어를 사용하여 뷰의 표시와 함께 초기화 작업을 연결하는 방식을 많이 활용합니다. 이를 통해 SwiftUI 앱에서도 초기 데이터 설정을 수행할 수 있습니다.
