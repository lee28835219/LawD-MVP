//
//  QuestionData.swift
//  LawD MVP
//
//  Created by Masterbuilder on 2023/09/19.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import Foundation

class QuestionData : Encodable {
    // 메타적 속성
    private(set) var id : UUID // 이렇게 하면 클래스 내부에서는 id를 읽기/쓰기할 수 있지만 클래스 외부에서는 읽기만 가능하며 수정할 수 없습니다.
    let testID :UUID? = nil // 이 부분은 반드시 있어야 하나, 없을 수도 있습니다. 이를 언래퍼로 정의하는 것이 더 안전해 보이므로, 추후 이를 검토하여야 합니다. 2023.09.19. (-)
    
    var revision : Int = 0
    let creationDate : Date
    var modifiedDate : Date? = nil
    
    //// 시험속성
    
    // var number 문제번호의 원본인데, 이는 testID로 찾아갈 수 있는 데이터로 보여 만들지 않아보께요. 2023.09.19.
    
    // var subjectDetails "민법"같은 원본인데, 일단 만들지 말아보고 어떻게 문제들을 범주화할지 고민 필요합니다. 2023.09.19. (-)
    
    //// 질문 원본 및 그 논리적 데이터
    var contentPrefix : String? // 없어도 됩니다.
    let content : String // [질문]★★★
    var notContent : String? // [반전된 질문]★★★★★, 없으면 안됩니다. 그러나 없을 수 있습니다.
        // 향후 생성형 프레임워크로 자동으로 만들어주도록 하면 어떨까요? 2023.09.19. (-)
    var contentNote : String? // 없어도 됩니다.
    
    // 논리적으로 중요한 구문입니다.
    // 인코더블하게 이를 구현함이 이번 클래스 작성의 핵심입니다. 2023.09.19. (+)
    var questionType : QuestionType
    var questionOX : QuestionOX
    
    // 문제에 따라 있을 수도 있는 지문에 관한 항목입니다.
    var passage : String?
            // 원본데이터에서는 <p></p> 태그로 관리되는 매우 중요한 부분입니다.
    // var passageSuffix : String?  // 혹시나 존재할 수 있는 부분
    // var questionSuffix : String?
    
    
    init(id: UUID, content: String, questionType : QuestionType, questionOX : QuestionOX) {
        self.id = id
        self.creationDate = Date()
        
        self.content = content
        self.questionType = questionType
        self.questionOX = questionOX
    }
}

enum QuestionOX : String, Codable {
    case O //옳은 것
    case X //옳지 않은 것
    case Correct // 올바른 것
    case Unknown
}

enum QuestionType : String, Codable {
    case Select // 고르시오
    case Find // 모두 고르시오
    case Unknown
}
