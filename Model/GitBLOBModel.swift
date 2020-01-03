//
//  *******************************************
//  
//  GitBLOBModel.swift
//  PoietData
//
//  Created by Noah_Shan on 2020/1/3.
//  Copyright © 2018 Inpur. All rights reserved.
//  
//  *******************************************
//

import UIKit
import HandyJSON

// MARK: git blob info
class GitBLOBModel: NSObject, HandyJSON {

    var sha: String = ""

    var node_id: String = ""

    var size: String = ""

    var url: String = ""

    /// 需要去掉 \n 并且使用了 base64编码了
    var content: String = ""

    var encoding: String = ""

    required override init() {
        super.init()
    }
}
