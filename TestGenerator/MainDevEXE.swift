//
//  mainEXE.swift
//  LawD Console System
//
//  Created by Masterbuilder on 2023/09/19.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import Foundation

class MainDevEXE {
    init(toExecute: Bool) {
        if toExecute {
            /// 아래에서 콘솔에서 실행할 액션를 정의함.
            ///
            
            //            print(QuestionData.saveQueD1().creationDate.myDateStirng)
            let tempDataFilePath = "/Users/lee/Library/CloudStorage/Dropbox/DropDocument/ LawDatabase/ Temp"
            
            let queD1 = QuestionData.loadLatestQueD1()
            print(queD1?.id)
            queD1?.saveJson(url: URL(filePath: tempDataFilePath))
//            print(QuestionData.saveQueD1().creationDate.myDateStirng)
        }
    }
}
