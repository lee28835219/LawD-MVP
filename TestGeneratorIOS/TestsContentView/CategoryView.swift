//
//  CategoryView.swift
//  TestGeneratorIOS
//
//  Created by Masterbuilder on 2023/06/20.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import SwiftUI

// 민사법
struct CategoryView: View {
    let selectedCategory: TestCategory
    @EnvironmentObject var generateHistory : GenerateHistory

    var body: some View {
        List(selectedCategory.testSubjects, id: \.self) { subject in
//            NavigationLink(destination: TestsView(selectedSubject: subject, selectedTestTemp: Test(createDate: Date(), testSubject: TestSubject(testCategory: TestCategory(testDatabase: TestDatabase(UUID()), category: "임시"), subject: "임시"), revision: 0, isPublished: false, number: 0))) { // 추후 이니셜라이져 검토 필요. 컴파일 에러를 방지하기위해 넣은 영 이상한 구문입니다. 2023. 6 .25.
            NavigationLink(destination: TestsView(selectedSubject: subject)) {
                    Text(subject.subject)
                }
                .environmentObject(generateHistory)
            .navigationTitle(selectedCategory.category)
        }
    }
}
