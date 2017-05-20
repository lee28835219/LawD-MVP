//
//  StorageManager.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 16..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class StorageManager {
    
    let testDatabase : TestDatabase
    let rootURL : URL
    
    var log : String
    
    
    init(_ testDatabase : TestDatabase) {
        
        self.testDatabase = testDatabase
        
        log = ConsoleIO.newLog("\(#file)")
        
        
        // 작업을 시작할 디렉토리를 설정 Document/Test/Storage/DB의 key
        if let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            self.rootURL = documentURL.appendingPathComponent("TestGenerator").appendingPathComponent("Data").appendingPathComponent("Storage").appendingPathComponent(testDatabase.key)
            if FileManager.default.fileExists(atPath: rootURL.path, isDirectory: nil) {
                log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "\(rootURL.path)에서 \(testDatabase.key) testDB를 불러오기 시작")
            } else {
                log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "\(rootURL.path)가 존재하지 않아 \(testDatabase.key) testDB를 불러오지 않음")
                return
            }
        } else {
            fatalError("시스템의 Document 폴더가 존재하지 않음")
        }
        
        
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
    
    func _defineRangeOfTestToBeRefresh(of: TestDatabase, ioU : ConsoleIO?, _ gonnaForcedRefershAll : Bool = false) -> TestDatabase {
        // 내부함수용, 수시 업데이트용, 향후 쓸일이 잇으려나?
        if gonnaForcedRefershAll {
            return of
        }
        
        var refreshAll = false
        for category in of.categories {
            for subject in category.testSubjects {
                for newTest in subject.tests {
                    let originalTest = Test.checkSameKey(test: newTest, with: testDatabase)
                    
                    // io 도움없이 동일 키 있을 경우엔 자동으로 스킵하는 분기
                    // 초기화때에 사용
                    if originalTest == nil {
                        // tempTestDatabase에는 jsonFileName이 없을 수 없으므로 강제 !사용
                        log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "\(newTest.jsonFileName!) 신규 추가")
                    } else {
                        log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "이미 \(originalTest!.key)가 \(testDatabase.key) DB에 존재하여 추가하지 않음")
                        // tempDatabase에 있는 테스트를 삭제해야 한다. 이것이 곧 refresh입장에선 skip
                        subject.tests.remove(at: subject.tests.index(of: newTest)!)
                        //                            for ss in subject.tests {
                        print("\(subject.key)의 현재 시험회차",subject.tests)
                        //                            }
                    }
                    
                }
            }
        }
    }
    
    return of
}



//    func refresh(io : ConsoleIO) {
//        guard let tempDatabase = _parseJsons(.getNewer) else {
//            log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "\(rootURL.path.precomposedStringWithCompatibilityMapping)에 있는 json파일에서 초기화 데이터를 추출하려했으나 에러가 발생!!!")
//            return
//        }
//        
//        
//        let databaseSameKeyRemoved = _defineRangeOfTestToBeRefresh(of: tempDatabase, ioU: io)
//        databaseSameKeyRemoved.removeVoidPointer()
//        
//        testDatabase.categories.append(contentsOf: databaseSameKeyRemoved.categories)
//        
//        log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "\(rootURL.path.precomposedStringWithCompatibilityMapping)에 있는 json 파싱 완료")
//    }
    
    
    
    

