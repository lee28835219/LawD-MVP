// (=) 2023.09.19. 이제 문_FB4CFC8~.json을 불러와서, 이를 인스턴스로 만드는 디코딩 작업을 시작했습니다.

import Foundation

class QuestionData : Encodable, Decodable {
    // 메타적 속성들
    private(set) var id : UUID // 이렇게 하면 클래스 내부에서는 id를 읽기/쓰기할 수 있지만 클래스 외부에서는 읽기만 가능하며 수정할 수 없습니다.
    /// 이 부분은 반드시 있어야 하나, 없을 수도 있습니다. 이를 언래퍼로 정의하는 것이 더 안전해 보이므로, 추후 이를 검토하여야 합니다. 2023.09.19. (-)
    var testID :UUID? = nil
    
    
    let creationDate : Date
    
    var revision : Int = 0
    /// 초기화 시는 당연히 nil이고, json에서 읽어올 때는 nil일 수도 있고, 값이 있을 수도 있겠습니다.
    var modifiedDate : Date? = nil
    
    // 시험속성
    /// 문제번호의 원본인데, 이는 testID로 찾아갈 수 있는 데이터로 보여 만들지 않아보께요. 2023.09.19.
    // var number : Int
    /// "민법"같은 원본인데, 일단 만들지 말아보고 어떻게 문제들을 범주화할지 고민 필요합니다. 2023.09.19. (-)
    // var subjectDetails
    
    // 질문 원본 및 그 논리적 데이터
    /// 없어도 됩니다.
    var contentPrefix : String?
    /// [질문]★★★
    let content : String
    /// [반전된 질문]★★★★, 없으면 안됩니다. 그러나 없을 수도 있다는 점이 가장 어려운 점입니다.
    /// 따라서 향후 생성형 프레임워크로 content를 기반으로 자동으로 만들어주도록 하면 어떨까요? 2023.09.19. (-)
    var notContent : String?
    
    /// 없어도 됩니다.
    var contentNote : String?
    
    // 논리적으로 중요한 구문입니다.
    // 인코더블하게 이를 구현함이 이번 클래스 작성의 핵심입니다. 2023.09.19. (+)
    var questionType : QuestionType
    var questionOX : QuestionOX
    
    /// 문제에 따라 있을 수도 있는 지문에 관한 항목입니다.
    /// 원본데이터에서는 <p></p> 태그로 관리되는 매우 중요한 부분입니다.
    var passage : String?
    
    /* 혹시나 존재할 수 있는 부분으로 일단 커멘트아웃합니다.
     var passageSuffix : String?
     var questionSuffix : String? */
    
    
    init(id: UUID, content: String, questionType : QuestionType, questionOX : QuestionOX) {
        self.id = id
        self.creationDate = Date()
        
        self.content = content
        self.questionType = questionType
        self.questionOX = questionOX
    }
}

/// 향후 QuestionOX와 합쳐 하나의 enum으로 표현하도록 바꾸는게 필요할 수도 있겠네요.
/// 이 경우가 아마도 마지막 수준의 고난의도 작업이 될 듯 합니다. 2023.09.19. (-)
enum QuestionType : String, Codable {
    case Select // 고르시오
    case Find // 모두 고르시오
    case Unknown
}
enum QuestionOX : String, Codable {
    case O //옳은 것
    case X //옳지 않은 것
    case Correct // 올바른 것
    case Unknown
}

// JSON 데이터를 디코딩하는 함수
func decode(fromData data: Data) -> QuestionData? {
    do {
        // JSONDecoder를 생성합니다.
        let decoder = JSONDecoder()
        // 날짜 형식을 사용자 정의한 DateFormatter를 설정합니다.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd.'_'HH시mm분ss.SS초"
        /// 플레이그라운드여서 커멘트 아웃한것으로 클래스 도입시 살려야 합니다.2023.09.19. (-)
        /// dateFormatter.setMyDateString()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        // JSON 데이터를 디코딩하여 원하는 데이터 모델로 변환합니다.
        let questionData = try decoder.decode(QuestionData.self, from: data)
        
        return questionData
    } catch {
        print("JSON 디코딩 오류: \(error)")
        return nil
    }
}
// JSON 문자열 데이터
let jsonString = """
{
  "revision" : 0,
  "id" : "FB4CFC83-69AC-4892-8EBB-03789DCDDC1C",
  "creationDate" : "2023.09.19._21시59분07.76초",
  "content" : "인권에 관한 설명으로 옳지 않은 것은?",
  "questionType" : "Select",
  "questionOX" : "X"
}
"""

// JSON 문자열 데이터를 Data 형식으로 변환합니다.
if let jsonData = jsonString.data(using: .utf8) {
    // decodeQuestionData 함수를 호출하여 JSON 데이터를 디코딩합니다.
    if let questionData = decode(fromData: jsonData) {
        // 디코딩된 데이터를 사용합니다.
        print("ID: \(questionData.id)")
        print("Creation Date: \(questionData.creationDate)")
        print("Content: \(questionData.content)")
        print("Question Type: \(questionData.questionType)")
        print("Question OX: \(questionData.questionOX)")
        print(questionData.revision)
    }
}
