import Foundation

struct Person: Codable {
    var name: String
    var age: Int
}

// 인코딩 (직렬화)
let person = Person(name: "Alice", age: 30)
let encoder = JSONEncoder()
if let encodedData = try? encoder.encode([person]) {
    if let jsonString = String(data: encodedData, encoding: .utf8) {
        print("인코딩된 JSON 문자열: \(jsonString)")
    }
}

// 디코딩 (역직렬화)
let jsonString = "[{\"name\":\"Bob\",\"age\":25}, {\"name\":\"Alice\",\"age\":30}]"
let jsonData = jsonString.data(using: .utf8)
let decoder = JSONDecoder()
if let decodedPersons = try? decoder.decode([Person].self, from: jsonData!) {
    print("디코딩된 Person 배열: \(decodedPersons)")
    for per in decodedPersons {
        print(per.name, per.age)
    }
}