//if let io = ioU {
//    if originalTest == nil || refreshAll {
//        io.writeMessage(to: .notice, "\(newTest.jsonFileName!) 신규 추가")
//    } else {
//        
//        var goon = true
//        while goon {
//            io.writeMessage(to: .input, "이미 \(originalTest!.key)가 \(testDatabase.key) DB에 존재함")
//            let (instGoon, value) = io.getInstGoon(io.getInput("refresh 진행함"+io.getHelp(.InstGoon)))
//            
//            
//            switch instGoon {
//            case .yes:
//                io.writeMessage(to: .notice, "refresh")
//                // tempDatabase에 잇는 테스트를 보존해야 한다. 이것이 곧 refresh입장에선 덮어쓰기
//                continue
//            case .skip:
//                io.writeMessage(to: .notice, "이미 \(originalTest!.key)가 \(testDatabase.key) DB에 존재하여 추가하지 않음")
//                // tempDatabase에 있는 테스트를 삭제해야 한다. 이것이 곧 refresh입장에선 skip
//                subject.tests.remove(at: subject.tests.index(of: newTest)!)
//                
//            case .stop:
//                io.writeMessage(to: .notice, "refresh를 중단함")
//                let voidDB = TestDatabase()
//                return voidDB
//                
//            case .all:
//                io.writeMessage(to: .notice, "모두 refresh 진행")
//                refreshAll = true
//                
//            case .unknown:
//                io.unkown(value, true)
//                continue
//            }
//            goon = false
//        }
//        
//    }
//} else {

    
    func _parseJsons(_ parseJsonsOption : ParseJsonsOption) -> TestDatabase? {
        let tempTestDatabase = TestDatabase()
        log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "옵션 \(parseJsonsOption)")
        
        
        // 시험명을 찾음
        // 시험명 먼저 찾고 과목찾고 회차찾아서 json을 찾는게 삽질이라는 생각이 좀 든다만 더 좋은 방법이 있는가?
        do {
            
            // Getting list of files in documents folder
            // http://stackoverflow.com/questions/27721418/getting-list-of-files-in-documents-folder
            
            let testCategoryDirectories = try FileManager.default.contentsOfDirectory(at: rootURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
            
            
            log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "시험명 확인시작")
            var categoryCounter = 0
            for testCategoryURL in testCategoryDirectories {
                
                
                // 디렉토리만 찾음
                // Check if NSURL is a directory
                // http://stackoverflow.com/questions/24208728/check-if-nsurl-is-a-directory
                
                var isDir: ObjCBool = ObjCBool(false)
                if FileManager.default.fileExists(atPath: testCategoryURL.path, isDirectory: &isDir) {
                    if isDir.boolValue {
                        
                        // 일단 디렉토리가 존재하면 새로운 클래스를 만들고 밑에 디렉토리/파일이 없을 경우 삭제를 해줘야 함
                        // 원래 데이터베이스를 지키기 위해 tempTestDatabase에서 일단 작업 시작
                        
                        // 하지만 이경우 중복되는 test key가 있는데도 테스트 추가 시점에선 키의 유일성 체크를 안하므로 부당
                        // 그래서 테스트 키 생성시점에서 이를 체크할지, 아니면 tempTestDatabase 추가 시점에서 이를 체크할지를 생각해야 함
                        
                        // lastPathComponent만을 가지고 string입력하면 한글이 깨지므로 잘 챙겨주는것 필요
                        // https://coderwall.com/p/mj_zma/korean-characters
                        // 한글 조합형 완성형 변환 Korean Characters
                        // 파일 시스템은 조합형을 쓰며, 시스템은 완성형을 쓴다. 초 삽질임 더 좋은 방법은 없는가? (+) 2017. 5. 17.
                        let newTestCategory = TestCategory(testDatabase: tempTestDatabase, category: testCategoryURL.lastPathComponent.precomposedStringWithCompatibilityMapping)
                        categoryCounter = categoryCounter + 1
                        
                        
                        log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: " [\(categoryCounter)] \(newTestCategory.key)")
                    }
                }
            }
            
            if categoryCounter == 0 {
                log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "시험명이 하나도 없음")
            } else {
                log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "총 시험명 \(categoryCounter)개 생성")
            }
            
        } catch {
            log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "시험명을 가져오면서 에러 발생")
        }
        
        
        
        
        // 시험과목을 찾음
        // 먼저 임시db에 있는 시험명 디렉토리를 가져옴
        for category in tempTestDatabase.categories {
            
            log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "\(category.key) 과목가져오기 시작")
            let categoryURL = rootURL.appendingPathComponent(category.category)
            do {
                
                // Getting list of files in documents folder
                // http://stackoverflow.com/questions/27721418/getting-list-of-files-in-documents-folder
                
                let subjectDirectories = try FileManager.default.contentsOfDirectory(at: categoryURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
                
                
                log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "  과목 확인시작")
                var subjectCounter = 0
                for subjectURL in subjectDirectories {
                    
                    
                    // 디렉토리만 찾음
                    // Check if NSURL is a directory
                    // http://stackoverflow.com/questions/24208728/check-if-nsurl-is-a-directory
                    
                    var isDir: ObjCBool = ObjCBool(false)
                    if FileManager.default.fileExists(atPath: subjectURL.path, isDirectory: &isDir) {
                        if isDir.boolValue {
                            
                            let newTestSubject = TestSubject(testCategory: category, subject: subjectURL.lastPathComponent.precomposedStringWithCompatibilityMapping)
                            subjectCounter = subjectCounter + 1
                            
                            log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "   [\(subjectCounter)] \(newTestSubject.key)")
                        }
                    }
                }
                
                if subjectCounter == 0 {
                    log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "  과목이 하나도 없어 \(category.key) 제거")
                    tempTestDatabase.categories.remove(at: tempTestDatabase.categories.index(of: category)!)
                } else {
                    log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "  총 과목 \(subjectCounter)개 생성")
                }
                
            } catch {
                log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "  과목을 가져오면서 에러 발생")
            }
            log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "\(category.key) 과목가져오기 종료")
        }
        
        
        
        
        // 시험회차와 최종적으로 json파일을 찾음
        var totalTestCounter = 0
        for category in tempTestDatabase.categories {
            
            log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "\(category.key) 과목가져오기 시작")
            
            for subject in category.testSubjects {
                
                log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "  \(subject.key) 시험회차가져오기 시작")
                
                let subjectURL = rootURL.appendingPathComponent(category.category).appendingPathComponent(subject.subject)
                do {
                    
                    // Getting list of files in documents folder
                    // http://stackoverflow.com/questions/27721418/getting-list-of-files-in-documents-folder
                    
                    let testDirectories = try FileManager.default.contentsOfDirectory(at: subjectURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
                    
                    
                    
                    log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "    시험회차 확인시작")
                    var testCounter = 0
                    var testFailureCounter = 0
                    for testURL in testDirectories {
                        
                        
                        // 디렉토리만 찾음
                        // Check if NSURL is a directory
                        // http://stackoverflow.com/questions/24208728/check-if-nsurl-is-a-directory
                        
                        var isDir: ObjCBool = ObjCBool(false)
                        if FileManager.default.fileExists(atPath: testURL.path, isDirectory: &isDir) {
                            if isDir.boolValue {
                                
                                do {
                                    
                                    // 시험회차 디렉토리 안의 파일과 디렉토리를 모두 가져옴
                                    let testVersionFiles = try FileManager.default.contentsOfDirectory(at: testURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
                                    
                                    // 이중 유효한 형식의 이름인 json파일만 가져옴
                                    // [2017. 05. 16. 21시 08분 31.72초]Default=변호사시험=공법=002.json
                                    
                                    let regex = "\\[.*\\]\(testDatabase.key.decomposedStringWithCompatibilityMapping)=\(category.category.decomposedStringWithCompatibilityMapping)=\(subject.subject.decomposedStringWithCompatibilityMapping)=\(testURL.lastPathComponent).json"
                                    
                                    var validJsonFiles = [URL]()
                                    for files in testVersionFiles {
                                        if files.path.range(of: regex, options: .regularExpression) != nil {
                                            validJsonFiles.append(files)
                                        }
                                    }
                                    
                                    
                                    // parseJsonsOption 옵션을 사용하여 json 파일중 오래된 파일을 읽을지 신규파일을 읽을지 결정
                                    switch parseJsonsOption {
                                    case .getNewer:
                                        validJsonFiles = validJsonFiles.sorted(by: {$0.path > $1.path})
                                    case .getOlder:
                                        validJsonFiles = validJsonFiles.sorted(by: {$0.path < $1.path})
                                    }
                                    
                                    guard let jsonFileURL = validJsonFiles.first else {
                                        log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        json파일을 찾을 수 없음")
                                        continue
                                    }
                                    
                                    guard let testNumber = Int(testURL.lastPathComponent.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) else {
                                        log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        잘못된 시험회차 디렉토리 이름")
                                        continue
                                    }
                                    
                                    let newTest = Test(createDate: Date(), testSubject: subject, revision: 0, isPublished: true, number: testNumber)
                                    
                                    guard let jsonData = FileManager.default.contents(atPath: jsonFileURL.path) else {
                                        log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        \(jsonFileURL.path.precomposedStringWithCompatibilityMapping)이 올바른 Data가 아님")
                                        continue
                                    }
                                    newTest.jsonFileName = jsonFileURL.lastPathComponent.precomposedStringWithCompatibilityMapping
                                    
                                    // json 파싱에 관한 부분
                                    // json 파싱결과를 확인해서 성공이면 카운터를 늘리고, 실패면 이미 만들어놓은 시험 오브젝트를 삭제함
                                    
                                    log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "     [\(testCounter)] \(newTest.key) 파싱시작")
                                    log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "       \(jsonFileURL.lastPathComponent.precomposedStringWithCompatibilityMapping)")
                                    
                                    
                                    if _jsonToClass(jsonData, newTest) {
                                        
                                        testCounter = testCounter + 1
                                        totalTestCounter = totalTestCounter + 1

                                    } else {
                                    
                                        log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "     !!!! \(newTest.key) 파싱실패")
                                        subject.tests.remove(at: subject.tests.index(of: newTest)!)
                                        testFailureCounter = testFailureCounter + 1
                                    
                                    }
                                    
                                
                                } catch {
                                    
                                    log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "       시험을 찾을 수 없음")
                                    
                                }
                                
                            }
                        }
                    }
                    
                    if testCounter == 0 {
                        log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "    시험회차가 하나도 없어 \(subject.key) 제거")
                        category.testSubjects.remove(at: category.testSubjects.index(of: subject)!)
                        if category.testSubjects.count == 0 {
                            log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "  과목이 하나도 없어 \(category.key) 제거")
                            tempTestDatabase.categories.remove(at: tempTestDatabase.categories.index(of: category)!)
                            if tempTestDatabase.categories.count == 0 {
                                log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "json파일이 없음")
                                return nil
                            }
                        }
                    } else {
                        let testFailureResult = testFailureCounter == 0 ? "실패한 파싱없음" : "시험회차 실패 : \(testFailureCounter)"
                        log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "    시험회차 생성 : \(testCounter)개, \(testFailureResult)")
                        
                    }
                    
                } catch {
                    
                    log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "    시험 회차를 가져오면서 에러 발생")
                    
                }
                
                
                log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "    \(subject.key) 시험회차가져오기 종료")
            }
            
            log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "\(category.key) 과목가져오기 종료")
            
        }
        
        log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "총 \(totalTestCounter)개의 json파일을 가져오기 성공")
        
        // 아무런 에러 테크 없이 모든 tempTestDatabase의 내용을 원 DB로 입력하는 중대한 문제가 잇어 수정필요 2017. 5. 21
        // testDatabase.categories.append(contentsOf: tempTestDatabase.categories)
        
        
        return tempTestDatabase
    }
    
    
    func _jsonToClass(_ jsonData : Data, _ new_test : Test)  -> Bool{
        do {
            
            let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
            
            
            //전체
            guard let testSubject__test = json as? [String : Any] else {
                log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        test 키를 찾을 수 없음")
                return false
            }
            
            
            //시험을 파싱
            
            guard let testSubject__test_key = testSubject__test["key"] as? String else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        문제의 key 찾을 수 없음"); return false}
            guard let testSubject__test_attribute = testSubject__test["attribute"] as? [String : Any] else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        test의 attribute 찾을 수 없음"); return false}
            guard let testSubject__test_attribute_specification = testSubject__test_attribute["specification"] as? String else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        test의 specification 찾을 수 없음"); return false}
            guard let testSubject__test_attribute_modifiedDate = testSubject__test_attribute["modifiedDate"] as? String else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        test의 modifiedDate 찾을 수 없음"); return false}
            guard let testSubject__test_attribute_tags = testSubject__test_attribute["tags"] as? [String] else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        test의 tags 찾을 수 없음"); return false}
            guard let testSubject__test_attribute_revision = testSubject__test_attribute["revision"] as? Int else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        test의 revision 찾을 수 없음"); return false}
            guard let testSubject__test_attribute_createDate = testSubject__test_attribute["createDate"] as? String else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        test의 createDate 찾을 수 없음"); return false}
            guard let testSubject__test_attribute_isPublished = testSubject__test_attribute["isPublished"] as? Bool else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        test의 isPublished 찾을 수 없음"); return false}
            guard let testSubject__test_attribute_number = testSubject__test_attribute["number"] as? Int else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        test의 number 찾을 수 없음"); return false}
            guard let testSubject__test_attribute_numHelper = testSubject__test_attribute["numHelper"] as? Int? else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        test의 numHelper 찾을 수 없음"); return false}
            guard let testSubject__test_attribute_date = testSubject__test_attribute["date"] as? String else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        test의 date 찾을 수 없음"); return false}
            guard let testSubject__test_attribute_raw = testSubject__test_attribute["raw"] as? String else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        test의 raw 찾을 수 없음"); return false}
            
            
            if new_test.key == testSubject__test_key && new_test.number == testSubject__test_attribute_number && new_test.numHelper == testSubject__test_attribute_numHelper {
                log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        유효한 키입력 - \(new_test.key)")
            } else {
                return false
            }
            
            new_test.specification = testSubject__test_attribute_specification
            new_test.modifiedDate = testSubject__test_attribute_modifiedDate.jsonDateFormat
            new_test.tags = testSubject__test_attribute_tags
            new_test.revision = testSubject__test_attribute_revision
            new_test.createDate = testSubject__test_attribute_createDate.jsonDateFormat
            new_test.isPublished = testSubject__test_attribute_isPublished
            
            new_test.date = testSubject__test_attribute_date.jsonDateFormat
            new_test.raw = testSubject__test_attribute_raw
            
            
            // 문제를 파싱
            
            guard let questionArray = testSubject__test["question"] as? [Any] else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        questions 찾을 수 없음"); return false}
            
            for question in questionArray {
                
                guard let testSubject__test__question = question as? [String:Any] else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        question 찾을 수 없음"); return false}
                
                guard let testSubject__test__question_attribute = testSubject__test__question["attribute"] as? [String : Any] else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        question의 attribute 찾을 수 없음"); return false}
                guard let testSubject__test__question_attribute_specification = testSubject__test__question_attribute["specification"] as? String else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        question의 specification 찾을 수 없음"); return false}
                guard let testSubject__test__question_attribute_modifiedDate = testSubject__test__question_attribute["modifiedDate"] as? String else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        question의 modifiedDate 찾을 수 없음"); return false}
                guard let testSubject__test__question_attribute_tags = testSubject__test__question_attribute["tags"] as? [String] else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        question의 tags 찾을 수 없음"); return false}
                guard let testSubject__test__question_attribute_cases = testSubject__test__question_attribute["cases"] as? [String] else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        question의 cases 찾을 수 없음"); return false}
                guard let testSubject__test__question_attribute_revision = testSubject__test__question_attribute["revision"] as? Int else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        question의 revision 찾을 수 없음"); return false}
                guard let testSubject__test__question_attribute_number = testSubject__test__question_attribute["number"] as? Int else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        question의 number 찾을 수 없음"); return false}
                guard let testSubject__test__question_attribute_subjectDetails = testSubject__test__question_attribute["subjectDetails"] as? [String] else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        question의 subjectDetails 찾을 수 없음"); return false}
                guard let testSubject__test__question_attribute_questionType = testSubject__test__question_attribute["questionType"] as? String else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        question의 questionType 찾을 수 없음"); return false}
                guard let testSubject__test__question_attribute_questionOX = testSubject__test__question_attribute["questionOX"] as? String else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        question의 questionOX 찾을 수 없음"); return false}
                guard let testSubject__test__question_attribute_contentPrefix = testSubject__test__question_attribute["contentPrefix"] as? String? else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        question의 contentPrefix 찾을 수 없음"); return false}
                guard let testSubject__test__question_attribute_content = testSubject__test__question_attribute["content"] as? String else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        question의 content 찾을 수 없음"); return false}
                guard let testSubject__test__question_attribute_notContent = testSubject__test__question_attribute["notContent"] as? String? else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        question의 notContent 찾을 수 없음"); return false}
                guard let testSubject__test__question_attribute_contentNote = testSubject__test__question_attribute["contentNote"] as? String? else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        question의 contentNote 찾을 수 없음"); return false}
                guard let testSubject__test__question_attribute_passage = testSubject__test__question_attribute["passage"] as? String? else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        question의 passage 찾을 수 없음"); return false}
                guard let testSubject__test__question_attribute_passageSuffix = testSubject__test__question_attribute["passageSuffix"] as? String? else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        question의 passageSuffix 찾을 수 없음"); return false}
                guard let testSubject__test__question_attribute_questionSuffix = testSubject__test__question_attribute["questionSuffix"] as? String? else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        question의 questionSuffix 찾을 수 없음"); return false}
                guard let testSubject__test__question_attribute_answer = testSubject__test__question_attribute["answer"] as? Int else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        question의 answer 찾을 수 없음"); return false}
                guard let testSubject__test__question_attribute_raw = testSubject__test__question_attribute["raw"] as? String else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        question의 raw 찾을 수 없음"); return false}
                guard let testSubject__test__question_attribute_rawSelections = testSubject__test__question_attribute["rawSelections"] as? String else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        question의 rawSelections 찾을 수 없음"); return false}
                guard let testSubject__test__question_attribute_rawLists = testSubject__test__question_attribute["rawLists"] as? String else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        question의 rawLists 찾을 수 없음"); return false}
                
                let new_question = Question(
                    revision: testSubject__test__question_attribute_revision,
                    test: new_test,
                    number: testSubject__test__question_attribute_number,
                    questionType: .Find,
                    questionOX: .X,
                    content: testSubject__test__question_attribute_content,
                    answer: testSubject__test__question_attribute_answer
                )
                
                var testSubject__test__question_attribute_questionType_enum : QuestionType = .Unknown
                switch testSubject__test__question_attribute_questionType {
                case "Select":
                    testSubject__test__question_attribute_questionType_enum = .Select
                case "Find":
                    testSubject__test__question_attribute_questionType_enum = .Find
                case "Unknown":
                    testSubject__test__question_attribute_questionType_enum = .Select
                default:
                    log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        유효하지 않은 QuestionType \(testSubject__test__question_attribute_questionType)")
                    return false
                }
                
                var testSubject__test__question_attribute_questionOX_enum : QuestionOX = .Unknown
                switch testSubject__test__question_attribute_questionOX {
                case "O":
                    testSubject__test__question_attribute_questionOX_enum = .O
                case "X":
                    testSubject__test__question_attribute_questionOX_enum = .X
                case "Correct":
                    testSubject__test__question_attribute_questionOX_enum = .Correct
                case "Unknown":
                    testSubject__test__question_attribute_questionOX_enum = .Unknown
                default:
                    log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        유효하지 않은 QuestionType \(testSubject__test__question_attribute_questionOX)")
                    return false
                }
                
                
                
                new_question.specification = testSubject__test__question_attribute_specification
                new_question.modifiedDate = testSubject__test__question_attribute_modifiedDate.jsonDateFormat
                new_question.tags = testSubject__test__question_attribute_tags
                new_question.cases = testSubject__test__question_attribute_cases
                new_question.revision = testSubject__test__question_attribute_revision
                new_question.number = testSubject__test__question_attribute_number
                new_question.subjectDetails = testSubject__test__question_attribute_subjectDetails
                new_question.questionType = testSubject__test__question_attribute_questionType_enum
                new_question.questionOX = testSubject__test__question_attribute_questionOX_enum
                new_question.contentPrefix = testSubject__test__question_attribute_contentPrefix
                new_question.content = testSubject__test__question_attribute_content
                new_question.notContent = testSubject__test__question_attribute_notContent
                new_question.contentNote = testSubject__test__question_attribute_contentNote
                new_question.passage = testSubject__test__question_attribute_passage
                new_question.passageSuffix = testSubject__test__question_attribute_passageSuffix
                new_question.questionSuffix = testSubject__test__question_attribute_questionSuffix
                new_question.answer = testSubject__test__question_attribute_answer
                new_question.raw = testSubject__test__question_attribute_raw
                new_question.rawSelections = testSubject__test__question_attribute_rawSelections
                new_question.rawLists = testSubject__test__question_attribute_rawLists
                
                
                guard let selectionArray = testSubject__test__question["selection"] as? [Any] else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        selections 찾을 수 없음"); return false}
                
                for selection in selectionArray {
                    guard let testSubject__test__question__selection = selection as? [String:Any] else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        selection 찾을 수 없음"); return false}
                    
                    guard let selection_key = testSubject__test__question__selection["key"] as? String else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        선택지의 key 찾을 수 없음"); return false}
                    guard let testSubject__test__question__selection_attribute = testSubject__test__question__selection["attribute"] as? [String : Any] else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        selection의 attribute 찾을 수 없음"); return false}
                    guard let testSubject__test__question__selection_attribute_specification = testSubject__test__question__selection_attribute["specification"] as? String else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        selection의 specification 찾을 수 없음"); return false}
                    guard let testSubject__test__question__selection_attribute_modifiedDate = testSubject__test__question__selection_attribute["modifiedDate"] as? String else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        selection의 modifiedDate 찾을 수 없음"); return false}
                    guard let testSubject__test__question__selection_attribute_tags = testSubject__test__question__selection_attribute["tags"] as? [String] else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        selection의 tags 찾을 수 없음"); return false}
                    guard let testSubject__test__question__selection_attribute_cases = testSubject__test__question__selection_attribute["cases"] as? [String] else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        selection의 cases 찾을 수 없음"); return false}
                    guard let testSubject__test__question__selection_attribute_revision = testSubject__test__question__selection_attribute["revision"] as? Int else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        selection의 revision 찾을 수 없음"); return false}
                    guard let testSubject__test__question__selection_attribute_content = testSubject__test__question__selection_attribute["content"] as? String else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        selection의 content 찾을 수 없음"); return false}
                    guard let testSubject__test__question__selection_attribute_notContent = testSubject__test__question__selection_attribute["notContent"] as? String? else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        selection의 notContent 찾을 수 없음"); return false}
                    guard let testSubject__test__question__selection_attribute_iscOrrect = testSubject__test__question__selection_attribute["iscOrrect"] as? Bool? else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        selection의 iscOrrect 찾을 수 없음"); return false}
                    guard let testSubject__test__question__selection_attribute_isAnswer = testSubject__test__question__selection_attribute["isAnswer"] as? Bool? else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        selection의 isAnswer 찾을 수 없음"); return false}
                    guard let testSubject__test__question__selection_attribute_number = testSubject__test__question__selection_attribute["number"] as? Int else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        selection의 number 찾을 수 없음"); return false}
                    
                    
                    let new_selection = Selection(
                        revision: testSubject__test__question__selection_attribute_revision,
                        question: new_question,
                        number: testSubject__test__question__selection_attribute_number,
                        content: testSubject__test__question__selection_attribute_content)
                    
                    if new_selection.key != selection_key {
                        log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        유효하지 않은 Selection 키입력")
                        return false
                    }
                    
                    
                    new_selection.specification = testSubject__test__question__selection_attribute_specification
                    new_selection.modifiedDate = testSubject__test__question__selection_attribute_modifiedDate.jsonDateFormat
                    new_selection.tags = testSubject__test__question__selection_attribute_tags
                    new_selection.cases = testSubject__test__question__selection_attribute_cases
                    new_selection.revision = testSubject__test__question__selection_attribute_revision
                    new_selection.content = testSubject__test__question__selection_attribute_content
                    new_selection.notContent = testSubject__test__question__selection_attribute_notContent
                    new_selection.iscOrrect = testSubject__test__question__selection_attribute_iscOrrect
                    new_selection.isAnswer = testSubject__test__question__selection_attribute_isAnswer
                    
                }
                
                
                
                guard let listArray = testSubject__test__question["list"] as? [Any] else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        lists 찾을 수 없음"); return false}
                
                for list in listArray {
                    
                    guard let testSubject__test__question__list = list as? [String:Any] else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        list 찾을 수 없음"); return false}
                    
                    guard let list_key = testSubject__test__question__list["key"] as? String else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        선택지의 key 찾을 수 없음"); return false}
                    guard let testSubject__test__question__list_attribute = testSubject__test__question__list["attribute"] as? [String : Any] else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        list의 attribute 찾을 수 없음"); return false}
                    guard let testSubject__test__question__list_attribute_specification = testSubject__test__question__list_attribute["specification"] as? String else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        list의 specification 찾을 수 없음"); return false}
                    guard let testSubject__test__question__list_attribute_modifiedDate = testSubject__test__question__list_attribute["modifiedDate"] as? String else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        list의 modifiedDate 찾을 수 없음"); return false}
                    guard let testSubject__test__question__list_attribute_tags = testSubject__test__question__list_attribute["tags"] as? [String] else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        list의 tags 찾을 수 없음"); return false}
                    guard let testSubject__test__question__list_attribute_cases = testSubject__test__question__list_attribute["cases"] as? [String] else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        list의 cases 찾을 수 없음"); return false}
                    guard let testSubject__test__question__list_attribute_revision = testSubject__test__question__list_attribute["revision"] as? Int else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        list의 revision 찾을 수 없음"); return false}
                    guard let testSubject__test__question__list_attribute_content = testSubject__test__question__list_attribute["content"] as? String else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        list의 content 찾을 수 없음"); return false}
                    guard let testSubject__test__question__list_attribute_notContent = testSubject__test__question__list_attribute["notContent"] as? String? else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        list의 notContent 찾을 수 없음"); return false}
                    guard let testSubject__test__question__list_attribute_iscOrrect = testSubject__test__question__list_attribute["iscOrrect"] as? Bool? else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        list의 iscOrrect 찾을 수 없음"); return false}
                    guard let testSubject__test__question__list_attribute_isAnswer = testSubject__test__question__list_attribute["isAnswer"] as? Bool? else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        list의 isAnswer 찾을 수 없음"); return false}
                    guard let testSubject__test__question__list_attribute_selectStirng = testSubject__test__question__list_attribute["selectString"] as? String else {log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        list의 selectString 찾을 수 없음"); return false}
                    
                    let new_list = List(revision: testSubject__test__question__list_attribute_revision, question: new_question, content: testSubject__test__question__list_attribute_content, selectString: testSubject__test__question__list_attribute_selectStirng)
                    
                    if new_list.key != list_key {
                        log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "        유효하지 않은 Selection 키입력")
                        return false
                    }
                    
                    new_list.specification = testSubject__test__question__list_attribute_specification
                    new_list.modifiedDate = testSubject__test__question__list_attribute_modifiedDate.jsonDateFormat
                    new_list.tags = testSubject__test__question__list_attribute_tags
                    new_list.cases = testSubject__test__question__list_attribute_cases
                    new_list.revision = testSubject__test__question__list_attribute_revision
                    new_list.content = testSubject__test__question__list_attribute_content
                    new_list.notContent = testSubject__test__question__list_attribute_notContent
                    new_list.iscOrrect = testSubject__test__question__list_attribute_iscOrrect
                    new_list.isAnswer = testSubject__test__question__list_attribute_isAnswer
                    
                }
                
                
                
                
                
                _ = new_question.findAnswer()
                
                // 초기화시 자동으로 추가되므로 필요없음
                // new_test.questions.append(new_question)
            }
            
            
            log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "     - \(testSubject__test_key) 파싱종료")
            
            
            
        } catch {
            
            fatalError("josn파싱 중 에러발생")
            
        }
        
        return true
    }
    
    
}

enum ParseJsonsOption : String {
    case getOlder
    case getNewer
}
