//
//  DC법조윤리문제.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 1..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Cocoa

class DC법조윤리: DataConverter {
    
    //    Read JSON file with Swift 3
    //    http://stackoverflow.com/questions/40438784/read-json-file-with-swift-3

    convenience init() {
        self.init(testCategory: "변호사윤리시험", testSubject: "법조윤리", answerFilename: "변호사윤리시험-1회~7회-법조윤리-정답.json", questionFilename: "변호사윤리시험-1회~7회-법조윤리-문제.txt")
        // 정답을 파싱
        do {
            if let path = self.answerPath {
                //                print(path)
                let data = try Data(contentsOf: path)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let obj = json as? [String:Any] {
                    for test in obj {
                        if let queData = test.value as? [[String:Any]] {
                            for answerPair in queData {
                                if let queNo = answerPair["문번"] as? Int {
                                    if let ans = answerPair["정답"] as? Int {
                                        // Swift How to get integer from string and convert it into integer
                                        // http://stackoverflow.com/questions/30342744/swift-how-to-get-integer-from-string-and-convert-it-into-integer
                                        guard let testNumber = Int(test.key.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) else {
                                            fatalError("법조윤리 정답 파싱 error")
                                        }
                                        let temp정답 = 정답(test: test.key, testNumber: testNumber, questionNumber: queNo, answer: ans)
                                        정답들.append(temp정답)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } catch {
            fatalError("법조윤리 정답 파싱 error")
        }
        //        print(testName," 정답 입력 완료")

        
        
        // 문제를 파싱
        
        //Read and write data from text file
        //http://stackoverflow.com/questions/24097826/read-and-write-data-from-text-file
        
        
        print("--법조윤리 문제 파싱시작")
        
        let wholeTestString = getText(path: self.questionPath)
        sliceTestString(regexPattern: "=-=변호사윤리 시험기출 \\d회 \\d{3}.+=-=", string: wholeTestString)
        
        for test in 시험들 {
            sliceQuestionString(regexPattern: "문\\s{0,}\\d+.", residualString: test.raw, test: test, headerUn: nil)
        }
        
        
        //정답추가
        for test in 시험들 {
            let ansTest = 정답들.filter({$0.testNumber == test.number})
            for (index,que) in test.questions.enumerated() {
                let ansQue = ansTest.filter({$0.questionNumber == que.number})
                if ansQue.count == 1 {
                    que.answer = ansQue[0].answer!
                } else {
                    fatalError("can't find answer \(test.category) \(test.number) \(index+1)")
                }
            }
        }
        
        
        // 문제를 분설
        for test in 시험들 {
            for que in test.questions {
                var queStr = que.raw
                let queCutSelectionRange = queStr.range(of: "(①|②|③|④|⑤|⑥|⑦|⑧|⑨|⑩)(.+\\n{0,}){1,9}", options: .regularExpression)
                if queCutSelectionRange == nil {
                    fatalError("문제 파싱 중 문제의 선택지를 찾을 수 없음")
                }
                let queCutSelection = queStr.substring(with: queCutSelectionRange!)
                queStr = queStr.substring(with: queStr.startIndex..<queCutSelectionRange!.lowerBound)
                
                var queCutListSelWord : String? = nil
                let queCutListSelWordRange = queStr.range(of: "(가(\\..+\\n{0,}\\s{0,}))((나|다|라|마|바|사|아|자|차|카|타|파|하)(\\..+\\n{0,}\\s{0,})){1,14}", options: .regularExpression)
                if queCutListSelWordRange != nil {
                    queCutListSelWord = queStr.substring(with: queCutListSelWordRange!)
                    queStr = queStr.substring(with: queStr.startIndex..<queCutListSelWordRange!.lowerBound)
                }
                
                var queCutListSelLetter : String? = nil
                let queCutListSelLetterRange = queStr.range(of: "((ㄱ|ㄴ|ㄷ|ㄹ|ㅁ|ㅂ|ㅅ|ㅇ|ㅈ|ㅊ|ㅋ|ㅌ|ㅍ|ㅎ)(\\..+\\n{0,}\\s{0,})){1,14}", options: .regularExpression)
                if queCutListSelLetterRange != nil {
                    queCutListSelLetter = queStr.substring(with: queCutListSelLetterRange!)
                    queStr = queStr.substring(with: queStr.startIndex..<queCutListSelLetterRange!.lowerBound)
                }
                
                que.content = queStr.trimmingCharacters(in: .whitespacesAndNewlines)
                
                que.rawSelections = queCutSelection.trimmingCharacters(in: .whitespacesAndNewlines)
                sliceSelectionString(regexPattern: "①|②|③|④|⑤|⑥|⑦|⑧|⑨|⑩", residualString: que.rawSelections, question: que, headerUn: nil)
                if queCutListSelWord != nil && queCutListSelLetter != nil {
                    fatalError("문제 파싱중에 목록선택지의 구조가 이상하게 파싱되었음")
                }
                if queCutListSelLetter != nil {
                    que.rawLists = queCutListSelLetter!.trimmingCharacters(in: .whitespacesAndNewlines)
                    sliceListSelectionString(regexPattern: "ㄱ\\.|ㄴ\\.|ㄷ\\.|ㄹ\\.|ㅁ\\.|ㅂ\\.|ㅅ\\.|ㅇ\\.|ㅈ\\.|ㅊ\\.|ㅋ\\.|ㅌ\\.|ㅍ\\.|ㅎ\\.", residualString: que.rawLists, question: que, headerUn: nil)
                    print(que.findAnswer(),"answer")
                }
                if queCutListSelWord != nil {
                    que.rawLists = queCutListSelWord!.trimmingCharacters(in: .whitespacesAndNewlines)
                    sliceListSelectionString(regexPattern: "가\\.|나\\.|다\\.|라\\.|마\\.|바\\.|사\\.|아\\.|자\\.|차\\.|카\\.|타\\.|파\\.|하\\.", residualString: que.rawLists, question: que, headerUn: nil)
                    print(que.findAnswer(),"answer")
                }
            }
        }
//        (가(\..+\n{0,}\s{0,}))((나|다|라|마|바|사|아|자|차|카|타|파|하)(\..+\n{0,}\s{0,})){1,14}
//
//        ((ㄱ|ㄴ|ㄷ|ㄹ|ㅁ|ㅂ|ㅅ|ㅇ|ㅈ|ㅊ|ㅋ|ㅌ|ㅍ|ㅎ)(\..+\n{0,}\s{0,})){1,14}
//        
//        (①|②|③|④|⑤|⑥|⑦|⑧|⑨|⑩)(.+\n){1,9}
//
//        for test in 시험들 {
//            for (index,que) in test.questions.enumerated() {
//                print("oooooooo ",test.category,test.subject,test.number,que.number!)
//                print("--문제 : \(que.content)")
//                print("---열거선택지 :")
//                for listSel in que.listSelections {
//                    print(listSel.getListString()+".", listSel.content, listSel.isAnswer)
//                }
//                print("---선택지 : ")
//                for sel in que.selections {
//                    print(sel.selectNumber.roundInt,sel.content, sel.isAnswer)
//                }
//                print("--정답 \(que.answer)")
//                print("")
//            }
//        }
    }
}


