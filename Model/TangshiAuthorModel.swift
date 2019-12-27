//
//  *******************************************
//  
//  TangshiAuthorModel.swift
//  PoietData
//
//  Created by Noah_Shan on 2019/12/27.
//  Copyright © 2018 Inpur. All rights reserved.
//  
//  *******************************************
//

import UIKit
import HandyJSON

// MARK: 唐诗作者model
class TangshiAuthorModel: NSObject, HandyJSON {

    var desc: String = ""

    var name: String = ""

    var id: String = ""
    
    required override init() {
        super.init()
    }
}
