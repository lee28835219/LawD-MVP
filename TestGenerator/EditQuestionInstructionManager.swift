//
//  EditQuestionInstructionManager.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 23..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class EditQuestionInstructionManager {
    
    let io : ConsoleIO
    
    init(io : ConsoleIO) {
        self.io = io
    }
    
    func editQuestion(_ question : Question, _ next : Bool) -> (Question?, next : Bool) {
        
        QuestionInstructionManager(io).showNotHistory(question)
        
        io.writeMessage()
        let (instruction, value) = io.getEdit(io.getInput("수정할 대상선택 : "+io.getHelp(.InstEdit)))
        
        var nextUpadte = next
        
        switch instruction {
        
        case .show:
            io.writeMessage(to: .notice, "문제의 모든 내용 출력")
            QuestionInstructionManager(io).show(question)
            return editQuestion(question, nextUpadte)
            
        case .tags:
            
            io.writeMessage(to: .notice, "수정하거나 삭제할 태그 선택")
            var tagsArray = [String]()
            io.writeMessage(to: .notice, "[0] : (신규)")
            for (index, tag) in question.tags.enumerated() {
                io.writeMessage(to: .notice, "[\(index+1)] : \(tag)")
                tagsArray.append(tag)
            }
            let jndex = io.checkNumberRange(prefix: "숫자입력", min : 0, max: question.tags.count)
            var modifiedTag = ""
            if jndex == 0 {
                modifiedTag = io.getInput("(신규 태그, cancel[\\] ", false)
            } else {
                modifiedTag = io.getInput("(\(tagsArray[jndex-1])) 태그 수정, 무입력 시 삭제, cancel[\\] ", false)
            }
            if modifiedTag == "\\" {
            } else if question.tags.contains(modifiedTag) {
                io.writeMessage(to: .alert, "\(modifiedTag)는 이미 존재함")
            } else if jndex == 0 {
                if modifiedTag == "" {
                    io.writeMessage(to: .notice, "아무것도 입력안함")
                } else {
                    question.tags.insert(modifiedTag)
                    io.writeMessage(to: .notice, "\(modifiedTag) 태그 입력 완료")
                }
            } else {
                if modifiedTag == "" {
                    question.tags.remove(tagsArray[jndex-1])
                    io.writeMessage(to: .notice, "\(modifiedTag) 삭제완료")
                } else {
                    question.tags.insert(modifiedTag)
                    question.tags.remove(tagsArray[jndex-1])
                    io.writeMessage(to: .notice, "\(modifiedTag) 태그 입력 완료")
                }
            }
            Solver(question).publish(om: OutputManager(), type: .original, showTitle: false, showQuestion: false, showAnswer: false, showTags: true, showHistory: false)
            _ = io.getInput("확인[]")
            
            return editQuestion(question, nextUpadte)
            
        case .notQuestion:
            guard let result = editStatementString(
                title: "문제의 반대질문",
                question : nil,
                oriStr: question.content,
                oriIscOrrect: nil,
                notOriStr: question.notContent,
                isNotStatementEditMode: true)
                else {
                    return editQuestion(question, nextUpadte)
            }
            nextUpadte = true
            question.notContent = result
            return editQuestion(question, nextUpadte)
            
            
        case .notLists:
            for (index,statement) in question.lists.enumerated() {
                let count = question.lists.count
                guard let result = editStatementString(
                    title: "반대목록지 \(index+1) / \(count)",
                    question : question.notContent,
                    oriStr: statement.content,
                    oriIscOrrect: statement.iscOrrect,
                    // list는 아직 oX판단하는 기능이 없다? 충격적 꼭 필요함 추가 필요 2017. 5. 21. (-)(-)(-)(-)(-)  2017. 5. 23. 추가함
                    notOriStr: statement.notContent,
                    isNotStatementEditMode: true)
                    else {
                        continue
                }
                nextUpadte = true // 단 하나라도 수정된게 있어서 result가 가드문을 빠져 나오면 업데이트 된것으로 판단. -> 파일저장
                question.lists[index].notContent = result
            }
            if question.lists.count == 0 {
                io.writeMessage(to: .error, "문제에 목록지가 없음")
            }
            return editQuestion(question, nextUpadte)
            
            
        case .notSelections:
            for (index,statement) in question.selections.enumerated() {
                let count = question.selections.count
                guard let result = editStatementString(
                    title: "반대선택지 \(index+1) / \(count)",
                    question : question.notContent,
                    oriStr: statement.content,
                    oriIscOrrect: statement.iscOrrect,
                    notOriStr: statement.notContent,
                    isNotStatementEditMode: true)
                    else {
                        continue
                }
                nextUpadte = true
                question.selections[index].notContent = result
            }
            return editQuestion(question, nextUpadte)
            
            
        case .originalQuestion:
            guard let result = editStatementString(
                title: "문제의 질문",
                question : nil,
                oriStr: question.content,
                oriIscOrrect: nil,
                notOriStr: question.notContent,
                isNotStatementEditMode: false)
                else {
                    return editQuestion(question, nextUpadte)
            }
            nextUpadte = true
            question.notContent = result
            return editQuestion(question, nextUpadte)
            
            
        case .originalLists:
            for (index,statement) in question.lists.enumerated() {
                let count = question.lists.count
                guard let result = editStatementString(
                    title: "목록지 \(index+1) / \(count)",
                    question : question.content,
                    oriStr: statement.content,
                    oriIscOrrect: nil,
                    notOriStr: statement.notContent,
                    isNotStatementEditMode: false)
                    else {
                        continue
                }
                nextUpadte = true
                question.lists[index].content = result
            }
            if question.lists.count == 0 {
                io.writeMessage(to: .error, "문제에 목록지가 없음")
            }
            return editQuestion(question, nextUpadte)
            
            
        case .originalSelection:
            for (index,statement) in question.selections.enumerated() {
                let count = question.selections.count
                guard let result = editStatementString(
                    title: "선택지 \(index+1) / \(count)",
                    question : question.content,
                    oriStr: statement.content,
                    oriIscOrrect : statement.iscOrrect,
                    notOriStr: statement.notContent,
                    isNotStatementEditMode: false)
                    else {
                        continue
                }
                nextUpadte = true
                question.selections[index].content = result
            }
            return editQuestion(question, nextUpadte)
            
            //        case .
            //         solve, publishall 기능 추가 필요
            
            
        case .next:
            if nextUpadte {
                return (question, false)
            } else {
                return (nil, false) // -> gonnaExit은 false이나 질문반환ㄴ은 nil 이는 요번 질문은 수정안한다는 예기
            }
            
        case .exit:
            return (nil, true) // -> gonnaExit true 이는 파일저장 안하고 종료한다는 의미
            
        case .unknown:
            io.unkown(value, true)
            return editQuestion(question, nextUpadte)
        }
    }
    
    func editStatementString(title : String, question : String?, oriStr : String, oriIscOrrect : Bool?, notOriStr : String?, isNotStatementEditMode : Bool) -> String? {
        
        io.writeMessage()
        io.writeMessage(to: .title, "["+title+" 수정을 시작함]")
        
        
        let staOut = isNotStatementEditMode ? OutputType.standard : OutputType.important
        let notStaOut = isNotStatementEditMode ? OutputType.important : OutputType.standard
        let ontOriStrWrapped = notOriStr == nil ? "(입력되지 않음)" : notOriStr!
        
        
        
        var oriOX : String = ""
        var notOriOX : String = ""
        var modifyOX : String = ""
        
        io.writeMessage()
        
        // 질문이 아니므로 목록지와 선택지는 OX를 판단할 수 있고 앞에 질문 출력이 필요함
        if question != nil {
            io.writeMessage(to: .publish, "[질문]")
            io.writeMessage()
            io.writeMessage(to: .publish, question!)
            io.writeMessage()
            
            if oriIscOrrect == nil {
                oriOX = "(알수없음)"
                notOriOX = oriOX
            } else {
                if oriIscOrrect == true {
                    oriOX = "(O)"
                    notOriOX = "(X)"
                } else {
                    oriOX = "(X)"
                    notOriOX = "(O)"
                }
                modifyOX = isNotStatementEditMode ? notOriOX : oriOX
            }
        }
        
        
        io.writeMessage(to: staOut, "[원본진술]")
        io.writeMessage()
        io.writeMessage(to: staOut, oriStr+"   \(oriOX)")
        io.writeMessage()
        io.writeMessage(to: notStaOut, "[반대진술]")
        io.writeMessage()
        io.writeMessage(to: notStaOut, ontOriStrWrapped+"   \(notOriOX)")
        io.writeMessage()
        
        let str = isNotStatementEditMode ? "> 수정할 반대진술 입력 (다시입력 : \\) $ " : "> 수정할 진술 입력 (다시입력 : \\) $"
        io.writeMessage(to: .notice, str)
        io.writeMessage()
        let inputUnwrapped : String? = io.getInput("", true)
        
        guard let input = inputUnwrapped else {
            io.writeMessage(to: .error, "올바르지 않은 입력")
            return editStatementString(title: title, question: question, oriStr: oriStr, oriIscOrrect: oriIscOrrect, notOriStr: notOriStr, isNotStatementEditMode: isNotStatementEditMode)
        }
        
        if input == "" {
            io.writeMessage(to: .error, "아무것도 입력되지 않아 진술수정하지 않음")
            return nil
        } else if input.characters.last == "\\" {
            // http://stackoverflow.com/questions/25113672/how-do-you-get-the-last-character-of-a-string-without-using-array-on-swift
            // How do you get the last character of a string without using array on swift?
            io.writeMessage(to: .notice, "다시입력")
            io.writeMessage(to: .notice, "")
            return editStatementString(title: title, question: question, oriStr: oriStr, oriIscOrrect: oriIscOrrect, notOriStr: notOriStr, isNotStatementEditMode: isNotStatementEditMode)
        }
        
        
        io.writeMessage()
        io.writeMessage(to: .important, "[수정한 진술]")
        io.writeMessage()
        io.writeMessage(to: .important, input+"   \(modifyOX)")
        io.writeMessage()
        
        let inp = io.getInput("confirm[], rewrite[\\], cancle[0] ?")
        if inp == "\\"  {
            return editStatementString(title: title, question: question, oriStr: oriStr, oriIscOrrect: oriIscOrrect, notOriStr: notOriStr, isNotStatementEditMode: isNotStatementEditMode)
        }
        if inp == "0"  {
            io.writeMessage(to: .notice, "진술수정 취소")
            return nil
        }
        io.writeMessage(to: .notice, "진술수정 완료")
        return input
    }

}


