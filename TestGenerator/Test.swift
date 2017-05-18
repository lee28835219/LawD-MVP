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
        
        super.init(str)
        testSubject.tests.append(self)
    }
}

extension Test {
    func createJsonObject() -> Data {
        let key = "key"
        let attribute = "attribute"
        
        var testSubject__test_attribute = [String : Any]()
        
        testSubject__test_attribute["specification"] = self.specification
        testSubject__test_attribute["modifiedDate"] = self.modifiedDate.jsonFormat
        testSubject__test_attribute["tags"] = self.tags
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
            testSubject__test__question_attribute["tags"] = question.tags
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
                testSubject__test__question__selection_attribute["tags"] = selection.tags
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
                testSubject__test__question__list_attribute["tags"] = list.tags
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
            
            var testSubject__test__question = [String : Any]()
            testSubject__test__question[key] = question.key
            testSubject__test__question[attribute] = testSubject__test__question_attribute
            testSubject__test__question["selection"] = selectionArray
            testSubject__test__question["list"] = listArray
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
}
