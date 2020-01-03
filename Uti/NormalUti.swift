//
//  *******************************************
//  
//  NormalUti.swift
//  PoietData
//
//  Created by Noah_Shan on 2019/12/27.
//  Copyright © 2018 Inpur. All rights reserved.
//  
//  *******************************************
//

import UIKit
import Alamofire

// MARK: 根据path获取数据信息
class NormalUti: NSObject {

    override init() {
        super.init()
    }

    /// 根据路径异步获取文件夹、文件信息
    static func getDirOrFileInfo(path: String, resultInfo: @escaping (_ resultInfo: Any?) -> Void) {
        let url = NormalConfig.baseUri + path

        let headerInfo = [
            "Authorization": base64Decode(base64Str: NormalConfig.bearer),
            "Accept": "application/vnd.github.squirrel-girl-preview"
        ]
        
        Alamofire.request(url, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: headerInfo).responseJSON { (dataResponse) in
            resultInfo(dataResponse.result.value)
        }
    }

    /// base64 bearer info
    public static func base64Decode(base64Str: String) -> String {
        guard let base64Data = Data(base64Encoded: base64Str, options: Data.Base64DecodingOptions.init(rawValue: 0)) else { return "" }
        guard let result = String(data: base64Data, encoding: String.Encoding.utf8) else { return "" }
        return result
    }

    /// 同步TSSC信息
    static func syncTSSC(infos: [String: Any], resultInfo: @escaping (_ resultInfo: Any?) -> Void) {
        Alamofire.request(NormalConfig.syncTSSCApi, method: HTTPMethod.post, parameters: infos, encoding: JSONEncoding.default, headers: nil).responseJSON { (res) in
            resultInfo(res.result.value)
        }
    }

    /// 同步tsscauthor 信息
    static func syncTSSCAuthor(infos: [String: Any], resultInfo: @escaping (_ resultInfo: Any?) -> Void) {
        Alamofire.request(NormalConfig.syncTSSCAuthorApi, method: HTTPMethod.post, parameters: infos, encoding: JSONEncoding.default, headers: nil).responseJSON { (res) in
            resultInfo(res.result.value)
        }
    }

    /// blob get 
    static func blobGet(sha: String, resultInfo: @escaping (_ resultInfo: Any?) -> Void) {
        let url = NormalConfig.blobUri + sha

        let headerInfo = [
            "Authorization": base64Decode(base64Str: NormalConfig.bearer),
            "Accept": "application/vnd.github.squirrel-girl-preview"
        ]

        Alamofire.request(url, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: headerInfo).responseJSON { (response) in
            resultInfo(response.result.value)
        }
    }

    /// 同步SC信息
    static func syncSC(infos: [String: Any], resultInfo: @escaping (_ resultInfo: Any?) -> Void) {
        Alamofire.request(NormalConfig.syncSCApi, method: HTTPMethod.post, parameters: infos, encoding: JSONEncoding.default, headers: nil).responseJSON { (res) in
            resultInfo(res.result.value)
        }
    }
}