extension EditQuestionInstructionManager {
    // 왜 템플렛을 써서 복잡하게 정의 한건가 2017. 5. 23.
    
    
    //    func editGenerator(_ generator : Generator)  {
    //
    //        let questions = generator.getQustioninSovers()
    //        var questionsEdited = [Question]()
    //
    //        let queCounter = questions.count
    //        for (index,question) in questions.enumerated() {
    //
    //            io.writeMessage()
    //            io.writeMessage(to: .title, "[[시험문제 수정 - \(index+1) / \(queCounter)]]")
    //
    //
    //            // solver가 셔플하든 말든 원래 값을 출력해야 할 것임
    //            Solver(question).publish(om: outputManager,
    //                                     type: .original,
    //                                     showTitle: true, showQuestion: true, showAnswer: true, showTags: false, showHistory: false,
    //                                     showAttribute: true, showOrigSel: true)
    //
    //            io.writeMessage(to: .title, "[반전된 문제]")
    //
    //            Solver(question).publish(om: outputManager,
    //                                     type: .originalNot,
    //                                     showTitle: true, showQuestion: true, showAnswer: true, showTags: false, showHistory: true,
    //                                     showAttribute: true, showOrigSel: true)
    //
    //
    //
    //            var editedQuestion = Templet.Question(
    //                revision: question.revision + 1,  // revision up
    //                specification: question.specification,
    //                number: question.number,
    //                subjectDetails: question.subjectDetails,
    //                questionType: question.questionType,
    //                questionOX: question.questionOX,
    //                contentPrefix: question.contentPrefix,
    //                content: question.content,
    //                notContent: question.notContent,
    //                contentNote: question.contentNote,
    //                questionSuffix: question.questionSuffix,
    //                passage: question.passage,
    //                passageSuffix: question.passageSuffix,
    //                answer: question.answer,
    //                raw: question.raw,
    //                rawSelections: question.rawSelections,
    //                rawLists: question.rawLists,
    //                selections: [],  // 2. 선택지
    //                lists: []  // 3. 목록
    //            )
    //
    //            for (_, statement) in question.lists.enumerated() {
    //                let list = Templet.List(
    //                    revision: statement.revision + 1,
    //                    specification: statement.specification,
    //                    content: statement.content,
    //                    notContent: statement.notContent,
    //                    listStringType: statement.listStringType,
    //                    number: statement.number,
    //                    iscOrrect : statement.iscOrrect,
    //                    isAnswer : statement.isAnswer
    //                )
    //
    //                editedQuestion.lists.append(list)
    //            }
    //
    //            for (_, statement) in question.selections.enumerated() {
    //                let selection = Templet.Selection(
    //                    revision: statement.revision + 1,
    //                    specification: statement.specification,
    //                    content: statement.content,
    //                    notContent: statement.notContent,
    //                    number: statement.number,
    //                    iscOrrect: statement.iscOrrect,
    //                    isAnswer: statement.isAnswer)
    //                editedQuestion.selections.append(selection)
    //            }
    //
    //
    ////            let result = editQuestion(editedQuestion, false)
    //            if result.gonnaExit {
    //                io.writeMessage(to: .error, "강제종료 함")
    //                return
    //            }
    //            guard let reultEdidtedQuestion = result.editedQuestion else {
    //                io.writeMessage(to: .notice, "문제 수정하지 않고 스킵")
    //                continue
    //            }
    //
    //
    //            question.revision = reultEdidtedQuestion.revision
    //            question.specification = reultEdidtedQuestion.specification
    //            question.number = reultEdidtedQuestion.number
    //            question.subjectDetails = reultEdidtedQuestion.subjectDetails
    //            question.questionType = reultEdidtedQuestion.questionType
    //            question.questionOX = reultEdidtedQuestion.questionOX
    //            question.contentPrefix = reultEdidtedQuestion.contentPrefix
    //            question.content = reultEdidtedQuestion.content
    //            question.notContent = reultEdidtedQuestion.notContent
    //            question.contentNote = reultEdidtedQuestion.contentNote
    //            question.questionSuffix = reultEdidtedQuestion.questionSuffix
    //            question.passage = reultEdidtedQuestion.passage
    //            question.passageSuffix = reultEdidtedQuestion.passageSuffix
    //            question.answer = reultEdidtedQuestion.answer
    //            question.raw = reultEdidtedQuestion.raw
    //            question.rawSelections = reultEdidtedQuestion.rawSelections
    //            question.rawLists = reultEdidtedQuestion.rawLists
    //
    //
    //
    //            for (index,statement) in question.lists.enumerated() {
    //                statement.content = reultEdidtedQuestion.lists[index].content
    //                statement.notContent = reultEdidtedQuestion.lists[index].notContent
    //            }
    //            for (index,statement) in question.selections.enumerated() {
    //                statement.content = reultEdidtedQuestion.selections[index].content
    //                statement.notContent = reultEdidtedQuestion.selections[index].notContent
    //            }
    //
    //            io.writeMessage()
    //            io.writeMessage(to: .notice, "[[\(question.key)문제수정 완료]]")
    //
    //            io.writeMessage(to: .title, "[원본]")
    //
    //            Solver(question).publish(om: outputManager,
    //                                     type: .original,
    //                                     showTitle: true, showQuestion: true, showAnswer: true, showTags: false, showHistory: false,
    //                                     showAttribute: true, showOrigSel: false)
    //
    //            io.writeMessage(to: .title, "[반전된 문제]")
    //
    //            Solver(question).publish(om: outputManager,
    //                                     type: .originalNot,
    //                                     showTitle: true, showQuestion: true, showAnswer: true, showTags: true, showHistory: false,
    //                                     showAttribute: true, showOrigSel: false)
    //
    //
    //            questionsEdited.append(question)
    //        }
    //
    //        let testsEdited = questionsEdited.map(){$0.test}.unique
    //
    //        for test in testsEdited {
    //            saveTest(test)
    //        }
    //
    //    }
    
