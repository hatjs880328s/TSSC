//
//  *******************************************
//  
//  TanshiBLL.swift
//  PoietData
//
//  Created by Noah_Shan on 2019/12/27.
//  Copyright © 2018 Inpur. All rights reserved.
//  
//  *******************************************
//

import UIKit

// MARK: 唐诗bll
class TanshiBLL: NSObject {

    // ===== 列表 =====

    var dataSource = [GitPathModel]() {
        didSet {
            self.reloadAction?()
        }
    }

    var reloadAction: (() -> Void)?


    // ===== TS详情列表 =====

    var detailDatasource = [TangshiModel]() {
        didSet {
            detailReloadAction?()
        }
    }

    var detailReloadAction: (() -> Void)?

    var detailPath: String = ""

    let yycacheName: String = "TSSCYYCACHENAME"

    let pageNo: Int = 20

    // ===== TS作者列表 =====

    var tsauthorDatasource = [TangshiAuthorModel]() {
        didSet {
            tsauthorReloadAction?()
        }
    }

    var tsauthorReloadAction: (() -> Void)?

    override init() {
        super.init()
    }

    /// 根据path获取数据（列表）
    func getData(path: String) {
        TangshiUti.getAllDirAndFiles(path: path) { (models) in
            self.dataSource = models
        }
    }

    /// 获取作者信息
    func getTSAuthorInfo(path: String) {
        TangshiUti.getTSAuthorInfos(filepath: path) { (result) in
            self.tsauthorDatasource = result as! [TangshiAuthorModel]
        }
    }
}

/// ts详情处理 获取数据、同步数据
extension TanshiBLL {

    /// 同步成功则记录flag
    func progressDiskFlag() {
        let obj = YYCache(name: yycacheName)
        obj?.setObject("1" as NSString, forKey: self.detailPath)
    }

    /// 获取详情信息
    func getTSDetailInfo(path: String) {
        self.detailPath = path
        TangshiUti.getTSFileDetailInfos(filePath: path) { (result) in
            self.detailDatasource = result as! [TangshiModel]
        }
    }

    /// 递归同步TS信息
    func recursiveProgressDatasource(datasource: [TangshiModel], resultAction: @escaping (_ action: Bool) -> Void) {
        if datasource.count == self.detailDatasource.count {
            // 详情修改
            self.detailDatasource.forEach({
                $0.paragraphs = $0.realInfo
            })
        }
        if datasource.count <= 0 { resultAction(true) ; progressDiskFlag() ; return }
        if datasource.count >= pageNo {
            // 处理50个如果成功 递归处理后面数据
            let model = TangshiSyncModel()
            var progressModels: [TangshiModel] = []
            var nonProgressModels: [TangshiModel] = []
            datasource.forEach({
                if progressModels.count < pageNo {
                    progressModels.append($0)
                } else {
                    nonProgressModels.append($0)
                }
            })
            model.infos = progressModels
            guard let infos = model.toJSON() else { return }
            NormalUti.syncTSSC(infos: infos) { (result) in
                if (((result as? NSDictionary)?["result"] as? Bool) ?? false) {
                    self.recursiveProgressDatasource(datasource: nonProgressModels, resultAction: resultAction)
                } else {
                    resultAction(false)
                }
            }
        } else {
            // 处理当前数组所有数据 - 结束
            let model = TangshiSyncModel()
            model.infos = datasource
            guard let infos = model.toJSON() else { return }
            NormalUti.syncTSSC(infos: infos) { (result) in
                if (((result as? NSDictionary)?["result"] as? Bool) ?? false) {
                    resultAction(true)
                    self.progressDiskFlag()
                } else {
                    resultAction(false)
                }
            }
        }
    }
}
