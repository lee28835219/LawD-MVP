//
//  StorageManager.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 16..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation
import Combine

// json 파일에서 테스트를 가져오는 매우 중요한 클래스
class StorageManager: ObservableObject {
    
    let testDatabase : TestDatabase
    let rootURL : URL
    
    let isLocal : Bool = true // 2023. 7. 8. 추가함. 모든 시뮬레이션에서 동일한 데이터를 이용하기 위한 고육지책으로, 퍼블리 전 꼭 확인해야할 부분입니다. (-)
    @Published var log : String
    
    init(_ testDatabase : TestDatabase) {
        
        self.testDatabase = testDatabase
        
        log = ConsoleIO.newLog("\(#file)")
        
        // 작업을 시작할 디렉토리를 설정 Document/Test/Storage/DB의 key 2017. 5.
        // 중요!! 만약 isLocal일 경우에는, 현 프로젝트 안에 있는 db가 rootURL이 됩니다. 아닐 경우에는 실제 구동되는 앱이 가진 다큐먼트 안에 있는 db가 rootURL이 됩니다. 2023. 7. 8.
        if isLocal {
            self.rootURL = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("Data").appendingPathComponent("Storage").appendingPathComponent(testDatabase.key)
        } else {
            if let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                self.rootURL = documentURL.appendingPathComponent("TestGenerator").appendingPathComponent("Data").appendingPathComponent("Storage").appendingPathComponent(testDatabase.key) // TestGenerator 폴더가 꼭 필요한지 확인필요합니다. 2023. 7. 8. (-)
                if FileManager.default.fileExists(atPath: rootURL.path, isDirectory: nil) {
                    log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "\(rootURL.path)에서 \(testDatabase.key) testDB를 불러오기 시작")
                } else {
                    log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "\(rootURL.path)가 존재하지 않아 \(testDatabase.key) testDB를 불러오지 않음")
                    return
                }
            } else {
                fatalError("시스템의 Document 폴더가 존재하지 않음")
            }
        }
        print("storageManager.rootURL - \(Date().HHmmSS) : \(self.rootURL)")
        
        
        guard let tempDatabase =  _parseJsons(.getNewer) else {
            log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "\(rootURL.path.precomposedStringWithCompatibilityMapping)에 있는 Json 파일 파싱실패")
            log = ConsoleIO.closeLog(log, file: "\(#file)")
            return
        }
        
        let databaseSameKeyRemoved = _defineRangeOfTestToBeRefresh(of: tempDatabase, ioU : nil)
        let removeResult = databaseSameKeyRemoved.removeVoidPointer()
        for str in removeResult {
            log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "\(str) 키는 시험회차가 없어서 제거함")
        }
        
        testDatabase.categories.append(contentsOf: databaseSameKeyRemoved.categories)
        
        log = ConsoleIO.closeLog(log, file: "\(#file)")
        
    }
}

enum ParseJsonsOption : String {
    case getOlder
    case getNewer
}
