import Foundation
import Question.swift

class Person: Encodable, ObservableObject {
    var name: String
    @Published var age: Int
    
    private enum CodingKeys: String, CodingKey {
        case name
        case age
    }
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: CodingKeys.name)
        try container.encode(age, forKey: CodingKeys.age)
    }
}

// 인코딩 (직렬화)
let person = Person(name: "Alice", age: 30)
let encoder = JSONEncoder()
if let encodedData = try? encoder.encode([person]) {
    if let jsonString = String(data: encodedData, encoding: .utf8) {
        print("인코딩된 JSON 문자열: \(jsonString)")
    }
}

let question = Ques

//// 디코딩 (역직렬화)
//let jsonString = "[{\"name\":\"Bob\",\"age\":25}, {\"name\":\"Alice\",\"age\":30}]"
//let jsonData = jsonString.data(using: .utf8)
//let decoder = JSONDecoder()
//if let decodedPersons = try? decoder.decode([Person].self, from: jsonData!) {
//    print("디코딩된 Person 배열: \(decodedPersons)")
//    for per in decodedPersons {
//        print(per.name, per.age)
//    }
//}
