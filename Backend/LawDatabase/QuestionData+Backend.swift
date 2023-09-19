//
//  QuestionData+Backend.swift
//  LawD MVP
//
//  Created by Masterbuilder on 2023/09/19.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import Foundation

extension QuestionData {
    /// 개발용 함수로써, queD1을 생성, 저장한 뒤 이를 반환까지 합니다.
    class func saveQueD1() -> QuestionData {
        let queD1 = QuestionData(id: UUID(uuidString: "FB4CFC83-69AC-4892-8EBB-03789DCDDC1C")!, content: "인권에 관한 설명으로 옳지 않은 것은?", questionType: .Select, questionOX: .X)
        if queD1.saveJson(url: URL(filePath: "/Users/lee/Library/CloudStorage/Dropbox/DropDocument/ LawDatabase/ Temp")) {
            // FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            print("queD1이 저장됨")
        } else {
            print("queD1이 저장되지 않음")
        }
        
        return queD1
    }
    
    /// ★★★★★★ json파일명을 결정하는 함수입니다.
    /// 2023.09.19.기준으로 네이밍룰은,
    /// Q-id(앞 7자리)-creationDate.json입니다.
    func jsonName() -> String {
        let uuidString7 = self.id.uuidString.prefix(7) // 7자리 UUID가 중복될 확률은 매우 낮아서 0.000000000909% 정도입니다. 이는 매우 낮은 확률을 나타내며, 현실적으로는 중복될 가능성을 걱정할 필요가 없습니다. 7자리 UUID는 충분히 고유합니다.
        let dateFormatted = self.creationDate.myDateStirng
        return "Q-" + uuidString7 + "-" + dateFormatted + ".json"
    }
    
    /// josn으로 아카이브 하는 함수로써, 저장에 성공할 경우 true를 반환합니다.
    func saveJson(url: URL) -> Bool{
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted // 읽기 쉬운 형식으로 출력

        do {
            // json 데이터로 인코딩
            let jsonData = try encoder.encode(self)
            
            // json 데이터를 문자열로 변환
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                
                print("json: \n\(jsonString)")
                
                let fileURL = url.appending(path: "\(self.jsonName())")
                do {
                    try jsonString.write(to: fileURL, atomically: true, encoding: .utf8)
                    print("파일 저장 성공: \(fileURL.path)")
                    return true
                } catch {
                    print("파일 저장 실패: \(error.localizedDescription)")
                }
            } else {
                print("json 문자열 변환 에러")
            }
        } catch {
            print("json 인코딩 에러: \(error.localizedDescription)")
        }
        return false
    }
}
