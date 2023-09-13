//
//  Question+Essential.swift
//  TestGenerator
//
//  Created by Masterbuilder on 2023/07/08.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import Foundation

extension Question {
    //자동으로 이 명령을 실행하는 방법은 없을까? (+) 2017. 4. 30.
    //목록에 자동으로 iscOrrect와 isAnswer를 찍어주는 함수
    //정답이 제대로 입력 안되있으면 못찼음
    //현재 FO와 FX만 구현됨, FC는 못찾음
    // select 형식일 경우에도 selection별로 찍어주도록 추가함 2017. 5. 31.
    public func findAnswer() -> Bool {
        
        guard let ans = self.answerSelection else {
            fatalError("정답 포인터가 없어서 정답을 찾을 수 없음 \(self.key)")
        }
        
        for sel in self.selections {
            sel.findAnswer()
        }
        
        switch questionType {
        case .Find:
            switch questionOX {
            case .O:
                _setlistInContentOfSelection()
                for listSel in lists {
                    let listSelString = listSel.getListString()
                    if ans.content.range(of: listSelString) != nil {
                        listSel.iscOrrect = true
                        listSel.isAnswer = true
                        self.answerLists.append(listSel)
                    } else {
                        listSel.iscOrrect = false
                        listSel.isAnswer = false
                    }
                }
                return true
            case .X:
                _setlistInContentOfSelection()
                for listSel in lists {
                    let listSelString = listSel.getListString()
                    if ans.content.range(of: listSelString) != nil {
                        listSel.iscOrrect = false
                        listSel.isAnswer = true
                        self.answerLists.append(listSel)
                    } else {
                        listSel.iscOrrect = true
                        listSel.isAnswer = false
                    }
                }
                return true
            case .Correct:
                return false
            case .Unknown:
                return false
            }
        case .Select:
            switch questionOX {
            case .O:
                return false
            case .X:
                return false
            case .Correct:
                return false
            case .Unknown:
                return false
            }
        case .Unknown:
            return false
        }
    }
    
    // 객체 밖에서 함수가 들어나지 않도록 정의하는 방법은 무었인가 (+) 2017. 4. 30.
    // 다시 체크할 수 있도록 수정필요 (+) 2017. 5. 5.
    func _setlistInContentOfSelection() {
        
        for selection in selections {
            // 혹시몰라서 초기화 시켜두었음
            // selection.listInContentOfSelection = []
            
            // 초기화보다는 잘못된 함수호출인 셈이니 치명적 에러를 발생시킴이 맞을 듯 2017. 5. 9.
            // 문제 정답을 수정하면서 이 함수를 호출할 때는 더이상 listInContentOfSelection이 []이 아닌데 여기서 에러 체크 하면 프로그램 진행이 안됨 그래서 []이 아닐때는 다시 []초기화 시켜주고 프로그램을 진행하도록 수정 2017. 5. 31.
            // 덮어씌어서 ㄱ,ㄴ,ㄷ이 이중으로 추가되는 문제 방지를 위해서, 아래 조건식은 꼭 필요할 것이며 []이 아니면 []로 다시 초기화 하는 액션 필요함
            // if selection.listInContentOfSelection != [] {
                // fatalError("잘못된 함수호출 _setlistInContentOfSelection(), 선택지의 내용안에 있는 목록지가 초기화되지 않은 상태에서 호출됨")
            //}
            selection.listInContentOfSelection = []
        
            for list in lists {
                // 선택지에 문제의 목록 문자가 존재하는지 확인하는 분기
                if selection.content.range(of: list.getListString()) != nil {
                    selection.listInContentOfSelection.append(list)
                }
                
            }
        }
    }
}
