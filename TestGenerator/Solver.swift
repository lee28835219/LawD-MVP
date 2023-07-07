//
//  Solver.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 4. 10..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

class Solver : DataStructure, ObservableObject {
    var log = ""
    var isOXChangable = false
    
    let question : Question //그 의미의 특성상 변해서는 안되는 속성이어서 var에서 let으로 변경함. 그 영향도를 항상 검토 필요. 2023. 6. 20. (-)
    
    var selections = [Selection]()
    var lists = [ListSelection]()
    
    //공통, 초기화 단계에서 꼭 정답의 존재를 확인해야 함
    var answerSelectionModifed : Selection?
    
    // 이 앱의 존재이유를 정의하는 파라미터. 문제의 OX가 변경되어, 정답이 변경되었는지 ★★★★★
    var isOXChanged = false
    var isAnswerChanged = false
    // 이에 대해 유저가 푼 문제를 직접 인스턴스에서 래핑하기 위해 변수를 추가 2023. 6. 20.
    //문제
    var number : Int = 0
    var questionOX = QuestionOX.Unknown
    var questionContent = ""
    var questionContentNote : String?
    
    
    //리스트
    var listsContent : [String] = []
    var listsIscOrrect : [Bool?] = []
    var listsIsAnswer : [Bool?] = []
    var listsNumberString : [String] = []
    var origialListsNumberString : [String] = []
    
    //선택지
    var selectionsContent : [String] = []
    var selsIscOrrect : [Bool?] = []
    var selsIsAnswer : [Bool?] = []
    var originalSelectionsNumber : [String] = []
    
    //정답
    var ansSelNumber = 0
    var ansSelContent = ""
    var ansSelIscOrrect : Bool? = nil
    var ansSelIsAnswer : Bool? = nil
    
    var originalAnsSelectionNumber = ""

    //Find유형 문제용
    @Published var originalShuffleMap = [(original : ListSelection, shuffled : ListSelection)]()
    @Published var answerListSelectionModifed = [ListSelection]()
    
    // 문제를 풀면 입력하는 항목
    @Published var chosenSelectionNumber : Int? = nil
    @Published var chosenSelection : Selection? = nil  // 유저가 푼 선택지
    @Published var isRight : Bool? = nil // 가장 중요한 결과
    
    @Published var date : Date? = nil  // 문제를 풀기 시작한 시간?
    @Published var duration : Double? = nil // 문제푼시간
    
    // 문제를 풀고 사용자가 입력하는 항목
    @Published var comment : String = "" // 유저가 직접 입력하는 커멘트
    @Published var commentDate : Date? = nil
    
    // hirechy 참고용
    let generator : Generator? = nil
    
    // shuffle 및 bypass용 초기화함수
    init(_ question : Question, gonnaChange : Bool = false) {
        let key = "key"
        
        // 로그를 시작하는 부분
        log = ConsoleIO.newLog("\(#file)")
        
        // http://stackoverflow.com/questions/34560768/can-i-throw-from-class-init-in-swift-with-constant-string-loaded-from-file
        // Can I throw from class init() in Swift with constant string loaded from file?, 초기화 단계에서 정답의 존재가 없다면 에러를 발생하다록 추후 수정(-) 2017. 4. 26.
        //http://stackoverflow.com/questions/31038759/conditional-binding-if-let-error-initializer-for-conditional-binding-must-hav
        //conditional binding에 관하여
        
//         0. 문제를 저장하여 초기화 완료
        self.question = question
        
//        주어진 문제에 답이 있는지 확인, 정답이 없는 경우 초기화를 종료하고 해당 상황을 로그로 기록합니다. 이 경우, ansSel 변수가 초기화되지 않습니다. 이는 이후에 Solver 클래스 내에서 ansSel 변수를 사용할 때 제한을 일으킬 수 있습니다.따라서, 정답이 없는 경우에는 해당 변수를 사용하는 기능이나 로직에서 예외 처리를 해주어야 합니다. 2023. 6. 17. 챗지피티
        guard let ansSel = question.answerSelection else {
            log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "\(question.key) Shuffling하려하니 문제 정답이 없음")
            log = ConsoleIO.closeLog(log, file: "\(#file)")
            super.init(UUID(), key)
            return
        }
        
//     완성 2017. 4. 26.  -> 정답은 없을 수 없도록 questiond에서 체크하므로 이 에러체크를 그냥 nil반환에서 리턴으로 수정함 2017. 5. 19.
//     그러나 선택지가 없는 것은 가능할 것임 이때에는 그냥 nil말고 질문만 반환하면 될것, 어짜피 selections는 []으로 초기화 되 있으므로 논리에 어긋나지 않음
//     가드 구문에서 if문으로 수정해서 로그 찍는 걸로만 끝냄
        if question.selections.count == 0 {
            log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "\(question.key) Shuffling하려하니 문제 선택지가 없음")
            log = ConsoleIO.closeLog(log, file: "\(#file)")
            super.init(UUID(), key)
            return
        }
        
        log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "\(question.key) 문제 정답여부, 선택지여부 에러체크 통과함")
        
