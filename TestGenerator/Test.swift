//
//  Test.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 3..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//
import Foundation

class Test : DataStructure {
    //내가 무엇인지
    let testSubject : TestSubject
    var revision : Int
    
    //나의 속성은 어떤지
    var createDate : Date
    
    var isPublished : Bool //기출, 원본
    let number : Int
    let numHelper : Int?
    var date : Date? //1701, 원본
    
    var raw : String = ""
        
    //내 식구들은 누구인지
    var questions = [Question]()
    
    // 아카이브 하지않는 파싱 및 디버깅 에서만 사용하는 임시함수
    var jsonFileName : String? = nil
    
    init(createDate : Date, testSubject : TestSubject, revision : Int, isPublished: Bool, number: Int, numHelper: Int? = nil) {
        self.createDate = createDate
        self.testSubject = testSubject
        self.revision = revision
        
        self.isPublished = isPublished
        self.number = number
        self.date = Date()
        self.numHelper = numHelper
        
        
        
        var str = testSubject.key
        
        if let numHeplerWrapped = numHelper {
            str = str + "=" + String(format: "%04d",numHeplerWrapped) + "-" + String(format: "%03d", self.number)
        } else {
            str = str + "=" + String(format: "%03d", self.number)
        }
        
        for test in testSubject.tests {
            if test.key == str {
                fatalError("\(str)과 똑같은 시험이 이미 testDB \(testSubject.key)에 있음")
            }
        }
        
        super.init(UUID(), str)
        testSubject.tests.append(self)
    }
    
    // key를 대체하기 위해 각기 시험에 따라 이에 걸맞게 직관적인 시험의 이름을 생성 2023. 6. 25.
    func getKeySting() -> String {
        var str = ""
        switch testSubject.testCategory.category {
        case "변호사시험":
            str += "[변시] \(testSubject.subject) 제\(self.number)회"
        case "★MVP 시연용★":
            str += "★MVP 시연용★"
        default:
            str += key
        }
        
        return str
    }
}

