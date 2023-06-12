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
    
    var body: some View {
        SwiftUI.List(selectedCategory.testSubjects, id: \.self) { subject in
                NavigationLink(destination: SubjectView(selectedSubject: subject)) {
                Text(subject.subject)
                        .onTapGesture {
                            print("\(subject.subject) 선택됨.")
                        }
            }
            .navigationTitle(selectedCategory.category)
        }
    }
}
