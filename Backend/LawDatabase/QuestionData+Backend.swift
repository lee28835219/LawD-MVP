//
//  QuestionData+Backend.swift
//  LawD MVP
//
//  Created by Masterbuilder on 2023/09/19.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import Foundation

extension QuestionData {
    // (=) 2023.09.19. 이제 문_FB4CFC8~.json을 불러와서, 이를 인스턴스로 만드는 디코딩 작업을 시작했습니다.
    
    
    /// 개발용 함수로써, 개발용 문제 인스턴스 queD1을 생성, 저장한 뒤 이를 반환까지 합니다.
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
    
    /// ★★★★★★ 문제에서의 json파일명을 결정하는 함수입니다.
    ///
    /// 2023.09.19.기준으로 네이밍룰은,
    /// 문_id(앞 7자리)_saveDate.json이며,
    /// self.modifiedDate 관리를 위해 저장당시의 Date를 같이 반환합니다.
    ///
    /// 즉, (json파일명, 저장일시)를 반환합니다.
    func jsonName() -> (String, Date) {
        let uuidString7 = self.id.uuidString.prefix(7) // 7자리 UUID가 중복될 확률은 매우 낮아서 0.000000000909% 정도입니다. 이는 매우 낮은 확률을 나타내며, 현실적으로는 중복될 가능성을 걱정할 필요가 없습니다. 7자리 UUID는 충분히 고유합니다.
        let saveDate = Date()
        let dateFormatted = saveDate.myDateStirng
        return ("문_" + uuidString7 + "_" + dateFormatted + ".json",saveDate)
    }
    
    /// josn으로 아카이브 하는 함수로써, 저장에 성공할 경우 true를 반환합니다.
    func saveJson(url: URL) -> Bool{
        /// 앞으로 아래 인코더 형식을을 구조화하여 모듈화 함으로써
        /// 코드의 경제성 및 안정성을 꽤해야 합니다.
        /// ★★★ 2023.09.19. (-)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted // 읽기 쉬운 형식으로 Data를 저장합니다.
        let dateFormater = DateFormatter()
        dateFormater.setMyDateString() // json에 저장되는 일시는 모두 myDateSting 형식으로 저장합니다.
        encoder.dateEncodingStrategy = .formatted(dateFormater)

        do {
            // json파일명 등을 정의하는 부분입니다.
            let (jsonName, saveDate) = self.jsonName()
            
            /// reviion 및 수정일시 변경 부분입니다.
            /// revion 관리 내용을 json에 저장하기 위해 다소 앞에 위치하고 있는데,
            /// 만약 인스턴스 정보를 여기서 수정했음에도 불구하고,
            /// 파일 저장이 실패할 경우 내용이 꼬일 우려가 있어 그 영향도 검토 필요해 보입니다. 2023.09.19. (-)
            ///
            /// 그리고, 첫 인스턴스 생성 후 저장 시에도 revition이 올라가는 문제가 있어,
            /// 일단은, modifiedDate가 nil이 아닐 경우(= revion이 0)에만 이를 업데이트하도록 짜보았습니다.
            if modifiedDate != nil {
                self.revision = self.revision + 1
                self.modifiedDate = saveDate
            }
            
            // json 데이터로 인코딩
            let jsonData = try encoder.encode(self)
            
            // json 데이터를 문자열로 변환
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                
                print("json: \n\(jsonString)")
                
                
                do {
                    let fileURL = url.appending(path: "\(jsonName)")
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
