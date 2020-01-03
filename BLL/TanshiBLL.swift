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

    var nowpageIdx: Int = 0

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

}

/// ts列表数据处理  获取数据、循环同步数据
extension TanshiBLL {

    /// 根据path获取数据（列表）
    func getData(path: String) {
        TangshiUti.getAllDirAndFiles(path: path) { (models) in
            self.dataSource = models
        }
    }

    /// 自动遍历同步TS信息方法
    func autoSYNCTSInfos(action: (_ path: String) -> Void) {

        print("TS 数据开始自动同步...")

        print("now page is : \(self.nowpageIdx)")

        if self.dataSource.count < self.nowpageIdx + 1 { return }

        let item = self.dataSource[self.nowpageIdx]

        if !item.path.contains("poet") {
            self.nowpageIdx += 1
            self.autoSYNCTSInfos(action: action)
            return
        }

        if item.calPathFlag {
            self.nowpageIdx += 1
            self.autoSYNCTSInfos(action: action)
            return
        }

        action(item.path)

        self.nowpageIdx += 1
    }
}

/// ts作者页面数据获取
extension TanshiBLL {

    /// 获取作者信息
    @available(*, deprecated, renamed: "getTSAuthorInfo(path:)", message: "Use getAuthorBlob overload instead.")
    func getTSAuthorInfo(path: String) {
        TangshiUti.getTSAuthorInfos(filepath: path) { (result) in
            self.tsauthorDatasource = result as! [TangshiAuthorModel]
        }
    }

    /// 根据文件的sha值获取作者信息
    func getAuthorBlob(sha: String) {
        TangshiUti.getBlobAuthorInfos(filesha: sha) { (infos: [TangshiAuthorModel?]) in
            self.tsauthorDatasource = infos as! [TangshiAuthorModel]
        }
    }

    /// 作者信息同步
    func syncAuthor() {

    }

}

/// ts详情处理 获取数据、同步数据
extension TanshiBLL {

    /// 同步成功则记录flag
    func progressDiskFlag() {
        let obj = YYCache(name: yycacheName)
        obj?.setObject("1" as NSString, forKey: self.detailPath)
        print("自动同步数据完毕，持久化flag完毕")
    }

    /// 获取详情信息
    func getTSDetailInfo(path: String) {
        self.detailPath = path
        TangshiUti.getTSFileDetailInfos(filePath: path) { (result) in
            self.detailDatasource = result as! [TangshiModel]
            print("自动同步数据获取信息完毕 path: \(path) info count: \(self.detailDatasource.count)")
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
        if datasource.count <= 0 {
            if self.detailDatasource.count != 0 {
                self.progressDiskFlag()
            }
            resultAction(true)
            return
        }
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
                    self.progressDiskFlag()
                    resultAction(true)
                } else {
                    resultAction(false)
                }
            }
        }
    }
}
