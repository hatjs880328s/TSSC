//
//  *******************************************
//  
//  NormalConfig.swift
//  PoietData
//
//  Created by Noah_Shan on 2019/12/27.
//  Copyright © 2018 Inpur. All rights reserved.
//  
//  *******************************************
//

import UIKit

// MARK: Edit Your Own Infos
class NormalConfig: NSObject {

    /// base64处理后的加密信息
    static var bearer: String = "QmVhcmVyIGNkMDBkNzEwMTRhZDhiNjZlNGQ0Yzk2OTgyYTdlYTBhZWJlNzNkNTE="

    /// base uri
    static var baseUri: String = "https://api.github.com/repos/hatjs880328s/chinese-poetry/contents/"

    /// blob get
    static var blobUri: String = "https://api.github.com/repos/hatjs880328s/chinese-poetry/git/blobs/"

    /// tssc api - base host
    static var baseApiHost: String = "http://127.0.0.1:8081"

    /// sync tssc api
    static var syncTSSCApi: String = "\(NormalConfig.baseApiHost)/tssc/sync"

    /// sync SC api
    static var syncSCApi: String = "\(NormalConfig.baseApiHost)/sc/sync"

    /// sync tssc author api
    static var syncTSSCAuthorApi: String = "\(NormalConfig.baseApiHost)/tsscauthor/sync"

    /// sync tssc author api
    static var syncSCAuthorApi: String = "\(NormalConfig.baseApiHost)/scauthor/sync"
}
