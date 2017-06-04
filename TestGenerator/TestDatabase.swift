//
//  TestDatabase.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 9..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Cocoa

class TestDatabase: DataStructure {
    
    var log = ""
    
    let createDate	: Date = Date()
    
    var categories : [TestCategory] = []
    var allTags : Set<String> = []
    var tagAddress : [(tag : String, dataType : DataType, foreignKey : String)] = []
    
    
    override init(_ key: String = "Default") {
        super.init(key)
    }
    
    func removeVoidPointer() -> [String] {
        var result = [String]()
        
        for cat in categories {
            for sub in cat.testSubjects {
                if sub.tests.count == 0 {
                    result.append(sub.key)
                }
            }
        }
        
        for cat in categories {
            if cat.testSubjects.count == 0 {
                result.append(cat.key)
            }
        }
        
        for removeKey in result {
            self.categories = self.categories.filter(){$0.key != removeKey}
        }
        
        for removeKey in result {
            for (_,cat) in categories.enumerated() {
//                categories[index] = categories[index].testSubjects.
                print(cat.testSubjects.filter(){$0.key != removeKey})
            }
        }
        
        
        
        return result
    }
    
    func refreshTags() {
        for cat in categories {
            for sub in cat.testSubjects {
                for test in sub.tests {
                    for que in test.questions {
                        for tagQue in que.tags {
                            allTags.insert(tagQue)
                            tagAddress.append((tagQue, .Question, que.key))
                        }
                        
                        for list in que.lists {
                            for tagList in list.tags {
                               allTags.insert(tagList)
                            tagAddress.append((tagList, .List, list.key))
                            }
                        }
                        
                        for sel in que.selections {
                            for tagSel in sel.tags {
                                allTags.insert(tagSel)
                                tagAddress.append((tagSel, .Selection, sel.key))
                            }
                        }
                        
                    }
                }
            }
        }
//        tagAddress.sort(){$0.0.foreignKey < $0.1.foreignKey}
        tagAddress.sort(by: { $0.foreignKey < $1.foreignKey })
//        tagAddress.sort(){$0.0.tag < $0.1.tag}
        tagAddress.sort(by: { $0.tag < $1.tag })
        
//        2023. 6. 1.
//        알겠습니다. Swift 3.0에서는 제공된 코드가 작동했지만, Swift 5.0 이후 버전에서는 문제가 발생하는 것 같습니다. Swift 5.0 이후 버전에서는 sort() 메서드가 Array의 확장으로 제공되지 않으며, 대신 sorted(by:) 메서드를 사용하여 배열을 정렬해야 합니다.
//
//        다음은 제공된 코드를 Swift 5.0 이후 버전에서 사용할 수 있는 방식으로 수정한 예시입니다:
//
//        swift
//        Copy code
//        tagAddress.sort(by: { $0.foreignKey < $1.foreignKey })
//        또는 클로저가 단일 표현식이라면 축약 문법으로 작성할 수도 있습니다:
//
//        swift
//        Copy code
//        tagAddress.sort(by: <)
//        위의 코드는 tagAddress 배열을 foreignKey 속성을 기준으로 정렬합니다. 클로저는 첫 번째 요소($0)와 두 번째 요소($1)의 foreignKey 속성을 비교하여 정렬 순서를 결정합니다.
        
    }
    
    func modifyAnswer(_ newAnswers : [String : Int]) {
        
        for cat in categories {
            for sub in cat.testSubjects {
                for test in sub.tests {
                    for qu in test.questions {
                        for (key, newAnswer) in newAnswers {
                            if key == qu.key {
                                if qu.answer != newAnswer {
                                    let quOriAns = qu.answer
                                    qu.answer = newAnswer
                                    _ = qu.findAnswer()
                                    log = ConsoleIO.writeLog(self.log, funcName: "\(#function)", outPut: "\(qu.key) - \(quOriAns)에서 \(qu.answer)로 수정")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func doingSomeStuffRelatedWithQuestion() {
        for cat in categories {
            for sub in cat.testSubjects {
                for test in sub.tests {
                    for que in test.questions {
                        
                        _ = que
                        
                        // do something
                        
                        // 새로운 태그 추가
//                        let newTag = "행정법"
//                        let categoryTag = "공법"
//                        
////                        if que.key.contains(newTag) {
//                        if que.key.contains(categoryTag) && (que.number > 19 || que.number == 40) {
//                        
//                            let (isInserted, _) = que.tags.insert(newTag)
//                            if isInserted {
//                                log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "\(que.key)에 \(newTag) 추가함")
//                            }
//                            
//                        }
                        
                    }
                }
            }
        }
    }
    
}


enum DataType {
    case Question
    case Selection
    case List
}
