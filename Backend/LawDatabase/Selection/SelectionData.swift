//
//  SelectionData.swift
//  LawD Console System
//
//  Created by Masterbuilder on 2023/09/20.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import Foundation

class statementData: Codable {
    // [0] 메타적 속성들
    /// 이렇게 하면 클래스 내부에서는 id를 읽기/쓰기할 수 있지만 클래스 외부에서는 읽기만 가능하며 수정할 수 없습니다.
    private(set) var id : UUID
    /// 소속 문제로, 이 부분은 반드시 있어야 하고,
    /// QuestionData와 다르게 없을 수도 없습니다.
    var questionID :UUID? = nil
    
    let creationDate : Date
    
    var revision : Int = 0
    /// 초기화 시는 당연히 nil이고, json에서 읽어올 때는 nil일 수도 있고, 값이 있을 수도 있겠습니다.
    var modifiedDate : Date? = nil
    
    
    /// ★선택지의 번호입니다.
    let number : Int
    
    // [1] 선택지 원본 및 그 논리적 데이터
    /// [선택지]★★★
    let content : String
    /// [반전된 선택지]★, 없으면 안됩니다. 그러나 없을 수도 있다는 점이 가장 어려운 점입니다.
    /// 따라서 향후 생성형 프레임워크로 content를 기반으로 자동으로 만들어주도록 하면 어떨까요? ★★★★★ 2023.09.19. (-)
    var notContent : String?
    
    

}
