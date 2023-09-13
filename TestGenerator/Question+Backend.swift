//
//  Question+Backend.swift
//  TestGenerator
//
//  Created by Masterbuilder on 2023/09/13.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import Foundation

extension Question {
    // 2023. 9. 13. UUID로 문제를 식별하는 기술을 도입하기 시작했습니다. 혁명적 변화로 그 영향도를 계속 검토해야 합니다. (-)
    // UUID로 데이터베이스 안의 Question 인스턴스를 반환해주는 함수입니다.
    class func findInstance(testDatabase: TestDatabase, id: UUID?) -> Question? {
        var findedQestion : Question? = nil
        if let idWrapped = id {
            for cat in testDatabase.categories {
                for sub in cat.testSubjects {
                    for test in sub.tests {
                        for question in test.questions {
                            if question.id == idWrapped {
                                findedQestion = question
                            }
                        }
                    }
                }
            }
        } else {
            print("유효하지 않은 id입력됨")
        }
        return findedQestion
    }
}
