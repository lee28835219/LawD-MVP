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
    
    /// json에서 인스턴스를 불러오는 QuestionData의 클래스 함수입니다.
    class func decode(fromData data: Data) -> QuestionData? {
        do {
            // JSONDecoder를 생성합니다.
            let decoder = JSONDecoder()
            
            let dateFormater = DateFormatter()
            dateFormater.setMyDateString() // json에 저장되는 일시는 모두 myDateSting 형식으로 저장되었으므로, 디코딩도 이에 맞춰야"만" 합니다.
            decoder.dateDecodingStrategy = .formatted(dateFormater)
            
            // JSON 데이터를 디코딩하여 원하는 데이터 모델로 변환합니다.
            let questionData = try decoder.decode(QuestionData.self, from: data)
            
            return questionData
        } catch {
            print("JSON 디코딩 오류: \(error)")
            return nil
        }
    }
    
    /// 1. 특정 경로 폴더에 있는 json파일 중
    /// 2. 입력받은 prefix에 맞는 파일들의 URL을 찾고
    /// 3. 이를 내림차순으로 정렬하여 어레이로 반환합니다.
    /// 2023.09.19. 챗지피티가 작성하였습니다.
    class func fetchJSONFiles(directoryPath : String, prefixString : String) -> [URL] {
        let fileManager = FileManager.default
        var jsonFiles: [URL] = []

        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: URL(fileURLWithPath: directoryPath), includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
            
            for fileURL in fileURLs {
                if fileURL.pathExtension == "json" {
                    let fileName = fileURL.deletingPathExtension().lastPathComponent
                    if fileName.hasPrefix(prefixString) {
                        jsonFiles.append(fileURL)
                    }
                }
            }
            
            // 내림차순으로 파일 목록 정렬
            jsonFiles.sort { (url1, url2) -> Bool in
                return url1.lastPathComponent > url2.lastPathComponent
            }
        } catch {
            print("Error: \(error)")
        }
        
        return jsonFiles
    }
}
