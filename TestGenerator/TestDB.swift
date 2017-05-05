//
//  TestDB
//  TestGenerator
//
//  Created by Master Builder on 2017. 3. 22..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation
class TestDB {
    var name = "default"
    var tests : [Test] = []
    
    init() {
        //기본 문제생성, 법인 아닌 사단 SO
        let test변호사시험민사법샘플 = Test(testDB: self, isPublished: true, category: "변호사시험", subject: "민사법", number: 1, numHelper: 2017)
        test변호사시험민사법샘플.description = "데이터 검사목적으로 Database 객체에서 생성한 변호사시험 민사법 시험문제들의 집합"
        
        let test공인중개사1차샘플2 = Test(testDB: self, isPublished: true, category: "공인중개사", subject: "1차", number: 25, numHelper: nil)
        test공인중개사1차샘플2.description = "데이터 검사목적으로 Database 객체에서 생성한 공인중개사 시험문제들의 집합"
        
        let question0 = Question(test : test변호사시험민사법샘플, number : 1, questionType: QuestionType.Select, questionOX : QuestionOX.X , content : "법인 아닌 사단에 관한 설명 중 옳지 않은 것은?", answer : 5)
        question0.contentControversal = "법인 아닌 사단에 관한 설명 중 옳은 것은?"
        question0.contentNote = "(다툼이 있는 경우 판례에 의함)"
        question0.description = "변시 민사법 32번 문제 SX, 샘플1"
        
        // 1번, 옳은 지문
        let selectionVeryFirst1 = Selection(question: question0, selectNumber: 1, content: "법인 아닌 사단의 사원이 존재하지 않게 된 경우에도 그 법인 아닌 사단은 청산사무가 완료될 때까지 청산의 목적범위 내에서 권리의무의 주체가 된다.")
        // 2번, 옳은 지문
        let selectionVeryFirst2 = Selection(question: question0, selectNumber: 2, content: "법인 아닌 사단의 대표자가 정관에 규정된 대표권 제한에 위반하여 법률행위를 한 경우, 그 상대방이 대표권 제한 및 그 위반 사실을 알았거나 과실로 인해 알지 못한 때에는 그 법률행위는 무효이다.")
        // 3번, 옳은 지문
        let selectionVeryFirst3 = Selection(question: question0, selectNumber: 3, content: "법인 아닌 사단의 정관에 특별한 규정이 없는 경우 법인 아닌 사단의 대표자가 타인 간의 금전채무를 보증하기 위해 사원총회 결의를 거칠 필요는 없다.")
        // 4번, 옳은 지문
        let selectionVeryFirst4 = Selection(question: question0, selectNumber: 4, content: "법인 아닌 사단의 총회 소집권자가 총회 소집을 철회하는 경우 반드시 총회 소집과 동일한 방식으로 통지해야 할 필요는 없고, 총회 구성원들에게 소집 철회의 결정이 있었음이 알려질 수 있는 적절한 조치를 취하는 것으로 충분하다.")
        // 5번, 틀린 지문, 정답
        let selectionVeryFirst5 = Selection(question: question0, selectNumber: 5, content: "법인 아닌 사단의 채권자가 채권자대위권에 기하여 법인 아닌 사단의 총유재산에 대한 권리를 대위행사하는 경우, 사원총회의 결의 등 법인 아닌 사단의 내부적 의사결정 절차를 거쳐야 한다.")
        
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
        
        //기본 문제생성, 매도인의 담보책임 SX
        let question1 = Question(test : test변호사시험민사법샘플, number : 2, questionType: QuestionType.Select, questionOX : QuestionOX.O , content : "매도인의 담보책임에 관한 설명 중 옳은 것은?", answer : 5)
        question1.contentControversal = "매도인의 담보책임에 관한 설명 중 옳지 않은 것은?"
        question1.contentNote = "(다툼이 있는 경우 판례에 의함)"
        question1.description = "변시 민사법 32번 문제 SX, 샘플1"
    
        // 1번, 옳은 지문
        let selectionVeryFirst11 = Selection(question: question1, selectNumber: 1, content: "甲은 자기 소유 17필지의 토지에 대하여 일괄하여 매매대금을 정하고 乙에게 매도하였으나 그 중 2필지가 타인 소유로 밝혀진 경우 매도인 甲이 그 2필지만에 대하여 매매계약을 해제할 수 있다.")
        // 2번, 옳은 지문
        let selectionVeryFirst12 = Selection(question: question1, selectNumber: 2, content: "매매목적물의 하자로 인하여 확대손해가 발생하였다는 이유로 매도인에게 그 확대손해에 대한 배상책임을 지우기 위하여는 채무의 내용으로 된 하자 없는 목적물을 인도하지 못한 의무위반사실 외에 그러한 의무위반에 대한 매도인의 귀책사유는 요구되지 않는다.")
        // 3번, 옳은 지문
        let selectionVeryFirst13 = Selection(question: question1, selectNumber: 3, content: "매매목적물의 하자가 경미하여 수선 등의 방법으로도 계약의 목적을 달성하는 데 별다른 지장이 없고, 매도인에게 하자 없는 물건의 급부의무를 지우면 다른 구제방법에 비하여 매도인에게 현저한 불이익이 발생되는 경우라도 공평의 원칙상 매수인의 완전물급부청구권의 행사를 제한할 수 없다.")
        // 4번, 옳은 지문
        let selectionVeryFirst14 = Selection(question: question1, selectNumber: 4, content: "매매의 목적이 된 권리가 타인에게 속하여 매도인이 그 권리를 취득하여 매수인에게 이전할 수 없게 된 경우, 그 권리가 타인에게 속함을 알지 못한 매수인이 매도인에게 배상을 청구할 수 있는 손해에는 매수인이 얻을 수 있었던 이익의 상실은 포함되지 않는다.")
        // 5번, 틀린 지문, 정답
        let selectionVeryFirst15 = Selection(question: question1, selectNumber: 5, content: "평형별 세대당 건물 및 공유대지가 일정한 면적을 가지고 있다는 데 주안을 두고 대금을 그 면적을 기준으로 정한 아파트 분양계약에서 분양자가 공유대지 면적의 일부를 이전할 수 없게 되었고, 그 일부 이행불능이 분양계약 체결 당시 존재한 사유에 의한 경우, 수분양자는 분양자에게 부족한 면적비율에 따라 대금감액을 청구할 수 있다.")
        
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
        
        
        //기본 문제생성, 계약 SD
        let question2 = Question(test : test변호사시험민사법샘플, number : 3, questionType: QuestionType.Select, questionOX : QuestionOX.Unknown , content : "다음 설명들에 대하여 옳은 것과 옳지 않은 것을 표시할 경우, 다른 설명과 그 결과가 다른 하나는?", answer : 3)
        
        // 1번, 옳은 지문
        let selectionVeryFirst21 = Selection(question: question2, selectNumber: 1, content: "채권자가 자신을 위하여 저당권이 설정된 물상보증인 소유의 토지에 대하여 채무자의 채무불이행을 이유로 임의경매를 신청한 경우에는 법원의 경매개시결정이 난 때에 소멸시효의 진행이 중단된다.")
        // 2번, 옳은 지문
        let selectionVeryFirst22 = Selection(question: question2, selectNumber: 2, content: "갑의 아들인 을이 갑의 인장을 위조하여 갑 소유 토지의 소유권을 A에게 이전하고, A가 이를 다시 B에게 이전한 경우, 을의 무권대리행위에 대한 추인은 무권대리인과 거래한 A에 대해서만 할 수 있고, 무권대리인에 대해서는 할 수 없다.")
        // 3번, 옳은 지문
        let selectionVeryFirst23 = Selection(question: question2, selectNumber: 3, content: "약관을해석할 때에는 계약당사자의 개별적, 주관적인 사정이나 계약 체결에 이른 사정을 고려할 필요 없이 객관적, 획일적으로 해석하여야 하는 것이 원칙이다.")
        // 4번, 옳은 지문
        let selectionVeryFirst24 = Selection(question: question2, selectNumber: 4, content: "기간을 주, 월 또는 년의 처음으로부터 기산하지 아니하는 때에는 최후의 주, 월 또는 년에서 그 기산일에 해당하는 날의 다음날로 기간이 만료한다.")
        // 5번, 틀린 지문, 정답
        let selectionVeryFirst25 = Selection(question: question2, selectNumber: 5, content: "부(父) 사망 후 미성년인 甲 소유의 상속부동산을 관리, 처분하던 그 모(母)가 甲의 학비를 조달하기 위하여 甲 소유 부동산을 甲 명의로 처분한 경우, 그 토지를 매수한 乙이 악의이거나 과실 있는 때에는 乙은 토지의 소유권을 취득하지 못한다.")
        
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
        
        //기본 문제생성, 동시이행의 항변 FO
        let question3 = Question(test : test변호사시험민사법샘플, number : 4, questionType: QuestionType.Find, questionOX : QuestionOX.O , content : "동시이행의 항변권에 관한 설명 중 옳은 것을 모두 고른 것은?", answer : 1)
        question3.contentControversal = "동시이행의 항변권에 관한 설명 중 옳지 않은 것을 모두 고른 것은?"
        question3.contentNote = "(다툼이 있는 경우 판례에 의함)"
        
        // 1번, 정답
        _ = Selection(question: question3, selectNumber: 1, content: "ㄱ,ㄴ")
        // 2번
        _ = Selection(question: question3, selectNumber: 2, content: "ㄱ,ㄹ")
        // 3번
        _ = Selection(question: question3, selectNumber: 3, content: "ㄴ,ㄷ")
        // 4번
        _ = Selection(question: question3, selectNumber: 4, content: "ㄱ,ㄴ,ㄹ")
        // 5번
        _ = Selection(question: question3, selectNumber: 5, content: "ㄴ,ㄷ,ㄹ")
        
        
        // ㄱ, 옳은 지문
        let selectionVeryFirst31 = List(question: question3, content: "부동산매수인이 매매계약을 체결하면서 매매목적물에 관한 근저당권의 피담보채무를 인수하는 한편 그 채무액을 매매대금에서 공제하기로 하는 이행인수계약이 함께 이루어진 경우, 매수인의 인수채무 불이행으로 인한 손해배상채무와 매도인의 소유권이전등기의무는 동시이행의 관계에 있다.", selectString : "ㄱ")
        // ㄴ, 옳은 지문
        let selectionVeryFirst32 = List(question: question3, content: "쌍무계약의 당사자 일방이 먼저 한 번 현실의 제공을 하고 상대방을 수령지체에 빠지게 하였다 하더라도 그 이행의 제공이 계속되지 않는 경우 상대방이 가지는 동시이행의 항변권이 소멸하는 것은 아니다.", selectString : "ㄴ")
        // ㄷ, 틀린 지문
        let selectionVeryFirst33 = List(question: question3, content: "원고가 단순이행청구를 함에 대하여 피고가 동시이행의 항변권을 행사하지 않더라도 법원은 직권으로 상환이행판결을 할 수 있다.", selectString : "ㄷ")
        // ㄹ, 틀린 지문
        let selectionVeryFirst34 = List(question: question3, content: "\"피고는 원고로부터 5,000만 원을 지급받음과 동시에 A토지를 인도하라.\"라는 판결을 받은 원고는 반대의무 이행 또는 이행의 제공을 하였다는 것을 증명하여야만 집행을 개시할 수 있다.", selectString : "ㄹ")
        
        // ㄱ 지문 반전, 틀린지문
        selectionVeryFirst31.contentControversal = "부동산매수인이 매매계약을 체결하면서 매매목적물에 관한 근저당권의 피담보채무를 인수하는 한편 그 채무액을 매매대금에서 공제하기로 하는 이행인수계약이 함께 이루어진 경우, 매수인의 인수채무 불이행으로 인한 손해배상채무는 매도인의 소유권이전등기의무와 동시이행의 관계가 아니다."
        // ㄴ 지문 반전, 틀린지문
        selectionVeryFirst32.contentControversal = "쌍무계약의 당사자 일방이 먼저 한 번 현실의 제공을 하고 상대방을 수령지체에 빠지게 하였다면 상대방이 가지는 동시이행의 항변권이 소멸하는 것은 위해 그 이행의 제공이 계속될 필요는 없다."
        // ㄷ 지문 반전, 옳은지문
        selectionVeryFirst33.contentControversal = "원고가 단순이행청구를 함에 대하여 피고가 동시이행의 항변권을 행사하지 않는다면 법원은 직권으로 상환이행판결을 할 수 없다."
        // ㄹ 지문 반전, 옳은지문
        selectionVeryFirst34.contentControversal = "\"피고는 원고로부터 5,000만 원을 지급받음과 동시에 A토지를 인도하라.\"라는 판결을 받은 원고는 집행을 개시할 때 반대의무 이행 또는 이행의 제공을 하였다는 것의 증명은 필요하지 않다."
        
        //기본 문제생성, 동시이행의 항변 FC
        let question4 = Question(test : test변호사시험민사법샘플, number : 5, questionType: QuestionType.Select, questionOX : QuestionOX.Unknown , content : "태아에 관한 다음 설명 중 옳은 것(O)과 옳지 않은 것(X)을 올바르게 조합한 것은?", answer : 1)
        question4.contentNote = "(다툼이 있는 경우 판례에 의함)"
        
        // 1번
        _ = Selection(question: question4, selectNumber: 1, content: "ㄱ(O), ㄴ(O), ㄷ(X), ㄹ(O), ㅁ(X)")
        // 2번
        _ = Selection(question: question4, selectNumber: 2, content: "ㄱ(O), ㄴ(O), ㄷ(X), ㄹ(O), ㅁ(X)")
        // 3번
        _ = Selection(question: question4, selectNumber: 3, content: "ㄱ(X), ㄴ(O), ㄷ(O), ㄹ(X), ㅁ(X)")
        // 4번
        _ = Selection(question: question4, selectNumber: 4, content: "ㄱ(X), ㄴ(O), ㄷ(O), ㄹ(O), ㅁ(O)")
        // 5번
        _ = Selection(question: question4, selectNumber: 5, content: "ㄱ(X), ㄴ(X), ㄷ(O), ㄹ(X), ㅁ(X)")
        
        //기본 문제생성, 매도인의 담보책임 SX
        let question5 = Question(test : test변호사시험민사법샘플, number : 6, questionType: QuestionType.Select, questionOX : QuestionOX.Unknown , content : "甲은 어느 날 乙로부터 책 한 권과 함께 \"이 책이 마음에 드시면 아래 계좌에 대금을 납부해주십시오\"라는 서면을 받았다. 甲은 그 책을 읽다가 흥미를 느껴서 밑줄까지 그어가며 읽었고, 다 읽은 후에는 丙에게 \"참 좋은 책이니 너도 한 번 읽어봐라\"라는 편지와 함께 그 책을 보내주었다. 이 경우 甲과 乙 사이의 법률관계를 설명하는 방법으로 가장 적당한 것은?", answer : 4)
        
        // 1번, 옳은 지문
        _ = Selection(question: question5, selectNumber: 1, content: "청약의 유인(책의 송부)을 통한 청약(甲)과 승낙(乙)")
        _ = Selection(question: question5, selectNumber: 2, content: "사실적 계약관계론")
        _ = Selection(question: question5, selectNumber: 3, content: "체약강제")
        _ = Selection(question: question5, selectNumber: 4, content: "의사실현")
        _ = Selection(question: question5, selectNumber: 5, content: "교차청약")
        
        //기본 문제생성, 동시이행의 항변 FO
        let questionFX = Question(test : test변호사시험민사법샘플, number : 7, questionType: QuestionType.Find, questionOX : QuestionOX.X , content : "동시이행의 항변권에 대한 판례의 태도에 부합하지 않는 설명을 모두 고른 것은?", answer : 2)
        questionFX.contentControversal = "동시이행의 항변권에 대한 판례의 태도에 부합하는 설명을 모두 고른 것은?"
        
        _ = Selection(question: questionFX, selectNumber: 1, content: "ㄱ, ㄴ, ㄷ")
        _ = Selection(question: questionFX, selectNumber: 2, content: "ㄴ, ㄷ, ㄹ")
        _ = Selection(question: questionFX, selectNumber: 3, content: "ㄷ, ㄹ, ㅁ")
        _ = Selection(question: questionFX, selectNumber: 4, content: "ㄱ, ㄹ, ㅁ")
        _ = Selection(question: questionFX, selectNumber: 5, content: "ㄴ, ㄷ, ㅁ")
        
        
        let selectionVeryFirstFX1 = List(question: questionFX, content: "동시이행관계에 있는 채무에 관하여 지체책임이 발생하지 아니하는 효과는 항변권의 행사를 필요로 하지 아니한다.", selectString : "ㄱ")
        let selectionVeryFirstFX2 = List(question: questionFX, content: "다른 사정이 없으면 매매대금채무와 재산권이전의무는 동시이행의 관계에 있으므로 어느 일방의 채무에 관한 이행의 제공이 있기 전에는 소멸시효가 진행되지 않는다.", selectString : "ㄴ")
        let selectionVeryFirstFX3 = List(question: questionFX, content: "임대차 종료 시 임차인의 임차보증금반환채권은 임차건물에 관해 생긴 것이 아니므로 그 임차건물의 반환과 동시이행의 관계에 있지 아니하다.", selectString : "ㄷ")
        let selectionVeryFirstFX4 = List(question: questionFX, content: "상대방의 적법한 이행제공을 수령하지 아니하여 수령지체에 빠진 쌍무계약의 일방 당사자는 동시이행의 항변권을 더 이상 원용할 수 없다.", selectString : "ㄹ")
        let selectionVeryFirstFX5 = List(question: questionFX, content: "매도인의 소유권이전등기의무가 이행불능임을 이유로 매매계약을 해제하기 위해서 매수인은 그것과 동시이행관계에 있는 잔대금지급의무의 이행제공을 할 필요가 없다.", selectString : "ㅁ")
        
        selectionVeryFirstFX1.contentControversal = "동시이행관계에 있는 채무에 관하여 지체책임이 발생하지 아니하는 효과는 항변권의 행사를 필요로 한다."
        selectionVeryFirstFX2.contentControversal = "다른 사정이 없으면 매매대금 청구권은 그 지급기일 이후 시효의 진행에 걸리며 소유권이전등기청구권은 채권적 청구권이므로 10년의 소멸시효에 걸린다."
        selectionVeryFirstFX3.contentControversal = "임차인의 임차목적물 명도의무와 임대인의 보증금 반환의무는 동시이행의 관계에 있다."
        selectionVeryFirstFX4.contentControversal = "쌍무계약의 당사자 일방이 먼저 한번 현시의 제공을 하고 상대방을 수령지체에 빠지게 하였다 하더라도 그 이행의 제공이 계속되지 않는 경우는 과거에 이행의 제공이 있었다는 사실만으로 상대방이 가지는 동시이행의 항변권이 소멸하지 않는다."
        selectionVeryFirstFX5.contentControversal = "매도인의 소유권이전등기의무가 이행불능임을 이유로 매매계약을 해제하기 위해서 매수인은 그것과 동시이행관계에 있는 잔대금지급의무의 이행제공을 할 필요가 있다."
        
        for que in test변호사시험민사법샘플.questions {
            _ = que.findAnswer()
        }
    }
    
    
    func createJsonObject() -> String? {
        
        //json 형식의 배열
        var questions = [[String:Any]]()
        
        //db에 있는 질문들을 questions 배열에 저장
        // 이를 db에 있는 시험들로 변경해야 함 !!!!중요 2017. 5. 5. (+)
        //만약 데이터 처리에 오류가 잇으면 nil을 반환
        for que in self.tests[0].questions {
            guard let queJsonObject = que.createJsonDataTypeStructure() else {
                return nil
            }
            questions.append(queJsonObject)
        }
        
        // questions라는 json data 배열을 담은 json object를 생성
        // 여기에 questions에 관한 정보들을 다양하게 담을 수 잇을 것임
        let data : Data
        do {
            data = try JSONSerialization.data(
                withJSONObject: ["questions":questions],
                options: .prettyPrinted
            )
        } catch  {
            return nil
        }
        
        //json data형식의 문자열을 반환
        return String(data: data, encoding: .utf8)
    }
}