    //    func editQuestion(_ editedQuestion : Templet.Question, _ next: Bool) -> (editedQuestion : Templet.Question?, gonnaExit : Bool) {
    //        let (instruction, value) = io.getEdit(io.getInput("수정할 대상선택 : "+io.getHelp(.InstEdit)))
    //
    //        var question = editedQuestion
    //
    //        var nextUpadte = next
    //
    //        switch instruction {
    //
    //        case .show:
    //            io.writeMessage(to: .notice, "문제의 모든 내용 출력")
    ////            questionInstManager.show(question)
    //
    //        case .notQuestion:
    //            guard let result = editStatementString(
    //                title: "문제의 반대질문",
    //                question : nil,
    //                oriStr: question.content,
    //                oriIscOrrect: nil,
    //                notOriStr: question.notContent,
    //                isNotStatementEditMode: true)
    //                else {
    //                    return editQuestion(question, nextUpadte)
    //            }
    //            nextUpadte = true
    //            question.notContent = result
    //            return editQuestion(question, nextUpadte)
    //
    //
    //        case .notLists:
    //            for (index,statement) in question.lists.enumerated() {
    //                let count = question.lists.count
    //                guard let result = editStatementString(
    //                    title: "반대목록지 \(index+1) / \(count)",
    //                    question : question.notContent,
    //                    oriStr: statement.content,
    //                    oriIscOrrect: statement.iscOrrect,
    //                    // list는 아직 oX판단하는 기능이 없다? 충격적 꼭 필요함 추가 필요 2017. 5. 21. (-)(-)(-)(-)(-)  2017. 5. 23. 추가함
    //                    notOriStr: statement.notContent,
    //                    isNotStatementEditMode: true)
    //                    else {
    //                    continue
    //                }
    //                nextUpadte = true // 단 하나라도 수정된게 있어서 result가 가드문을 빠져 나오면 업데이트 된것으로 판단. -> 파일저장
    //                question.lists[index].notContent = result
    //            }
    //            if question.lists.count == 0 {
    //                io.writeMessage(to: .error, "문제에 목록지가 없음")
    //            }
    //            return editQuestion(question, nextUpadte)
    //
    //
    //        case .notSelections:
    //            for (index,statement) in question.selections.enumerated() {
    //                let count = question.selections.count
    //                guard let result = editStatementString(
    //                    title: "반대선택지 \(index+1) / \(count)",
    //                    question : question.notContent,
    //                    oriStr: statement.content,
    //                    oriIscOrrect: statement.iscOrrect,
    //                    notOriStr: statement.notContent,
    //                    isNotStatementEditMode: true)
    //                    else {
    //                    continue
    //                }
    //                nextUpadte = true
    //                question.selections[index].notContent = result
    //            }
    //            return editQuestion(question, nextUpadte)
    //
    //
    //        case .originalQuestion:
    //            guard let result = editStatementString(
    //                title: "문제의 질문",
    //                question : nil,
    //                oriStr: question.content,
    //                oriIscOrrect: nil,
    //                notOriStr: question.notContent,
    //                isNotStatementEditMode: true)
    //                else {
    //                return editQuestion(question, nextUpadte)
    //            }
    //            nextUpadte = true
    //            question.notContent = result
    //            return editQuestion(question, nextUpadte)
    //
    //
    //        case .originalLists:
    //            for (index,statement) in question.lists.enumerated() {
    //                let count = question.lists.count
    //                guard let result = editStatementString(
    //                    title: "목록지 \(index+1) / \(count)",
    //                    question : question.content,
    //                    oriStr: statement.content,
    //                    oriIscOrrect: nil,
    //                    notOriStr: statement.notContent,
    //                    isNotStatementEditMode: false)
    //                    else {
    //                    continue
    //                }
    //                nextUpadte = true
    //                question.lists[index].content = result
    //            }
    //            if question.lists.count == 0 {
    //                io.writeMessage(to: .error, "문제에 목록지가 없음")
    //            }
    //            return editQuestion(question, nextUpadte)
    //
    //
    //        case .originalSelection:
    //            for (index,statement) in question.selections.enumerated() {
    //                let count = question.selections.count
    //                guard let result = editStatementString(
    //                    title: "선택지 \(index+1) / \(count)",
    //                    question : question.content,
    //                    oriStr: statement.content,
    //                    oriIscOrrect : statement.iscOrrect,
    //                    notOriStr: statement.notContent,
    //                    isNotStatementEditMode: false)
    //                    else {
    //                    continue
    //                }
    //                nextUpadte = true
    //                question.selections[index].content = result
    //            }
    //            return editQuestion(question, nextUpadte)
    //            
    ////        case .
    ////         solve, publishall 기능 추가 필요
    //            
    //            
    //        case .next:
    //            if nextUpadte {
    //                return (question, false)
    //            } else {
    //                return (nil, false) // -> gonnaExit은 false이나 질문반환ㄴ은 nil 이는 요번 질문은 수정안한다는 예기
    //            }
    //            
    //        case .exit:
    //            return (nil, true) // -> gonnaExit true 이는 파일저장 안하고 종료한다는 의미
    //            
    //        case .unknown:
    //            io.unkown(value, true)
    //            return editQuestion(question, nextUpadte)
    //        }
    //    }
}
