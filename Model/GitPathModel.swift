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

    required override init() {
        super.init()
    }

}
