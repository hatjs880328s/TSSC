//
//  *******************************************
//  
//  MainPageBll.swift
//  PoietData
//
//  Created by Noah_Shan on 2019/12/27.
//  Copyright © 2018 Inpur. All rights reserved.
//  
//  *******************************************
//

import UIKit

// MARK: Edit Your Own Infos
class MainPageBll: NSObject {

    var dataSource: [(String, String)] = [
        ("唐诗宋诗", "[处理完毕]"),
        ("宋词", "[未处理]")
    ]
    
    override init() {
        super.init()
    }
}
