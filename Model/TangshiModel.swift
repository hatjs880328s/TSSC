//
//  *******************************************
//  
//  TangshiModel.swift
//  PoietData
//
//  Created by Noah_Shan on 2019/12/27.
//  Copyright © 2018 Inpur. All rights reserved.
//  
//  *******************************************
//

import UIKit
import HandyJSON

// MARK: 唐诗model
class TangshiModel: HandyJSON {

    var author: String = ""

    var paragraphs: String = ""

    var title: String = ""

    var id: String = ""

    var realInfo: String {
        let result = (self.paragraphs as NSString)
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "\"", with: "")
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: "\r", with: "")
        let realInfo = self.changeUnicode2Char(input: result)
        return (realInfo as NSString).replacingOccurrences(of: "。", with: "。\n")
    }

    required init() { }

    func changeUnicode2Char(input: String) -> String {
        return LFCGzipUtility().replaceUnicode(input)
    }
}

/// 为了同步TS信息所使用的model
class TangshiSyncModel: HandyJSON {

    var infos: [TangshiModel] = []
    
    required init() { }
}
