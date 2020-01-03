//
//  *******************************************
//  
//  TangshiUti.swift
//  PoietData
//
//  Created by Noah_Shan on 2019/12/27.
//  Copyright © 2018 Inpur. All rights reserved.
//  
//  *******************************************
//

import UIKit
import SwiftyJSON

// MARK: 唐诗处理UTI
class TangshiUti: NSObject {

    static let pathDic = [
        "tsrootPath": "json"
    ]

    override init() {
        super.init()
    }

    /// 获取唐诗根目录信息（字典、文件）
    static func getAllDirAndFiles(path: String, resultAction: @escaping (_ result: [GitPathModel]) -> Void) {
        NormalUti.getDirOrFileInfo(path: path) { (result) in
            guard let realInfo = result as? NSArray else { return }
            var result: [GitPathModel] = []
            realInfo.forEach({
                if let realModel = GitPathModel.deserialize(from: $0 as? [String: Any]) {
                    result.append(realModel)
                }
            })
            resultAction(result)
        }
    }

    /// 获取唐诗文件详情
    static func getTSFileDetailInfos(filePath: String, resultAction: @escaping (_ result: [TangshiModel?]) -> Void) {
        NormalUti.getDirOrFileInfo(path: filePath) { (result) in
            guard let realDic = result as? NSDictionary else { resultAction([]) ; return }
            guard let model = GitPathModel.deserialize(from: realDic) else { resultAction([]) ; return }

            let content = (model.content as NSString).replacingOccurrences(of: "\n", with: "")

            let jsonStr = NormalUti.base64Decode(base64Str: content)

            let insos = [TangshiModel].deserialize(from: jsonStr)
            
            resultAction(insos ?? [])
        }
    }

    /// 获取唐诗作者信息
    static func getTSAuthorInfos(filepath: String, resultAction: @escaping (_ result: [TangshiAuthorModel?]) -> Void) {
        NormalUti.getDirOrFileInfo(path: filepath) { (result) in
            guard let realDic = result as? NSDictionary else { return }
            guard let model = GitPathModel.deserialize(from: realDic) else { return }

            let content = (model.content as NSString).replacingOccurrences(of: "\n", with: "")

            let jsonStr = NormalUti.base64Decode(base64Str: content)

            let insos = [TangshiAuthorModel].deserialize(from: jsonStr)
            resultAction(insos ?? [])
        }
    }

    /// blob author
    static func getBlobAuthorInfos(filesha: String, resultAction: @escaping (_ result: [TangshiAuthorModel?]) -> Void) {
        NormalUti.blobGet(sha: filesha) { (result) in
            guard let readDic = result as? NSDictionary else { return }

            guard let model = GitBLOBModel.deserialize(from: readDic) else { return }

            let content = (model.content as NSString).replacingOccurrences(of: "\n", with: "")

            let jsonStr = NormalUti.base64Decode(base64Str: content)

            let infos = [TangshiAuthorModel].deserialize(from: jsonStr)

            resultAction(infos ?? [])
        }
    }

}
