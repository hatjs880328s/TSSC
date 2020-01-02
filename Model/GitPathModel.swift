//
//  *******************************************
//  
//  GitPathModel.swift
//  PoietData
//
//  Created by Noah_Shan on 2019/12/27.
//  Copyright © 2018 Inpur. All rights reserved.
//  
//  *******************************************
//

import UIKit
import HandyJSON

// MARK: git文件的model
class GitPathModel: NSObject, HandyJSON {

    var name: String = ""

    var path: String = ""

    var sha: String = ""

    var size: String = ""

    var url: String = ""

    var html_url: String = ""

    var git_url: String = ""

    var download_url: String = ""

    var type: String = ""

    var content: String = ""

    /// 后期计算所得 - 是否已经异步操作
    var calPathFlag: Bool {
        let obj = YYCache(name: "TSSCYYCACHENAME")
        if obj?.object(forKey: self.path) == nil { return false }
        return true
    }

    required override init() {
        super.init()
    }

}
