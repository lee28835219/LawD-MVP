//
//  CategoryView.swift
//  TestGeneratorIOS
//
//  Created by Masterbuilder on 2023/06/20.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import SwiftUI

// 변호사시험
struct CategoryView: View {
    let selectedCategory: TestCategory
    @EnvironmentObject var generateHistory : GenerateHistory

    var body: some View {
        List(selectedCategory.testSubjects, id: \.self) { subject in
                NavigationLink(destination: TestsView(selectedSubject: subject)) {
                    Text(subject.subject)
                }
                .environmentObject(generateHistory)
            .navigationTitle(selectedCategory.category)
        }
    }
}
