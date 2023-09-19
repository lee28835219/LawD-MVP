import Foundation

class QuestionData : Encodable {
    // 메타적 속성
//    private(set) var id : UUID
    let id : UUID
    
    let testID :UUID? = nil
    
    var revision : Int = 0
    let creationDate : Date
    let modifiedDate : Date? = nil
    
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


var queD1 = QuestionData(id: UUID(), content: "인권에 관한 설명으로 옳지 않은 것은?", questionType: .Select, questionOX: .X)

print("id: \(queD1.id)")



let lawDatabaseURL
    // = URL(filePath: "/Users/lee/Library/CloudStorage/Dropbox/DropDocument/ LawDatabase")
    = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted // 읽기 쉬운 형식으로 출력

do {
    // json 데이터로 인코딩
    let jsonData = try encoder.encode(queD1)
    
    // json 데이터를 문자열로 변환
    if let jsonString = String(data: jsonData, encoding: .utf8) {
        
        print("json: \n\(jsonString)")
        
        let fileURL = lawDatabaseURL.appending(path: "queD1.json")
        do {
            try jsonString.write(to: fileURL, atomically: true, encoding: .utf8)
            print("파일 저장 성공: \(fileURL.path)")
        } catch {
            print("파일 저장 실패: \(error.localizedDescription)")
        }
    }
} catch {
    print("json 인코딩 에러: \(error.localizedDescription)")
}
