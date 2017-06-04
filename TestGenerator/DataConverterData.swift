//
//  DataConverterData.swift
//  TestGenerator
//
//  Created by Master Builder on 2017. 5. 16..
//  Copyright © 2017년 MasterBuilder. All rights reserved.
//

import Foundation

struct DataConverterData {
    
    var questionContentPair : [(content : String, notContent : String?, type : QuestionType, OX : QuestionOX)] = [
        
        

        
        ("옳은 것을 모두 고른 것은?", "옳지 않은 것을 모두 고른 것은?", .Find, .O),
        ("판례의 입장과 부합하는 것을 모두 고른 것은?", "판례의 입장과 부합하지 않는 것을 모두 고른 것은?", .Find, .O),
        ("판례의 입장에 부합하는 것을 모두 고른 것은?", "판례의 입장에 부합하지 않는 것을 모두 고른 것은?", .Find, .O),
        ("판례의 태도와 부합하는 것을 모두 고른 것은?", "판례의 태도와 부합하지 않는 것을 모두 고른 것은?", .Find, .O),
        ("허용되는 것을 모두 고른 것은?", "허용되지 않는 것을 모두 고른 것은?", .Find, .O),
        ("되는 것을 모두 고른 것은?", "되지 않는 것을 모두 고른 것은?", .Find, .O),
        ("되는 경우를 모두 고른 것은?", "되지 않는 경우를 모두 고른 것은?", .Find, .O),
        ("해당하는 것을 모두 고른 것은?", "해당할 수 없는 것을 모두 고른 것은?", .Find, .O),
        ("해당하는 것을 모두 고른 것은?", "해당하지 않는 것을 모두 고른 것은?", .Find, .O),
        ("사례를 모두 모아 놓은 것은?", "사례가 아닌 것을 모두 모아 놓은 것은?", .Find, .O),
        ("인정할 수 있는 경우를 모두 고른 것은?", "인정할 수 없는 경우를 모두 고른 것은?", .Find, .O),
        ("유죄를 인정할 수 있는 것을 모두 고른 것은?", "유죄를 인정할 수 없는 것을 모두 고른 것은?", .Find, .O),
        ("적법한 것을 모두 고른 것은?", "적법하지 않은 것을 모두 고른 것은?", .Find, .O),
        ("대상이 될 수 있는 것을 모두 고른 것은?", "대상이 될 수 있는 것을 모두 고른 것은?", .Find, .O),
        ("인정되는 권리를 모두 고른 것은?", "인정되지 않는 권리를 모두 고른 것은?", .Find, .O),
        ("해당하는 자를 모두 고른 것은?", "해당하지 않는 자를 모두 고른 것은?", .Find, .O),
        ("허용되는 행위를 모두 고른 것은?", "허용되지 않는 행위를 모두 고른 것은?", .Find, .O),
        ("가능하지 않는 경우를 모두 고른 것은?", "가능한 경우를 모두 고른 것은?", .Find, .O),
               
        
        
        
        ("옳은 것(○)과 옳지 않은 것(×)을 올바르게 조합한 것은?", nil, .Find, .Correct),
        ("옳은 것(o)과 옳지 않은 것(x)을 올바르게 조합한 것은?", nil, .Find, .Correct),
        ("옳은 것(○)과 옳지 않은 것(× )을 올바르게 조합한 것은?", nil, .Find, .Correct),
        ("옳은 것(○)과 옳지 않은 것(×)을 바르게 고른 것은?", nil, .Find, .Correct),
        ("인정되는 경우(○)와 부정되는 경우(×)를 올바르게 짝지은 것은?", nil, .Find, .Correct),
        ("괄호 안에 들어갈 금액이 모두 옳게 조합된 것은?", nil, .Find, .Correct),
        ("옳고 그름의 표시(○,× )가 옳게 조합된 것은?", nil, .Find, .Correct),
        
        
        
        
        
        ("옳은 것은?", "옳지 않은 것은?", .Select, .O),
        ("판례의 입장과 부합하는 것은?", "판례의 입장과 부합하지 않는 것은?", .Select, .O),
        ("헌법재판소 또는 대법원의 판례와 합치되는 것은?", "헌법재판소 또는 대법원의 판례와 합치되지 않는 것은?", .Select, .O),
        ("취할 수 있는 법적 대응에 해당하는는 것은?", "취할 수 있는 법적 대응에 해당하지 않는 것은?", .Select, .O),
        ("물을 수 있는 것은?", "물을 수 없는 것은?", .Select, .O),
        ("형법이론상의 논점과 관련이 있는 것은?", "형법이론상의 논점과 관련이 없는 것은?", .Select, .O),
        ("타당한 항변으로 볼 수 있는 것은?", "타당한 항변으로 볼 수 없는 것은?", .Select, .O),
        ("있는 자를 모두 고른 것은?", "없는 자를 모두 고른 것은?", .Select, .O),
        ("허가를 받아야 하는 경우인 것은?", "허가를 받아야 하는 경우가 아닌 것은?", .Select, .O),
        ("인정되는 것은?", "인정되지 않는 것은?", .Select, .O),
        ("판례의 입장과 같은 것은?", "판례의 입장과 다른 것은?", .Select, .O),
        ("해당하는 것은?", "해당하지 않는 것은?", .Select, .O),
        ("형사처벌을 받는 것은?", "형사처벌을 받지 않는 것은?", .Select, .O),
        ("수임할 수 있는 사건은?", "수임할 수 없는 사건은?", .Select, .O),
        ("위반되는 경우는?", "위반되지 않는 경우는?", .Select, .O),
        ("허용되는 것은?", "허용되지 않는 것은?", .Select, .O),
        ("변호사법 위반인 것은?", "변호사법 위반이 아닌 것은?", .Select, .O),
        ("허용되는 경우인 것은?", "허용되는 경우가 아닌 것은?", .Select, .O),
        ("될 수 있는 것은?", "될 수 없는 것은?", .Select, .O),
        ("윤리에 위반되는 것은?", "윤리에 위반되지 않는 것은?", .Select, .O),
        ("｢변호사윤리장전｣에 위배되는 것은?", "｢변호사윤리장전｣에 위배되지 않는 것은?", .Select, .O),
        ("변호사윤리에 어긋나는 것은?", "변호사윤리에 어긋나지 않는 것은?", .Select, .O),
        ("형사처벌을 받을 수 있는 것은?", "형사처벌을 받을 수 없는 것은?", .Select, .O),
        ("변호사윤리에 위반되는 행위는?", "변호사윤리에 위반되지 않는 행위는?", .Select, .O),
        ("위반된 행위에 해당되는 것은?", "위반된 행위에 해당되지 않는 것은?", .Select, .O),
        ("위반되는 것은?", "위반되지 않는 것은?", .Select, .O),
        ("받는 경우인 것은?", "받는 경우가 아닌 것은?", .Select, .O),
        
        
        
        
        ("용어를 올바르게 나열한 것은?", nil, .Select, .Correct),
        ("바르게 연결된 것은?", nil, .Select, .Correct),
        ("각 얼마를 지급하여야 하는가?", nil, .Select, .Correct),
        ("만료된 날짜는 언제인가?", nil, .Select, .Correct),
        ("생략할 수 있는 절차는?", nil, .Select, .Correct),
        ("우선적으로 배당받을 금액은?", nil, .Select, .Correct),
        ("될 수 있는 것은?", nil, .Select, .Correct),
        
        
        
    ]
    
}