extension Test {
    func createJsonObject() -> Data {
        let key = "key"
        let attribute = "attribute"
        
        var testSubject__test_attribute = [String : Any]()
        
        testSubject__test_attribute["specification"] = self.specification
        testSubject__test_attribute["modifiedDate"] = self.modifiedDate.jsonFormat
        // 태그를 어레이에서 세트로 변경하여 수정함 2017. 5. 23.
        var tempTags = [String]()
        for tag in self.tags {
            tempTags.append(tag)
        }
        testSubject__test_attribute["tags"] = tempTags
        testSubject__test_attribute["revision"] = self.revision
        testSubject__test_attribute["createDate"] = self.createDate.jsonFormat
        testSubject__test_attribute["isPublished"] = self.isPublished
        testSubject__test_attribute["number"] = self.number
        testSubject__test_attribute["numHelper"] = self.numHelper
        testSubject__test_attribute["date"] = self.date?.jsonFormat
        testSubject__test_attribute["raw"] = self.raw
        
        
        var questionArray = [Any]()
        for question in self.questions {
            var testSubject__test__question_attribute = [String : Any]()
            
            testSubject__test__question_attribute["specification"] = question.specification
            testSubject__test__question_attribute["modifiedDate"] = question.modifiedDate.jsonFormat
            // 태그를 어레이에서 세트로 변경하여 수정함 2017. 5. 23.
            var tempTags = [String]()
            for tag in question.tags {
                tempTags.append(tag)
            }
            testSubject__test__question_attribute["tags"] = tempTags
            testSubject__test__question_attribute["cases"] = question.cases
            testSubject__test__question_attribute["revision"] = question.revision
            testSubject__test__question_attribute["number"] = question.number
            testSubject__test__question_attribute["subjectDetails"] = question.subjectDetails
            testSubject__test__question_attribute["questionType"] = question.questionType.rawValue
            testSubject__test__question_attribute["questionOX"] = question.questionOX.rawValue
            testSubject__test__question_attribute["contentPrefix"] = question.contentPrefix
            testSubject__test__question_attribute["content"] = question.content
            testSubject__test__question_attribute["notContent"] = question.notContent
            testSubject__test__question_attribute["contentNote"] = question.contentNote
            testSubject__test__question_attribute["passage"] = question.passage
            testSubject__test__question_attribute["passageSuffix"] = question.passageSuffix
            testSubject__test__question_attribute["questionSuffix"] = question.questionSuffix
            testSubject__test__question_attribute["answer"] = question.answer
            testSubject__test__question_attribute["raw"] = question.raw
            testSubject__test__question_attribute["rawSelections"] = question.rawSelections
            testSubject__test__question_attribute["rawLists"] = question.rawLists
            
            
            var selectionArray = [Any]()
            for selection in question.selections {
                // anotherSelectionInStatement 추가해야함 2017. 5. 14. (+)
                
                var testSubject__test__question__selection_attribute = [String : Any]()
                
                testSubject__test__question__selection_attribute["specification"] = selection.specification
                testSubject__test__question__selection_attribute["modifiedDate"] = selection.modifiedDate.jsonFormat
                // 태그를 어레이에서 세트로 변경하여 수정함 2017. 5. 23.
                var tempTags = [String]()
                for tag in selection.tags {
                    tempTags.append(tag)
                }
                testSubject__test__question__selection_attribute["tags"] = tempTags
                testSubject__test__question__selection_attribute["cases"] = selection.cases
                testSubject__test__question__selection_attribute["revision"] = selection.revision
                testSubject__test__question__selection_attribute["content"] = selection.content
                testSubject__test__question__selection_attribute["notContent"] = selection.notContent
                testSubject__test__question__selection_attribute["iscOrrect"] = selection.iscOrrect
                testSubject__test__question__selection_attribute["isAnswer"] = selection.isAnswer
                testSubject__test__question__selection_attribute["number"] = selection.number
                
                
                var testSubject__test__question__selection = [String : Any]()
                testSubject__test__question__selection[key] = selection.key
                testSubject__test__question__selection[attribute] = testSubject__test__question__selection_attribute
                selectionArray.append(testSubject__test__question__selection)
            }
            var listArray = [Any]()
            for list in question.lists {
                var testSubject__test__question__list_attribute = [String : Any]()
                
                
                testSubject__test__question__list_attribute["specification"] = list.specification
                testSubject__test__question__list_attribute["modifiedDate"] = list.modifiedDate.jsonFormat
                // 태그를 어레이에서 세트로 변경하여 수정함 2017. 5. 23.
                var tempTags = [String]()
                for tag in list.tags {
                    tempTags.append(tag)
                }
                testSubject__test__question__list_attribute["tags"] = tempTags
                testSubject__test__question__list_attribute["cases"] = list.cases
                testSubject__test__question__list_attribute["revision"] = list.revision
                testSubject__test__question__list_attribute["content"] = list.content
                testSubject__test__question__list_attribute["notContent"] = list.notContent
                testSubject__test__question__list_attribute["iscOrrect"] = list.iscOrrect
                testSubject__test__question__list_attribute["isAnswer"] = list.isAnswer
                testSubject__test__question__list_attribute["selectString"] = list.selectString
                
                
                var testSubject__test__question__list = [String : Any]()
                testSubject__test__question__list[key] = list.key
                testSubject__test__question__list[attribute] = testSubject__test__question__list_attribute
                listArray.append(testSubject__test__question__list)
            }
            
            var solveArray = [Any]()
            for solve in question.solvers {
                var testSubject__test__question__solve = [String : Any]()
                
                
                testSubject__test__question__solve["date"] = solve.date?.jsonFormat
                testSubject__test__question__solve["isRight"] = solve.isRight
                testSubject__test__question__solve["comment"] = solve.comment
                
                solveArray.append(testSubject__test__question__solve)
            }
            
            var testSubject__test__question = [String : Any]()
            testSubject__test__question[key] = question.key
            testSubject__test__question[attribute] = testSubject__test__question_attribute
            testSubject__test__question["selection"] = selectionArray
            testSubject__test__question["list"] = listArray
            testSubject__test__question["Solves"] = solveArray
            questionArray.append(testSubject__test__question)
        }
        var testSubject__test = [String : Any]()
        testSubject__test[key] = self.key
        testSubject__test[attribute] = testSubject__test_attribute
        testSubject__test["question"] = questionArray
    
    let data : Data
    do {
        if !JSONSerialization.isValidJSONObject(testSubject__test) {
            fatalError("적절하지 않은 타입의 \(self.key) json type임")
        }
        data = try JSONSerialization.data(
            withJSONObject: testSubject__test,
            options: .prettyPrinted
        )
    } catch  {
        fatalError("유효하지 않은 \(self.key) testSubject Json생성 WHY?")
        // 치명적 에러 발생하는 이유를 확인해야 함 2017. 5. 6. (+)
    }
    
        
    // 문자로 반환하는 것과 data로 반환하는 것, 어느것이 더 좋은가?
    // return String(data: data, encoding: .utf8)
    
    return data
    }
    
    class func checkSameKey(test : Test, with : TestDatabase) -> Test? {
        for category in with.categories {
            for subject in category.testSubjects {
                for originalTest in subject.tests {
                    if originalTest.key == test.key {
                        return originalTest
                    }
                }
            }
        }
        return nil
    }
    
    
    
    
    func save() -> Bool {
        
        self.revision = self.revision + 1
        
        let data = self.createJsonObject()
        
        var testNumber : String = ""
        if let numHeplerWrapped = self.numHelper {
            testNumber = testNumber + String(format: "%04d",numHeplerWrapped) + "-" + String(format: "%03d", self.number)
        } else {
            testNumber = testNumber + String(format: "%03d", self.number)
        }
        
        if OutputManager().saveFile(
            fileDirectories: [self.testSubject.testCategory.testDatabase.key,  //DB
                self.testSubject.testCategory.category,    //시험명
                self.testSubject.subject,   //과목
                testNumber //회차
            ],
            fileName: "[\(Date().HHmmSS)]\(self.testSubject.testCategory.testDatabase.key)=\(self.key).json",
            data: data) {
            return true
        } else {
            return false
        }
    }
    
}
