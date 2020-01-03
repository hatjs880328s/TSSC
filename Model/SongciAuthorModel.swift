//
//  *******************************************
//  
//  SongciAuthorModel.swift
//  PoietData
//
//  Created by Noah_Shan on 2020/1/3.
//  Copyright © 2018 Inpur. All rights reserved.
//  
//  *******************************************
//

import UIKit
import HandyJSON

// MARK: sc作者
class SongciAuthorModel: HandyJSON {

    var description: String = ""

    var name: String = ""

    var short_description: String = ""

    var id: String = ""

    var desc: String = ""

    required init() { }
}

/// 作者同步model
class SCAuthorSyncModel: HandyJSON {
    var infos: [SongciAuthorModel] = []

    required init() { }
}
