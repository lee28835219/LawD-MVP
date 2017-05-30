//
//  InstManagerQuestionsGet.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 23..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class InstManagerQuestionsGet {
    
    let testDatabase : TestDatabase
    
    
    
    let io : ConsoleIO
    
    init(_ testDatabase : TestDatabase, io : ConsoleIO) {
        self.testDatabase = testDatabase
        self.io = io
    }
    
    
    func getQuestions(title : String) -> [Question] {
        
        var questions = [Question]()
        
        let (instruction,value) = io.getQuestionsGet(io.getInput(title + io.getHelp(.InstQuestionsGet)))
        
        
        switch instruction {
            
        case .all:
            for testCategory in testDatabase.categories {
                for testSubject in testCategory.testSubjects {
                    for test in testSubject.tests {
                        for que in test.questions {
                            questions.append(que)
                        }
                    }
                }
            }
            
        case .category:
            guard let testCategory = selectTestCategory(testDatabase) else {
                io.writeMessage(to: .error, "시험명을 찾을 수 없음")
                return questions
            }
            for testSubject in testCategory.testSubjects {
                for test in testSubject.tests {
                    for que in test.questions {
                        questions.append(que)
                    }
                }
            }
        case .subject:
            guard let testCategory = selectTestCategory(testDatabase) else {
                io.writeMessage(to: .error, "시험명을 찾을 수 없음")
                return questions
            }
            guard let testSubject = selectTestSubject(testCategory) else {
                io.writeMessage(to: .error, "시험과목을 찾을 수 없음")
                return questions
            }
            for test in testSubject.tests {
                for que in test.questions {
                    questions.append(que)
                    
                }
            }
        case .test:
            guard let testCategory = selectTestCategory(testDatabase) else {
                io.writeMessage(to: .error, "시험명을 찾을 수 없음")
                return questions
            }
            guard let testSubject = selectTestSubject(testCategory) else {
                io.writeMessage(to: .error, "시험과목을 찾을 수 없음")
                return questions
            }
            guard let test = selectTest(testSubject) else {
                io.writeMessage(to: .error, "시험회차를 찾을 수 없음")
                return questions
            }
            for que in test.questions {
                questions.append(que)
                
            }
            
        case .question:
            guard let testCategory = selectTestCategory(testDatabase) else {
                io.writeMessage(to: .error, "시험명을 찾을 수 없음")
                return questions
            }
            guard let testSubject = selectTestSubject(testCategory) else {
                io.writeMessage(to: .error, "시험과목을 찾을 수 없음")
                return questions
            }
            guard let test = selectTest(testSubject) else {
                io.writeMessage(to: .error, "시험회차를 찾을 수 없음")
                return questions
            }
            guard let que = selectQuestion(test) else {
                io.writeMessage(to: .error, "문제를 찾을 수 없음")
                return questions
            }
            questions.append(que)
            
        case .allwithTag:
            for testCategory in testDatabase.categories {
                for testSubject in testCategory.testSubjects {
                    for test in testSubject.tests {
                        for que in test.questions {
                            questions.append(que)
                        }
                    }
                }
            }
            questions = selectQuestionsWithTag(questions)
            
        case .categorywithTag:
            guard let testCategory = selectTestCategory(testDatabase) else {
                io.writeMessage(to: .error, "시험명을 찾을 수 없음")
                return questions
            }
            for testSubject in testCategory.testSubjects {
                for test in testSubject.tests {
                    for que in test.questions {
                        questions.append(que)
                    }
                }
            }
            questions = selectQuestionsWithTag(questions)
            
        case .subjectwithTag:
            guard let testCategory = selectTestCategory(testDatabase) else {
                io.writeMessage(to: .error, "시험명을 찾을 수 없음")
                return questions
            }
            guard let testSubject = selectTestSubject(testCategory) else {
                io.writeMessage(to: .error, "시험과목을 찾을 수 없음")
                return questions
            }
            for test in testSubject.tests {
                for que in test.questions {
                    questions.append(que)
                    
                }
            }
            questions = selectQuestionsWithTag(questions)
            
        case .testwithTag:
            guard let testCategory = selectTestCategory(testDatabase) else {
                io.writeMessage(to: .error, "시험명을 찾을 수 없음")
                return questions
            }
            guard let testSubject = selectTestSubject(testCategory) else {
                io.writeMessage(to: .error, "시험과목을 찾을 수 없음")
                return questions
            }
            guard let test = selectTest(testSubject) else {
                io.writeMessage(to: .error, "시험회차를 찾을 수 없음")
                return questions
            }
            for que in test.questions {
                questions.append(que)
                
            }
            questions = selectQuestionsWithTag(questions)
            
        case .questionwithTag:
            guard let testCategory = selectTestCategory(testDatabase) else {
                io.writeMessage(to: .error, "시험명을 찾을 수 없음")
                return questions
            }
            guard let testSubject = selectTestSubject(testCategory) else {
                io.writeMessage(to: .error, "시험과목을 찾을 수 없음")
                return questions
            }
            guard let test = selectTest(testSubject) else {
                io.writeMessage(to: .error, "시험회차를 찾을 수 없음")
                return questions
            }
            guard let que = selectQuestion(test) else {
                io.writeMessage(to: .error, "문제를 찾을 수 없음")
                return questions
            }
            questions.append(que)
            questions = selectQuestionsWithTag(questions)
            
        case .unknown:
            io.unkown(value)
        }
        return questions
    }
    
    // 사용자로부터 입력을 받아서 데이터베이스 안의 시험명, 과목, 시험회차, 문제를 선택하는 함수
    // 대상이 하나도 없을 경우 nil반환
    func selectTestCategory(_ database : TestDatabase) -> TestCategory? {
        
        let categoryCount = testDatabase.categories.count
        
        if categoryCount == 0 {
            io.writeMessage(to: .error, "\(database.key)에 아무 데이터가 없음")
            return nil
        }
        
        // 선택할 시험을 출력
        for (index,testCategory) in database.categories.enumerated() {
            io.writeMessage(to: .notice, "[\(index+1)] : \(testCategory.key)")
        }
        
        // 시험명에 맞는 숫자를 선택
        let selectedCategoryIndex = checkNumberRange(max: categoryCount, prefix: "시험명 선택")
        
        return database.categories[selectedCategoryIndex-1]
    }
    
    func selectTestSubject(_ selectedCategoryUnwrapped : TestCategory?) -> TestSubject? {
        
        guard let selectedCategory = selectedCategoryUnwrapped else {
            return nil
        }
        
        let subjectCount = selectedCategory.testSubjects.count
        
        if subjectCount == 0 {
            io.writeMessage(to: .error, "\(selectedCategory.key)에 시험과목이 하나도 없음")
            return nil
        }
        
        for (index,test) in selectedCategory.testSubjects.enumerated() {
            io.writeMessage(to: .notice, "[\(index+1)] : \(test.key)")
        }
        
        let selectedSubjectIndex = checkNumberRange(max: subjectCount, prefix: "시험과목 선택")
        
        return selectedCategory.testSubjects[selectedSubjectIndex-1]
    }
    
    
    func selectTest(_ selectedSubjectUnwrapped : TestSubject?) -> Test? {
        
        guard let selectedSubject = selectedSubjectUnwrapped else {
            return nil
        }
        
        let testCount = selectedSubject.tests.count
        
        if testCount == 0 {
            io.writeMessage(to: .error, "\(selectedSubject.key)에 시험이 하나도 없음")
            return nil
        }
        
        for (index,test) in selectedSubject.tests.enumerated() {
            io.writeMessage(to: .notice, "[\(index+1)] : \(test.key)")
        }
        
        
        let selectedTest = checkNumberRange(max: testCount, prefix: "시험회차 선택")
        
        return selectedSubject.tests[selectedTest-1]
    }
    
    
    func selectQuestion(_ selectedTestUnwrapped: Test?) -> Question? {
        
        guard let selectedTest = selectedTestUnwrapped else {
            return nil
        }
        
        var selectedQuestions = selectedTest.questions
        if selectedQuestions.count == 0 {
            io.writeMessage(to: .error, "\(selectedTest.key)에 문제가 하나도 없음")
            return nil
        }
        
        for question in selectedQuestions {
            io.writeMessage(to: .notice, "[\(question.number)] : \(question.key)")
        }
        
        
        let selectedQuestionNumber = checkNumberRange(max: nil, prefix: "문제번호 선택")
        
        
        // 문제의 경우 문제번호를 정확하게 선택해야 하므로 어레이의 필터를 확인해서 체크함
        selectedQuestions = selectedQuestions.filter({$0.number == selectedQuestionNumber})
        if selectedQuestions.isEmpty {
            io.writeMessage(to: .error, "정확한 숫자를 입력하세요")
            return selectQuestion(selectedTestUnwrapped)
        }
        
        return selectedQuestions[0]
    }
    
    
    
    func selectList(_ questionUnwapped : Question?, showNot : Bool = true) -> List? {
        guard let question = questionUnwapped else {
            print("> 목록지를 찾을 수 없음")
            return nil
        }
        
        var lists = question.lists
        if lists.count == 0 {
            print("> \(question.key)에 목록지가 하나도 없음")
            return nil
        }
        
        for (index,list) in lists.enumerated() {
            var selString = ""
            if showNot {
                selString = list.notContent != nil ? list.notContent! : "없음"
            } else {
                selString = list.content
            }
            print(" [\(index+1)] : \(list.getListString()). \(selString)")
        }
        
        
        var goon = true
        while goon {
            print("목록지 번호 선택 $ ", terminator : "")
            let input = readLine()
            
            guard let inputWrapped = input else {
                print("올바르지 않은 입력, 재입력하세요.")
                continue
            }
            
            let listNumber = Int(inputWrapped)
            if listNumber == nil {
                print("숫자를 입력하세요")
                continue
            }
            lists = lists.filter({$0.number == listNumber})
            if lists.isEmpty {
                print("숫자를 입력하세요")
                continue
            }
            goon = false
        }
        
        return lists[0]
    }
    
    func selectSelection(_ questionUnwapped : Question?, showNot : Bool = true) -> Selection? {
        guard let question = questionUnwapped else {
            print("> 선택지를 찾을 수 없음")
            return nil
        }
        
        var selections = question.selections
        if selections.count == 0 {
            print("> \(question.key)에 선택지가 하나도 없음")
            return nil
        }
        
        
        for selection in selections {
            var selString = ""
            if showNot {
                selString = selection.notContent != nil ? selection.notContent! : "없음"
            } else {
                selString = selection.content
            }
            print(" \(selection.number.roundInt) \(selString)")
        }
        
        
        var goon = true
        while goon {
            print("목록지 번호 선택 $ ", terminator : "")
            let input = readLine()
            
            guard let inputWrapped = input else {
                print("올바르지 않은 입력, 재입력하세요.")
                continue
            }
            
            let number = Int(inputWrapped)
            if number == nil {
                print("숫자를 입력하세요")
                continue
            }
            selections = selections.filter({$0.number == number!})
            if selections.isEmpty {
                print("숫자를 입력하세요")
                continue
            }
            goon = false
        }
        
        return selections[0]
    }
    
    
    
    
    //input이 0~ 정수로 입력받았는지 확인하는 로직 필요함 2017. 4. 26.(-)
    //노가다 및 Int(String)으로 완성 2017. 5. 6.
    // 함수로 엔켑슐레이션 2017. 5. 20.
    func checkNumberRange(max: Int?, prefix: String) -> Int {
        let input = io.getInput(prefix)
        let number = Int(input)
        
        if number == nil {
            io.writeMessage(to: .error, "숫자를 입력하세요")
            return checkNumberRange(max: max, prefix: prefix)
        }
        
        if max != nil {
            if number! - 1 < 0 || number! - 1 >= max! {
                io.writeMessage(to: .error, "범위에 맞는 숫자를 입력하세요")
                return checkNumberRange(max: max, prefix: prefix)
            }
        } else {
            if number! - 1 < 0 {
                io.writeMessage(to: .error, "정확한 숫자를 입력하세요")
                return checkNumberRange(max: max, prefix: prefix)
            }
        }
        
        return number!
    }
    
    
    
    
    
    func selectQuestionsWithTag(_ questions : [Question]) -> [Question] {
        var questionsResult = [Question]()
        
        var tagsInQuestions = Set<String>()
        var numberOfTags = [String:Int]()
        
        // "선택한 태그 이외에" 다른 태그가 없는 문제에 대한 갯수를 출력해주는 기능 추가하면 좋을 듯? 2017. 5. 28. (+)
//        let nullTag = "_없음"
//        tagsInQuestions.insert(nullTag)
//        numberOfTags[nullTag] = 0
        
        for que in questions {
            for tag in que.tags {
                
                tagsInQuestions.insert(tag)
                
                if numberOfTags[tag] != nil {
                    numberOfTags[tag] = numberOfTags[tag]! + 1
                } else {
                    numberOfTags[tag] = 1
                }
                
            }
        }
        
        
        // https://stackoverflow.com/questions/30054854/sort-a-dictionary-in-swift
        // Sort a Dictionary in Swift
        // dictionary는 sort하기 매우 불편하네, map 함수는 공부좀 해야될듯 2017. 5. 28.
        
        let sortedNumberOfTags = numberOfTags.sorted(by: {$0.value > $1.value})
        
        let numberOfTagsKeys = sortedNumberOfTags.map{return $0.key}
        let numberOfTagsValues = sortedNumberOfTags.map{return $0.value}
        
        
        var str = ""
        
        // 여기를 필요한 대로 주어진 범위로 변경
        for (index, tag) in numberOfTagsKeys.enumerated() {
            if index == 0 {
                str = "[전체](\(questions.count)), \(tag)(\(numberOfTagsValues[index]))"
            } else {
                str = str + ", " + "\(tag)(\(numberOfTagsValues[index]))"
            }
        }
        
        
        io.writeMessage()
        io.writeMessage(to: .title, "<태그>")
        io.writeMessage(to: .publish, "\(str)")
        
        let input = io.getInput("찾을 태그 입력, 앞에 \"~\" 입력 시 해당 태그 제외함, continue[]")
        
        if input == "" {
            return questions
        }
        
        if input.characters.first == "~" {
            
            
            // 좀더 정치한 논리로 ~ 태그 제외 기능 추가 필요 2017. 5. 28. (+)
            let notInput = input.substring(with: input.range(of: "~")!.upperBound..<input.endIndex)
            var questionsRemoved = [Question]()
            for (_, question) in questions.enumerated() {
                for tag in question.tags {
                    if tag == notInput {
                        questionsRemoved.append(question)
                    }
                }
            }
            for queResult in questions {
                var sameQueChecker = false
                for queRemoved in questionsRemoved {
                    if queResult === queRemoved {
                        sameQueChecker = true
                    }
                }
                if !sameQueChecker {
                    questionsResult.append(queResult)
                }
            }
            
            io.writeMessage(to: .notice, "\(notInput) 태그 포함하는 \(questions.count - questionsResult.count)개 제외")
            return selectQuestionsWithTag(questionsResult)
            
        } else {
            
            for que in questions {
                for tag in que.tags {
                    if input == tag {
                        questionsResult.append(que)
                    }
                }
            }
            if questionsResult.count == 0 {
                io.writeMessage(to: .error, "\(input)에 맞는 태그를 찾을 수 없음")
                return selectQuestionsWithTag(questions)
            } else {
                io.writeMessage(to: .notice, "\(input) 태그 포함하는 \(questionsResult.count)개만 선별")
                return selectQuestionsWithTag(questionsResult)
            }
            
        }
        
        
        
        
        
        
        
//        let tagsInQuestion = testDatabase.tagAddress.filter{$0.dataType == .Question}
//        let input = io.getInput("찾을 태그 입력")
//        
//        var questionsKey = Set<String>()
//        for (tag, _, key) in tagsInQuestion {
//            if tag == input {
//                questionsKey.insert(key)
//            }
//        }
//        
//        
//        // 여기를 주어진 범위로 변경 (+)
//        for testCategory in testDatabase.categories {
//            for testSubject in testCategory.testSubjects {
//                for test in testSubject.tests {
//                    for que in test.questions {
//                        if questionsKey.contains(que.key) {
//                            questionsResult.append(que)
//                        }
//                    }
//                }
//            }
//        }
//        return questionsResult
        
    }
}
