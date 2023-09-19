//
//  QuestionData+Dev.swift
//  LawD MVP
//
//  Created by Masterbuilder on 2023/09/19.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import Foundation

/// 개발용으로 사용하는 함수 모음입니다.
extension QuestionData {
    
    class func loadLatestQueD1() -> QuestionData {
        let jsonFiles = QuestionData.fetchJSONFiles(directoryPath: "/Users/lee/Library/CloudStorage/Dropbox/DropDocument/ LawDatabase/ Temp", prefixString: "문_9A8B807")
        jsonFiles.first
        
        return QuestionData(id: UUID(uuidString: "9A8B8074-9A6D-415A-A1F1-F54EF01844B8")!, content: "상계에 관한 설명 중 옳은 것은?", questionType: .Select, questionOX: .O)
    }
    
    /// 개발용 함수로써, 개발용 문제 인스턴스 queD1을 생성, 저장한 뒤 이를 반환까지 합니다.
    class func saveQueD1() -> QuestionData {
        let queD1 = QuestionData(id: UUID(uuidString: "9A8B8074-9A6D-415A-A1F1-F54EF01844B8")!, content: "상계에 관한 설명 중 옳은 것은?", questionType: .Select, questionOX: .O)
        queD1.notContent = "상계에 관한 설명 중 옳지 않은 것은?"
        queD1.contentNote = "(다툼이 있는 경우에는 판례에 의함)"
        
        
        if queD1.saveJson(url: URL(filePath: "/Users/lee/Library/CloudStorage/Dropbox/DropDocument/ LawDatabase/ Temp")) {
            // FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            print("queD1이 저장됨")
        } else {
            print("queD1이 저장되지 않음")
        }
        
        return queD1
    }
    
}
