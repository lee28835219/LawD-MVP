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
    @StateObject private var setUp: SetUP = SetUP()
    @StateObject private var storageManager: StorageManager
    
    init() {
        print("Hello! TestGenerator Starts!")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        print("\(#file) 시작 -", dateFormatter.string(from: Date()))
        
        let testDatabase = TestDatabase(UUID())
        let storageManager = StorageManager(testDatabase)
        
        let constTestCat00 = TestCategory(testDatabase: testDatabase, category: "공인중개사시험")
        let constTestCat01 = TestCategory(testDatabase: testDatabase, category: "경찰공무원 채용시험")
        
        // 시연용으로 메모리에 직접 단순한 문제 5개를 추가함. 2023. 6. 22.
        let constTestCat = TestCategory(testDatabase: testDatabase, category: "★MVP 시연용★")
        let constTestSub = TestSubject(testCategory: constTestCat, subject: "헌법")
        let constTest = Test(createDate: Date(), testSubject: constTestSub, revision: 0, isPublished: true, number: 1)
        
        let que1 = Question(revision: 0, test: constTest, number: 1, questionType: QuestionType.Select, questionOX: QuestionOX.X, content: "인권에 관한 설명으로 옳지 않은 것은?", answer: 5)
        que1.notContent = "인권에 관한 설명으로 옳은 것은?"
        let sel11 = Selection(revision: 0, question: que1, number: 1, content: "타인에게 양도할 수 없다.")
        sel11.notContent = "타인에게 양도할 수 있다."
        let sel12 = Selection(revision: 0, question: que1, number: 2, content: "국가 권력이 함부로 침해할 수 없다.")
        sel12.notContent = "국가 권력에 의해 항상 제한할 수 있다."
        let sel13 = Selection(revision: 0, question: que1, number: 3, content: "사회 구성원 모두에게 부여된 권리이다.")
        sel13.notContent = "사회 구성원 모두에게 부여된 권리는 아니다."
        let sel14 = Selection(revision: 0, question: que1, number: 4, content: "태어날 때부터 인간에게 주어진 권리이다.")
        sel14.notContent = "태어날 때부터 인간에게 주어진 권리는 아니다."
        let sel15 = Selection(revision: 0, question: que1, number: 5, content: "국가의 법으로만 보장할 수 있는 권리이다.")
        sel15.notContent = "국가의 법으로만 보장할 수 있는 권리는 아니다."
        
        let que2 = Question(revision: 0, test: constTest, number: 2, questionType: QuestionType.Select, questionOX: QuestionOX.X, content: "인권 침해에 관한 설명으로 옳지 않은 것은?", answer: 1)
        que2.notContent = "인권 침해에 관한 설명으로 옳은?"
        let sel21 = Selection(revision: 0, question: que2, number: 1, content: "개인이나 단체에 의해서만 발생한다.")
        sel21.notContent = "개인이나 단체에 의해서만 발생하는 것은 아니다."
        let sel22 = Selection(revision: 0, question: que2, number: 2, content: "일상생활 전반에 걸쳐 다양한 형태로 나타난다.")
        sel22.notContent = "일상생활의 일부분에서만 나타난다."
        let sel23 = Selection(revision: 0, question: que2, number: 3, content: "그 사회의 잘못된 관습이나 불합리한 법률과 제도에 영향을 받는다.")
        sel23.notContent = "그 사회의 잘못된 관습이나 불합리한 법률과 제도에 영향을 받지는 않는다."
        let sel24 = Selection(revision: 0, question: que2, number: 4, content: "인권 감수성이 낮을수록 인권 침해 상황을 묵인할 가능성이 높아진다.")
        sel24.notContent = "인권 감수성이 낮을수록 인권 침해 상황을 묵인할 가능성이 낮아진다."
        let sel25 = Selection(revision: 0, question: que2, number: 5, content: "사회 구성원들의 잘못된 고정 관념이나 편견에 영향을 받아 발생한다.")
        sel25.notContent = "사회 구성원들의 잘못된 고정 관념이나 편견에 영향을 받아 발생하는 것은 아니다."
        
        let que3 = Question(revision: 0, test: constTest, number: 3, questionType: QuestionType.Select, questionOX: QuestionOX.X, content: "근로자에 관한 설명으로 옳지 않은 것은?", answer: 4)
        que3.notContent = "근로자에 관한 설명으로 옳은?"
        let sel31 = Selection(revision: 0, question: que3, number: 1, content: "근로 시간이 짧은 아르바이트 학생도 근로자에 포함된다.")
        sel31.notContent = "근로 시간이 짧은 아르바이트 학생은 근로자에 포함되지 않는다."
        let sel32 = Selection(revision: 0, question: que3, number: 2, content: "어떤 직업에 종사하든 임금을 받는다면 근로자에 해당한다.")
        sel32.notContent = "임금을 받는다고 하더라도 종사하는 직업에 따라 근로자에 해당하지 않을 수 있다."
        let sel33 = Selection(revision: 0, question: que3, number: 3, content: "국가 기관에서 공무를 수행하는 공무원도 근로자에 해당한다.")
        sel33.notContent = "국가 기관에서 공무를 수행하는 공무원은 근로자에 해당하지 않는다."
        let sel34 = Selection(revision: 0, question: que3, number: 4, content: "자원봉사자는 근로 기간과 장소에 상관없이 근로자에 해당한다.")
        sel34.notContent = "자원봉사자는 임금을 지급받지 않으므로 근로자로 분류하지 않는다."
        let sel35 = Selection(revision: 0, question: que3, number: 5, content: "스스로 자신의 사업을 하는 자영업자는 근로자에 포함되지 않는다.")
        sel35.notContent = "스스로 자신의 사업을 하는 자영업자도 근로자에 포함된다."
        
        //        let que4 = Question(revision: 0, test: constTest, number: 1, questionType: QuestionType.Select, questionOX: QuestionOX.X, content: "인권에 관한 설명으로 옳지 않은 것은?", answer: 5)
        //        que4.notContent = "인권에 관한 설명으로 옳은 것은?"
        //        let sel41 = Selection(revision: 0, question: que4, number: 1, content: "타인에게 양도할 수 없다.")
        //        sel41.notContent = "타인에게 양도할 수 있다."
        //        let sel42 = Selection(revision: 0, question: que4, number: 2, content: "국가 권력이 함부로 침해할 수 없다.")
        //        sel42.notContent = "국가 권력에 의해 항상 제한할 수 있다."
        //        let sel43 = Selection(revision: 0, question: que4, number: 3, content: "사회 구성원 모두에게 부여된 권리이다.")
        //        sel43.notContent = "사회 구성원 모두에게 부여된 권리는 아니다."
        //        let sel44 = Selection(revision: 0, question: que4, number: 4, content: "태어날 때부터 인간에게 주어진 권리이다.")
        //        sel44.notContent = "태어날 때부터 인간에게 주어진 권리는 아니다."
        //        let sel45 = Selection(revision: 0, question: que4, number: 5, content: "국가의 법으로만 보장할 수 있는 권리이다.")
        //        sel45.notContent = "국가의 법으로만 보장할 수 있는 권리는 아니다."
        //
        //        let que5 = Question(revision: 0, test: constTest, number: 1, questionType: QuestionType.Select, questionOX: QuestionOX.X, content: "인권에 관한 설명으로 옳지 않은 것은?", answer: 5)
        //        que5.notContent = "인권에 관한 설명으로 옳은 것은?"
        //        let sel51 = Selection(revision: 0, question: que5, number: 1, content: "타인에게 양도할 수 없다.")
        //        sel51.notContent = "타인에게 양도할 수 있다."
        //        let sel52 = Selection(revision: 0, question: que5, number: 2, content: "국가 권력이 함부로 침해할 수 없다.")
        //        sel52.notContent = "국가 권력에 의해 항상 제한할 수 있다."
        //        let sel53 = Selection(revision: 0, question: que5, number: 3, content: "사회 구성원 모두에게 부여된 권리이다.")
        //        sel53.notContent = "사회 구성원 모두에게 부여된 권리는 아니다."
        //        let sel54 = Selection(revision: 0, question: que5, number: 4, content: "태어날 때부터 인간에게 주어진 권리이다.")
        //        sel54.notContent = "태어날 때부터 인간에게 주어진 권리는 아니다."
        //        let sel55 = Selection(revision: 0, question: que5, number: 5, content: "국가의 법으로만 보장할 수 있는 권리이다.")
        //        sel55.notContent = "국가의 법으로만 보장할 수 있는 권리는 아니다."
        
        
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
                .environmentObject(setUp)
                .environmentObject(storageManager)
                .environmentObject(GenerateHistory())
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
