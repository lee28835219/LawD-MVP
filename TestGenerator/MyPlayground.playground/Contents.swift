import Foundation

let text = """
문41. 반사회질서의 법률행위에 해당하여 무효로 되는 것을 모두 고른 것은?(다툼이 있으면 판례에 따름)
ㄱ. 성립 과정에서 강박이라는 불법적 방법이 사용된 데 불과한 법률행위
ㄴ. 강제집행을 면할 목적으로 허위의 근저당권을 설정하는 행위
ㄷ. 양도소득세를 회피할 목적으로 실제로 거래한 매매대금보다 낮은 금액으로 매매계약을 체결한 행위
ㄹ. 이미 매도된 부동산임을 알면서도 매도인의 배임행위에 적극 가담하여 이루어진 저당권설정행위
① ㄷ ② ㄹ ③ ㄱ, ㄴ ④ ㄱ, ㄷ ⑤ ㄴ, ㄹ

문42. 의사표시의 효력발생에 관한 설명으로 틀린 것은? (다툼이 있으면 판례에 따름)
① 표의자가 매매의 청약을 발송한 후 사망하여도 그 청약의 효력에 영향을 미치지 아니한다.
② 상대방이 정당한 사유 없이 통지의 수령을 거절한 경우에도 그가 통지의 내용을 알 수 있는 객관적 상태에 놓인 때에 의사표시의 효력이 생긴다.
③ 의사표시가 기재된 내용증명우편이 발송되고 달리 반송되지 않았다면 특별한 사정이 없는 한 그 의사표시는 도달된 것으로 본다.
④ 표의자가 그 통지를 발송한 후 제한능력자가 된 경우, 그 법정대리인이 통지 사실을 알기 전에는 의사표시의 효력이 없다.
⑤ 매매계약을 해제하겠다는 내용증명우편이 상대방에게 도착하였으나, 상대방이 정당한 사유 없이 그 우편물의 수취를 거절한 경우에 해제의 의사표시가 도달한 것으로 볼 수 있다.

문43. 진의 아닌 의사표시에 관한 설명으로 틀린 것은?(다툼이 있으면 판례에 따름)
① 진의란 특정한 내용의 의사표시를 하고자 하는 표의자의 생각을 말하는 것이지 표의자가 진정으로 마음속에서 바라는 사항을 뜻하는 것은 아니다.
② 상대방이 표의자의 진의 아님을 알았을 경우, 표의자는 진의 아닌 의사표시를 취소할 수 있다.
③ 대리행위에 있어서 진의 아닌 의사표시인지 여부는 대리인을 표준으로 결정한다.
④ 진의 아닌 의사표시의 효력이 없는 경우, 법률행위의 당사자는 진의 아닌 의사표시를 기초로 새로운 이해관계를 맺은 선의의 제3자에게 대항하지 못한다.
⑤ 진의 아닌 의사표시는 상대방과 통정이 없다는 점에서 통정허위표시와 구별된다.
"""



let questionPattern = #"문\d+\."#
let optionPattern = #"[ㄱ-ㄹ]\."#
let answerPattern = #"①|②|③|④|⑤"#

var parsedQuestions: [(question: String, options: [String], answers: [String])] = []


var currentQuestion: String = ""
var currentOptions: [String] = []
var currentAnswers: [String] = []

for line in text.components(separatedBy: .newlines) {
    if line.range(of: questionPattern, options: .regularExpression) != nil {
        if !currentQuestion.isEmpty {
            parsedQuestions.append((question: currentQuestion, options: currentOptions, answers: currentAnswers))
        }
        
        currentQuestion = line
        currentOptions = []
        currentAnswers = []
    } else if line.range(of: optionPattern, options: .regularExpression) != nil {
        currentOptions.append(line.trimmingCharacters(in: .whitespacesAndNewlines))
    } else if line.range(of: answerPattern, options: .regularExpression) != nil {
        currentAnswers.append(line.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}

// 마지막 문제 추가
if !currentQuestion.isEmpty {
    parsedQuestions.append((question: currentQuestion, options: currentOptions, answers: currentAnswers))
}

// 파싱된 문제 출력
for (index, parsedQuestion) in parsedQuestions.enumerated() {
    print("문제 \(index + 1)")
    print("질문: \(parsedQuestion.question)")
    print("보기: \(parsedQuestion.options)")
    print("정답: \(parsedQuestion.answers)")
    print("---")
}
