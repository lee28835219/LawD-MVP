//
//  Database.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 3. 22..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation
class Database {
    var name = "default"
    var questions : [Question] = []
    var questionsShuffled : [QuestionShuffled] = []
    
    init() {
        //기본 문제생성, 법인 아닌 사단 SO
        let question0 = Question(questionKey : "TESTCVA00025", isPublished : true, testDate : "1701", testCategory: "변시", testSubject: "민사법", questionType: QuestionType.Select, questionOX : QuestionOX.X , content : "법인 아닌 사단에 관한 설명 중 옳지 않은 것은?", answer : 5)
        question0.contentControversal = "법인 아닌 사단에 관한 설명 중 옳은 것은?"
        question0.contentNote = "(다툼이 있는 경우 판례에 의함)"
        
        // 1번, 옳은 지문
        let selectionVeryFirst1 = TestSelction(question: question0, selectNumber: 1, content: "법인 아닌 사단의 사원이 존재하지 않게 된 경우에도 그 법인 아닌 사단은 청산사무가 완료될 때까지 청산의 목적범위 내에서 권리의무의 주체가 된다.")
        // 2번, 옳은 지문
        let selectionVeryFirst2 = TestSelction(question: question0, selectNumber: 2, content: "법인 아닌 사단의 대표자가 정관에 규정된 대표권 제한에 위반하여 법률행위를 한 경우, 그 상대방이 대표권 제한 및 그 위반 사실을 알았거나 과실로 인해 알지 못한 때에는 그 법률행위는 무효이다.")
        // 3번, 옳은 지문
        let selectionVeryFirst3 = TestSelction(question: question0, selectNumber: 3, content: "법인 아닌 사단의 정관에 특별한 규정이 없는 경우 법인 아닌 사단의 대표자가 타인 간의 금전채무를 보증하기 위해 사원총회 결의를 거칠 필요는 없다.")
        // 4번, 옳은 지문
        let selectionVeryFirst4 = TestSelction(question: question0, selectNumber: 4, content: "법인 아닌 사단의 총회 소집권자가 총회 소집을 철회하는 경우 반드시 총회 소집과 동일한 방식으로 통지해야 할 필요는 없고, 총회 구성원들에게 소집 철회의 결정이 있었음이 알려질 수 있는 적절한 조치를 취하는 것으로 충분하다.")
        // 5번, 틀린 지문, 정답
        let selectionVeryFirst5 = TestSelction(question: question0, selectNumber: 5, content: "법인 아닌 사단의 채권자가 채권자대위권에 기하여 법인 아닌 사단의 총유재산에 대한 권리를 대위행사하는 경우, 사원총회의 결의 등 법인 아닌 사단의 내부적 의사결정 절차를 거쳐야 한다.")
        
        // 1번 지문 반전, 틀린지문
        selectionVeryFirst1.contentControversal = "법인 아닌 사단의 사원이 존재하지 않게 된 경우에는 그 법인 아닌 사단은 사단이 소멸하여 소송상의 당사자능력을 상실한다."
        // 2번 지문 반전, 틀린지문
        selectionVeryFirst2.contentControversal = "법인 아닌 사단의 대표자가 정관에 규정된 대표권 제한에 위반하여 법률행위를 한 경우, 그 상대방이 대표권 제한 및 그 위반 사실을 알았거나 과실로 인해 알지 못한 때에도 그 법률행위는 유효하다."
        // 3번 지문 반전, 틀린지문
        selectionVeryFirst3.contentControversal = "법인 아닌 사단의 정관에 특별한 규정이 없는 경우라도 법인 아닌 사단의 대표자가 타인 간의 금전채무를 보증하기 위해서는 사원총회 결의를 거쳐야 한다."
        // 4번 지문 반전, 틀린지문
        selectionVeryFirst4.contentControversal = "법인 아닌 사단의 총회 소집권자가 총회 소집을 철회하는 경우 반드시 총회 소집과 동일한 방식으로 통지해야 한다."
        // 5번 지문 반전, 틀린지문
        selectionVeryFirst5.contentControversal = "법인 아닌 사단의 채권자가 채권자대위권에 기하여 법인 아닌 사단의 총유재산에 대한 권리를 대위행사하는 경우, 사원총회의 결의 등 법인 아닌 사단의 내부적 의사결정 절차를 거칠 필요가 없다."
        
        self.questions.append(question0)
        
        //기본 문제생성, 매도인의 담보책임 SX
        let question1 = Question(questionKey : "TESTCVA00547", isPublished : true, testDate : "1701", testCategory: "변시", testSubject: "민사법", questionType: QuestionType.Select, questionOX : QuestionOX.O , content : "매도인의 담보책임에 관한 설명 중 옳은 것은?", answer : 5)
        question1.contentControversal = "매도인의 담보책임에 관한 설명 중 옳지 않은 것은?"
        question1.contentNote = "(다툼이 있는 경우 판례에 의함)"
        
        // 1번, 옳은 지문
        let selectionVeryFirst11 = TestSelction(question: question1, selectNumber: 1, content: "甲은 자기 소유 17필지의 토지에 대하여 일괄하여 매매대금을 정하고 乙에게 매도하였으나 그 중 2필지가 타인 소유로 밝혀진 경우 매도인 甲이 그 2필지만에 대하여 매매계약을 해제할 수 있다.")
        // 2번, 옳은 지문
        let selectionVeryFirst12 = TestSelction(question: question1, selectNumber: 2, content: "매매목적물의 하자로 인하여 확대손해가 발생하였다는 이유로 매도인에게 그 확대손해에 대한 배상책임을 지우기 위하여는 채무의 내용으로 된 하자 없는 목적물을 인도하지 못한 의무위반사실 외에 그러한 의무위반에 대한 매도인의 귀책사유는 요구되지 않는다.")
        // 3번, 옳은 지문
        let selectionVeryFirst13 = TestSelction(question: question1, selectNumber: 3, content: "매매목적물의 하자가 경미하여 수선 등의 방법으로도 계약의 목적을 달성하는 데 별다른 지장이 없고, 매도인에게 하자 없는 물건의 급부의무를 지우면 다른 구제방법에 비하여 매도인에게 현저한 불이익이 발생되는 경우라도 공평의 원칙상 매수인의 완전물급부청구권의 행사를 제한할 수 없다.")
        // 4번, 옳은 지문
        let selectionVeryFirst14 = TestSelction(question: question1, selectNumber: 4, content: "매매의 목적이 된 권리가 타인에게 속하여 매도인이 그 권리를 취득하여 매수인에게 이전할 수 없게 된 경우, 그 권리가 타인에게 속함을 알지 못한 매수인이 매도인에게 배상을 청구할 수 있는 손해에는 매수인이 얻을 수 있었던 이익의 상실은 포함되지 않는다.")
        // 5번, 틀린 지문, 정답
        let selectionVeryFirst15 = TestSelction(question: question1, selectNumber: 5, content: "평형별 세대당 건물 및 공유대지가 일정한 면적을 가지고 있다는 데 주안을 두고 대금을 그 면적을 기준으로 정한 아파트 분양계약에서 분양자가 공유대지 면적의 일부를 이전할 수 없게 되었고, 그 일부 이행불능이 분양계약 체결 당시 존재한 사유에 의한 경우, 수분양자는 분양자에게 부족한 면적비율에 따라 대금감액을 청구할 수 있다.")
        
        // 1번 지문 반전, 틀린지문
        selectionVeryFirst11.contentControversal = "甲은 자기 소유 17필지의 토지에 대하여 일괄하여 매매대금을 정하고 乙에게 매도하였으나 그 중 2필지가 타인 소유로 밝혀진 경우 매도인 甲이 그 2필지만에 대하여 매매계약을 해제할 수 없다."
        // 2번 지문 반전, 틀린지문
        selectionVeryFirst12.contentControversal = "매매목적물의 하자로 인하여 확대손해가 발생하였다는 이유로 매도인에게 그 확대손해에 대한 배상책임을 지우기 위하여는 채무의 내용으로 된 하자 없는 목적물을 인도하지 못한 의무위반사실 외에 그러한 의무위반에 대한 매도인의 귀책사유가 인정될 수 있어야만 한다."
        // 3번 지문 반전, 틀린지문
        selectionVeryFirst13.contentControversal = "매매목적물의 하자가 경미하여 수선 등의 방법으로도 계약의 목적을 달성하는 데 별다른 지장이 없고, 매도인에게 하자 없는 물건의 급부의무를 지우면 다른 구제방법에 비하여 매도인에게 현저한 불이익이 발생되는 경우에는, 공평의 원칙상 매수인의 완전물급부청구권의 행사를 제한할 수 있다."
        // 4번 지문 반전, 틀린지문
        selectionVeryFirst14.contentControversal = "매매의 목적이 된 권리가 타인에게 속하여 매도인이 그 권리를 취득하여 매수인에게 이전할 수 없게 된 경우, 그 권리가 타인에게 속함을 알지 못한 매수인이 매도인에게 배상을 청구할 수 있는 손해에는 매수인이 얻을 수 있었던 이익의 상실도 포함된다."
        // 5번 지문 반전, 틀린지문
        selectionVeryFirst15.contentControversal = "평형별 세대당 건물 및 공유대지가 일정한 면적을 가지고 있다는 데 주안을 두고 대금을 그 면적을 기준으로 정한 아파트 분양계약에서 분양자가 공유대지 면적의 일부를 이전할 수 없게 되었고, 그 일부 이행불능이 분양계약 체결 당시 존재한 사유에 의한 경우, 수분양자는 분양자에게 채무불이행책임을 물을 수 있다."
        
        self.questions.append(question1)
        
        //기본 문제생성, 계약 SD
        let question2 = Question(questionKey : "TESTCVA00515", isPublished : true, testDate : "1406", testCategory: "변모", testSubject: "민사법", questionType: QuestionType.Select, questionOX : QuestionOX.Difference , content : "다음 설명들에 대하여 옳은 것과 옳지 않은 것을 표시할 경우, 다른 설명과 그 결과가 다른 하나는?", answer : 3)
        question2.contentNote = "(다툼이 있는 경우 판례에 의함)"
        
        // 1번, 옳은 지문
        let selectionVeryFirst21 = TestSelction(question: question2, selectNumber: 1, content: "채권자가 자신을 위하여 저당권이 설정된 물상보증인 소유의 토지에 대하여 채무자의 채무불이행을 이유로 임의경매를 신청한 경우에는 법원의 경매개시결정이 난 때에 소멸시효의 진행이 중단된다.")
        // 2번, 옳은 지문
        let selectionVeryFirst22 = TestSelction(question: question2, selectNumber: 2, content: "갑의 아들인 을이 갑의 인장을 위조하여 갑 소유 토지의 소유권을 A에게 이전하고, A가 이를 다시 B에게 이전한 경우, 을의 무권대리행위에 대한 추인은 무권대리인과 거래한 A에 대해서만 할 수 있고, 무권대리인에 대해서는 할 수 없다.")
        // 3번, 옳은 지문
        let selectionVeryFirst23 = TestSelction(question: question2, selectNumber: 3, content: "약관을해석할 때에는 계약당사자의 개별적, 주관적인 사정이나 계약 체결에 이른 사정을 고려할 필요 없이 객관적, 획일적으로 해석하여야 하는 것이 원칙이다.")
        // 4번, 옳은 지문
        let selectionVeryFirst24 = TestSelction(question: question2, selectNumber: 4, content: "기간을 주, 월 또는 년의 처음으로부터 기산하지 아니하는 때에는 최후의 주, 월 또는 년에서 그 기산일에 해당하는 날의 다음날로 기간이 만료한다.")
        // 5번, 틀린 지문, 정답
        let selectionVeryFirst25 = TestSelction(question: question2, selectNumber: 5, content: "부(父) 사망 후 미성년인 甲 소유의 상속부동산을 관리, 처분하던 그 모(母)가 甲의 학비를 조달하기 위하여 甲 소유 부동산을 甲 명의로 처분한 경우, 그 토지를 매수한 乙이 악의이거나 과실 있는 때에는 乙은 토지의 소유권을 취득하지 못한다.")
        
        // 1번 지문 반전, 틀린지문
        selectionVeryFirst21.contentControversal = "채권자가 자신을 위하여 저당권이 설정된 물상보증인 소유의 토지에 대하여 채무자의 채무불이행을 이유로 임의경매를 신청한 경우에는 채무자에게 그 결정이 송달되거나 또는 경매기일이 통지된 경우에 소멸시효의 진행이 중단된다."
        // 2번 지문 반전, 틀린지문
        selectionVeryFirst22.contentControversal = "갑의 아들인 을이 갑의 인장을 위조하여 갑 소유 토지의 소유권을 A에게 이전하고, A가 이를 다시 B에게 이전한 경우, 을의 무권대리행위에 대한 추인은 무권대리인과 거래한 A는 물론이고, 무권대리인에 대해서도 할 수 있다."
        // 3번 지문 반전, 틀린지문
        selectionVeryFirst23.contentControversal = "약관을해석할 때에는 계약당사자의 개별적, 주관적인 사정이나 계약 체결에 이른 사정을 고려하여 주관적, 구체적으로 해석하여야 하는 것이 원칙이다."
        // 4번 지문 반전, 틀린지문
        selectionVeryFirst24.contentControversal = "기간을 주, 월 또는 년의 처음으로부터 기산하지 아니하는 때에는 최후의 주, 월 또는 년에서 그 기산일에 해당하는 날의 다음날이 아니라 전날로 기간이 만료한다."
        // 5번 지문 반전, 틀린지문
        selectionVeryFirst25.contentControversal = "부(父) 사망 후 미성년인 甲 소유의 상속부동산을 관리, 처분하던 그 모(母)가 甲의 학비를 조달하기 위하여 甲 소유 부동산을 甲 명의로 처분한 경우, 그 토지를 매수한 乙이 악의이거나 과실 여부와 관계없이 乙은 토지의 소유권을 취득한다."
        
        self.questions.append(question2)
        
        //기본 문제생성, 동시이행의 항변 FO
        let question3 = Question(questionKey : "TESTCVA00518", isPublished : true, testDate : "1701", testCategory: "변시", testSubject: "민사법", questionType: QuestionType.Find, questionOX : QuestionOX.O , content : "동시이행의 항변권에 관한 설명 중 옳은 것을 모두 고른 것은?", answer : 1)
        question3.contentControversal = "동시이행의 항변권에 관한 설명 중 옳지 않은 것을 모두 고른 것은?"
        question3.contentNote = "(다툼이 있는 경우 판례에 의함)"
        
        // 1번
        _ = TestSelction(question: question3, selectNumber: 1, content: "ㄱ,ㄴ")
        // 2번
        _ = TestSelction(question: question3, selectNumber: 2, content: "ㄱ,ㄹ")
        // 3번
        _ = TestSelction(question: question3, selectNumber: 3, content: "ㄴ,ㄷ")
        // 4번
        _ = TestSelction(question: question3, selectNumber: 4, content: "ㄱ,ㄴ,ㄹ")
        // 5번
        _ = TestSelction(question: question3, selectNumber: 5, content: "ㄴ,ㄷ,ㄹ")
        
        self.questions.append(question3)
        
        //기본 문제생성, 동시이행의 항변 FC
        let question4 = Question(questionKey : "TESTCVA00011", isPublished : true, testDate : "1608", testCategory: "변모", testSubject: "민사법", questionType: QuestionType.Find, questionOX : QuestionOX.Correct , content : "태아에 관한 다음 설명 중 옳은 것(O)과 옳지 않은 것(X)을 올바르게 조합한 것은?", answer : 1)
        question4.contentNote = "(다툼이 있는 경우 판례에 의함)"
        
        // 1번
        _ = TestSelction(question: question4, selectNumber: 1, content: "ㄱ(O), ㄴ(O), ㄷ(X), ㄹ(O), ㅁ(X)")
        // 2번
        _ = TestSelction(question: question4, selectNumber: 2, content: "ㄱ(O), ㄴ(O), ㄷ(X), ㄹ(O), ㅁ(X)")
        // 3번
        _ = TestSelction(question: question4, selectNumber: 3, content: "ㄱ(X), ㄴ(O), ㄷ(O), ㄹ(X), ㅁ(X)")
        // 4번
        _ = TestSelction(question: question4, selectNumber: 4, content: "ㄱ(X), ㄴ(O), ㄷ(O), ㄹ(O), ㅁ(O)")
        // 5번
        _ = TestSelction(question: question4, selectNumber: 5, content: "ㄱ(X), ㄴ(X), ㄷ(O), ㄹ(X), ㅁ(X)")
        
        self.questions.append(question4)
    }
}