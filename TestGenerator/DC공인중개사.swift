//
//  DC공인중개사.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 1..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

//class DC공인중개사: DataConverter {
    
//    convenience init?(_ testDatabase : TestDatabase) {

        
//        self.init(testDatabase: testDatabase,
//                  answerFilename: "공인중개사-정답.json",
//                  questionFilename: "공인중개사-문제.txt"
//        )
//        
//       
//        
//        let resultTuple = extractTestAndAnswerJson()
//        setTestAndAnswerTemplet(resultTuple)
//        
//        
//        
//        let testSeperator = "=(공인중개사 국가자격시험)=(.+)=(\\d+)회="
//        
//        
//        parseQustionsFromTextFile(testSeperator: testSeperator
//            , questionSeperator: "문\\s{0,}\\d+\\."
//            , selectionSeperator: "(①|②|③|④|⑤|⑥|⑦|⑧|⑨|⑩)(.+\\n{0,}){1,9}"
//            , numberOfSelections: 6
//        )
//        
//        _ = saveTests()
//        
//        log = log + "Data Converter Log 종료 \(Date().HHmmSS)"
//        print(log)
//        
//        
//    }
//}

//파싱의 미스테리 2017. 5. 10. (+)

//문29. 2년 전 연초(1월 1일)에 받은 주택담보대출의 대환
//(refinancing)을 고려하고 있는 A가 대출 후 2년차
//말에 대환을 통해 얻을 수 있는 이익의 현재가치는?
//(단, 주어진 조건에 한함)
//○ 기존대출 조건
//- 대출금액: 1억원
//- 이자율: 연 4%
//- 만기 10년, 원금 만기일시상환조건(매년 말 연
//단위 이자 지급)
//- 조기상환수수료: 대출잔액의 1%
//○ 신규대출 조건
//- 대출금액: 기존대출의 잔액
//- 이자율: 연 3%
//- 만기 8년, 원금 만기일시상환조건(매년 말 연
//단위 이자 지급)
//- 취급수수료: 대출금액의 1%
//○ 8년간 연금의 현재가치계수(3% 연복리): 7
//① 3백만원 ② 4백만원 ③ 5백만원
//④ 6백만원 ⑤ 7백만원
//문30. 다음 설명에 모두 해당하는 부동산관리 방식은?
//○ 소유자의 의사능력 및 지휘통제력이 발휘된다.
//○ 업무의 기밀유지에 유리하다.
//○ 업무행위의 안일화를 초래하기 쉽다.
//○ 전문성이 낮은 경향이 있다.
//① 외주관리 ② 혼합관리 ③ 신탁관리
//④ 위탁관리 ⑤ 직접관리
//
//문31. 부동산개발에 관한 설명으로 틀린 것은?
//① 부동산개발업의 관리 및 육성에 관한 법령상 부동산개
//발업이란 타인에게 공급할 목적으로 부동산개발을 수행
//하는 업을 말한다.
//② 법률적 위험을 줄이는 하나의 방법은 이용계획이 확정
//된 토지를 구입하는 것이다.
//③ 시장성분석 단계에서는 향후 개발될 부동산이 현재나
//미래의 시장상황에서 매매되거나 임대될 수 있는지에
//대한 경쟁력을 분석한다.
//④ 토지(개발)신탁방식은 신탁회사가 토지소유권을 이전받아 토지를 개발한 후 분양하거나 임대하여 그 수익을 신탁자에게 돌려주는 것이다.
//⑤ BTO(build-transfer-operate)방식은 민간이 개발한 시설의 소유권을 준공과 동시에 공공에 귀속시키고 민간은 시설관리운영권을 가지며, 공공은 그 시설을 임차하여 사용하는 민간투자 사업방식이다.
//
//
//
//
//
//문41.
//(①|②|③|④|⑤|⑥|⑦|⑧|⑨|⑩)(.+\n{0,}){1,9} 을 이용해서는완벽하게 파싱할 수 없다. 어떤방법을 찾아야 하나?