//     0. 에러체크 끝났으니 목록, 선택지, 정답의 주소를 저장
        self.lists = question.lists //하나도 없어도 셔플링은 가능할 것, Find 유형 문제일 때 에러체크를 하는게 좋을까?
        self.selections = question.selections
        self.answerSelectionModifed = ansSel
        super.init(UUID(), key)
//     추후 계속 초기화 단계의 에러체크를 추가합시다. (+) 2017. 5. 4.
        
//     이제 gonnaChange을 중심으로 초기화를 시작함.
//     이 클래스에서 가장 중요한 부분
        if gonnaChange {
            // 문제변경
            log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "-\(question.key) 문제 변경을 시작함")
            
            // 문제를 섞는 가장 중요한 부분
            switch question.questionType {
            case .Find:
                let result = changeFindTypeQuestion()
                self.selections = result.selections
                self.isOXChanged = result.isOXChanged
                self.answerListSelectionModifed = result.answerListSelectionModifed
                self.originalShuffleMap = result.originalShuffleMap
                self.isAnswerChanged = result.isAnswerChanged
                
            case .Select:
                let result = changeSelectTypeQuestion()
                self.selections = result.selections
                self.isOXChanged = result.isOXChanged
                self.isAnswerChanged = result.isAnswerChanged
                self.answerSelectionModifed = result.answerSelectionModifed
                
            case .Unknown:
                self.selections = changeCommonTypeQuestionSelections() // 선택지 순서만 변경하고 끝나게 됨
            }
            
            // 로그를 남기는 부분
            let logstr1 = self.isOXChanged ? "변경하고" : "변경하지 않고"
            let logstr2 = self.isAnswerChanged ? "변경하였음" : "변경하지 않았음"
            log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "문제OX를 \(logstr1) 정답을 \(logstr2)")
            if question.answer == self.answerSelectionModifed!.number {
                log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "정답은 \(question.answer)에서 변경하지 않음")
            } else {
                log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "정답은 \(question.answer)에서 \(self.answerSelectionModifed!.number)로 변경함")
            }
            
            // 로그를 끝내는 부분
            log = ConsoleIO.closeLog(log, file: "\(#file)")
            
