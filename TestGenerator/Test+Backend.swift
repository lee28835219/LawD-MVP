//
//  Test+Backend.swift
//  TestGenerator
//
//  Created by Masterbuilder on 2023/09/12.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import Foundation

// 시험이력 저장과 관련하여 그 개념을 학습할 필요가 있는 매우 중요한 함수들 2023. 9. 12. (-)
extension Test {
    //createJsonObject 함수 및 OutputManger 인스턴스의 saveFile함수를 이용해 번들의 특정 경로에에 test객체의 json을 저장해주는 함수
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
    
    // 저장가능한 json형식의 Data 인스턴스를 만들어주는 함수
    func createJsonObject() -> Data {
        let key = "key"
        let attribute = "attribute"
        
        var test_attribute = [String : Any]()
        
        test_attribute["specification"] = self.specification
        test_attribute["modifiedDate"] = self.modifiedDate.jsonFormat
        
        // 태그를 어레이에서 세트로 변경하여 수정함 2017. 5. 23.
        var tempTags = [String]()
        for tag in self.tags {
            tempTags.append(tag)
        }
        test_attribute["tags"] = tempTags
        test_attribute["revision"] = self.revision
        test_attribute["createDate"] = self.createDate.jsonFormat
        test_attribute["isPublished"] = self.isPublished
        test_attribute["number"] = self.number
        test_attribute["numHelper"] = self.numHelper
        test_attribute["date"] = self.date?.jsonFormat
        test_attribute["raw"] = self.raw
        
        
        var questionArray = [Any]()
        for question in self.questions {
            var question_attribute = [String : Any]()
            
            question_attribute["specification"] = question.specification
            question_attribute["modifiedDate"] = question.modifiedDate.jsonFormat
            // 태그를 어레이에서 세트로 변경하여 수정함 2017. 5. 23.
            var tempTags = [String]()
            for tag in question.tags {
                tempTags.append(tag)
            }
            question_attribute["tags"] = tempTags
            question_attribute["cases"] = question.cases
            question_attribute["revision"] = question.revision
            question_attribute["number"] = question.number
            question_attribute["subjectDetails"] = question.subjectDetails
            question_attribute["questionType"] = question.questionType.rawValue
            question_attribute["questionOX"] = question.questionOX.rawValue
            question_attribute["contentPrefix"] = question.contentPrefix
            question_attribute["content"] = question.content
            question_attribute["notContent"] = question.notContent
            question_attribute["contentNote"] = question.contentNote
            question_attribute["passage"] = question.passage
            question_attribute["passageSuffix"] = question.passageSuffix
            question_attribute["questionSuffix"] = question.questionSuffix
            question_attribute["answer"] = question.answer
            question_attribute["raw"] = question.raw
            question_attribute["rawSelections"] = question.rawSelections
            question_attribute["rawLists"] = question.rawLists
            
            
            var selectionArray = [Any]()
            for selection in question.selections {
                // anotherSelectionInStatement 추가해야함 2017. 5. 14. (+)
                
                var selection_attribute = [String : Any]()
                
                selection_attribute["specification"] = selection.specification
                selection_attribute["modifiedDate"] = selection.modifiedDate.jsonFormat
                // 태그를 어레이에서 세트로 변경하여 수정함 2017. 5. 23.
                var tempTags = [String]()
                for tag in selection.tags {
                    tempTags.append(tag)
                }
                selection_attribute["tags"] = tempTags
                selection_attribute["cases"] = selection.cases
                selection_attribute["revision"] = selection.revision
                selection_attribute["content"] = selection.content
                selection_attribute["notContent"] = selection.notContent
                selection_attribute["iscOrrect"] = selection.iscOrrect
                selection_attribute["isAnswer"] = selection.isAnswer
                selection_attribute["number"] = selection.number
                
                
                var newSelection = [String : Any]()
                newSelection[key] = selection.key
                newSelection[attribute] = selection_attribute
                selectionArray.append(newSelection)
            }
            var listArray = [Any]()
            for list in question.lists {
                var list_attribute = [String : Any]()
                
                
                list_attribute["specification"] = list.specification
                list_attribute["modifiedDate"] = list.modifiedDate.jsonFormat
                // 태그를 어레이에서 세트로 변경하여 수정함 2017. 5. 23.
                var tempTags = [String]()
                for tag in list.tags {
                    tempTags.append(tag)
                }
                list_attribute["tags"] = tempTags
                list_attribute["cases"] = list.cases
                list_attribute["revision"] = list.revision
                list_attribute["content"] = list.content
                list_attribute["notContent"] = list.notContent
                list_attribute["iscOrrect"] = list.iscOrrect
                list_attribute["isAnswer"] = list.isAnswer
                list_attribute["selectString"] = list.selectString
                
                
                var newList = [String : Any]()
                newList[key] = list.key
                newList[attribute] = list_attribute
                listArray.append(newList)
            }
            
            var solveArray = [Any]()
            for solve in question.solvers {
                var newSolve = [String : Any]()
                
                
                newSolve["date"] = solve.date?.jsonFormat
                newSolve["isRight"] = solve.isRight
                newSolve["comment"] = solve.comment
                
                solveArray.append(newSolve)
            }
            
            var newQuestion = [String : Any]()
            newQuestion[key] = question.key
            newQuestion[attribute] = question_attribute
            newQuestion["selection"] = selectionArray
            newQuestion["list"] = listArray
            newQuestion["Solves"] = solveArray
            questionArray.append(newQuestion)
        }
        
        // 아래 테이블이 곧 json으로 담기게 되는 것. 현재의 "발전"된 JSONEncoder 기술을 적용하여 더 간단하게 이를 수행할 수 있도록 수정 필요합니다. 2023. 9. 13. (-)
        /*코드는 간단히
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(self)
            return jsonData
            */
        // 로 가능할 듯 하나, Test 클래스가 아마도 반드시 Codable해야 할 것입니다.
        var newTest = [String : Any]()
        newTest[key] = self.key
        newTest[attribute] = test_attribute
        newTest["question"] = questionArray
        
        let data : Data
        do {
            if !JSONSerialization.isValidJSONObject(newTest) {
                fatalError("적절하지 않은 타입의 \(self.key) json type임")
            }
            data = try JSONSerialization.data(
                withJSONObject: newTest,
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
    
    
    
}