//            print(log)
        } else {
            // 문제 유지
            self.answerListSelectionModifed = question.answerLists
            
            for list in lists {
                self.originalShuffleMap.append((list,list))
            }
            
            log = ConsoleIO.writeLog(log, funcName: "\(#function)", outPut: "\(question.key) 문제를 변경하지 않고 초기화함")
            log = ConsoleIO.closeLog(log, file: "\(#file)")
            
            // print(log)
        }
        
        // 스위프트유아이에서의 출력 편의를 위하여, 유저가 푼 문제를 직접 래핑하기 위한 구문을 추가함. 2023. 6. 20.
        // 질문
        (self.questionOX, self.questionContent) = self.getModifedQuestion()
        if let contNote = self.question.contentNote {
            self.questionContentNote = contNote
        }
        
        // 목록
        for (index, list) in self.lists.enumerated() {
            let listResult = self.getModfiedStatementOfCommonStatement(statement: list)
            // (content: String, iscOrrect: Bool?, isAnswer: Bool?)
            listsContent.append(listResult.content)
            listsIscOrrect.append(listResult.iscOrrect)
            listsIsAnswer.append(listResult.isAnswer)
            listsNumberString.append(list.getListString(int: index+1))
            origialListsNumberString.append(list.getListString())
        }
        
        //선택지와 정답
        for (index,sel) in self.selections.enumerated() {
            // 컴퓨팅 능력을 낭비하는 것이어서 찝찝 다른 방법으로 할 방법은? 출력이 튜플이라서 lazy var도 안된다. 2017. 5. 6. (-)
            // var selResult = self.getModfiedStatementOfCommonStatement(statement: sel)
            
            // let (,,)형식으로 해결 2017. 5. 21.
            var selResult : (content: String, iscOrrect: Bool?, isAnswer: Bool?) = ("", nil, nil)
            
            switch self.question.questionType {
            case .Find:
                switch self.question.questionOX {
                case .O:
                    selResult = self.getModifedListContentStatementInSelectionOfFindTypeQuestion(selection: sel)
                case .X:
                    selResult = self.getModifedListContentStatementInSelectionOfFindTypeQuestion(selection: sel)
                case .Correct:
                    selResult = self.getModfiedStatementOfCommonStatement(statement: sel)
                case .Unknown:
                    selResult = self.getModfiedStatementOfCommonStatement(statement: sel)
                }
            case .Select:
                selResult = self.getModfiedStatementOfCommonStatement(statement: sel)
            case .Unknown:
                selResult = self.getModfiedStatementOfCommonStatement(statement: sel)
            }
            
            selectionsContent.append(selResult.content)
            selsIscOrrect.append(selResult.iscOrrect)
            selsIsAnswer.append(selResult.isAnswer)
            originalSelectionsNumber.append(sel.number.roundInt)
            
            if sel === self.answerSelectionModifed {
                ansSelNumber = (index + 1)
                ansSelContent = selResult.content
                ansSelIscOrrect = selResult.iscOrrect
                ansSelIsAnswer = selResult.isAnswer
                originalAnsSelectionNumber = sel.number.roundInt
            }
        }
        return
    }
    
    // Restore용 초기화함수
    init(_ question: Question, selections: [Selection], lists: [ListSelection], answerSelectionModifed: Selection?, isOXChanged: Bool, isAnswerChanged: Bool, originalShuffleMap: [(ListSelection,ListSelection)], answerListSelectionModifed : [ListSelection]) {
        self.question = question
        self.selections = selections
        self.lists = lists
        self.answerSelectionModifed = answerSelectionModifed
        self.isOXChanged = isOXChanged
        self.isAnswerChanged = isAnswerChanged
        self.originalShuffleMap = originalShuffleMap
        self.answerListSelectionModifed = answerListSelectionModifed
        
        super.init(UUID(), "hey")
    }
    
    // selections 배열 안에서 정답의 Index에서 +1을 반환(정답번호)
    func getAnswerNumber() -> Int {
        //http://stackoverflow.com/questions/24028860/how-to-find-index-of-list-item-in-swift
        //How to find index of list item in Swift?, index의 출력 형식 공부해야함 2017. 4. 25.
        guard let ansNumber = selections.index(where: {$0 === answerSelectionModifed}) else {
            fatalError("error>>getAnswerNumber 실패함")
        }
        return ansNumber + 1
    }
    
    // 사촌들을 모두 만들어내는 함수
    func generateRandomSolvers(count: Int) -> [Solver] {
        var newGen = [Solver]()
        newGen.append(self)
        print("호출된 문제 자신을 추가함.")
        for i in 2...count {
//            var gonnaAdd = true
//            let newSol = Solver(self.question, gonnaChange: true)
//            for sol in newGen {
//                if sol.questionOX == newSol.questionOX &&
//                        (sol.selections[0] == newSol.selections[0] &&
//                         sol.selections[1] == newSol.selections[1] &&
//                         sol.selections[2] == newSol.selections[2] &&
//                         sol.selections[3] == newSol.selections[3] &&
//                         sol.selections[4] == newSol.selections[4])
//
//                {
//                    gonnaAdd = false
//                }
//            }
//            if gonnaAdd {
                newGen.append(Solver(self.question, gonnaChange: true))
                print("작업중인 solver는 \(i)이며 문제 추가함.")
//            } else {
//                print("작업중인 solver는 \(i)이며 문제 추가안함.")
//            }
        }
        
//        newGen = newGen.sorted { $0.questionOX.rawValue < $1.questionOX.rawValue }
        
        // 솔버의 문제번호를 추가합니다.
        for (i, sol) in newGen.enumerated() {
            sol.number = i + 1
        }
        print("\(newGen.count) 문제 생성됨.")
        return newGen
    }
    
    class func getWrappedContent(_ contentUnwrapped : String?) -> String {
        if contentUnwrapped == nil {
            return "(없음)"
        } else {
            return contentUnwrapped!
        }
        
    }
    
    class func getNotWrappedBool(_ unwrappedBool : Bool?) -> Bool? {
        if unwrappedBool == nil {
            return nil
        } else {
            return unwrappedBool!
        }
    }
    
    class func getNotQuestionOX(_ oriQuestionOX : QuestionOX) -> QuestionOX {
        if oriQuestionOX == .O {
            return .X
        } else {
            if oriQuestionOX == .O {
                return .X
            } else {
            return oriQuestionOX
            }
        }
    }
}
