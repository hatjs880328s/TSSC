//
//  *******************************************
//  
//  SongciBll.swift
//  PoietData
//
//  Created by Noah_Shan on 2020/1/3.
//  Copyright © 2018 Inpur. All rights reserved.
//  
//  *******************************************
//

import UIKit

// MARK: 宋词bll
class SongciBll: NSObject {

    var nowpageIdx: Int = 0

    var dataSource = [GitPathModel]() {
        didSet {
            self.reloadAction?()
        }
    }

    var reloadAction: (() -> Void)?



    //===== DETAIL

    var detailDatasource = [SongciModel]() {
        didSet {
            detailReloadAction?()
        }
    }

    var detailReloadAction: (() -> Void)?

    var detailPath: String = ""

    let yycacheName: String = "TSSCYYCACHENAME"

    let pageNo: Int = 20

    // ===== TS作者列表 =====

    var tsauthorDatasource = [SongciAuthorModel]() {
        didSet {
            tsauthorReloadAction?()
        }
    }

    var tsauthorReloadAction: (() -> Void)?

    var authorFilepath: String = ""

    override init() {
        super.init()
    }
}

/// ts列表数据处理  获取数据、循环同步数据
extension SongciBll {

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

        if !item.path.contains("ci.song") {
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

/// ts详情处理 获取数据、同步数据
extension SongciBll {

    /// 同步成功则记录flag
    func progressDiskFlag() {
        let obj = YYCache(name: yycacheName)
        obj?.setObject("1" as NSString, forKey: self.detailPath)
        print("自动同步数据完毕，持久化flag完毕")
    }

    /// 获取详情信息
    func getTSDetailInfo(path: String) {
        self.detailPath = path
        TangshiUti.getSCFileDetailInfos(filePath: path) { (result) in
            self.detailDatasource = result as! [SongciModel]
            print("自动同步数据获取信息完毕 path: \(path) info count: \(self.detailDatasource.count)")
        }
    }

    /// 递归同步TS信息
    func recursiveProgressDatasource(datasource: [SongciModel], resultAction: @escaping (_ action: Bool) -> Void) {
        if datasource.count == self.detailDatasource.count {
            // 详情修改
            self.detailDatasource.forEach({
                $0.paragraphs = $0.realInfo
                $0.title = $0.rhythmic
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
            let model = SongciModelSyncModel()
            var progressModels: [SongciModel] = []
            var nonProgressModels: [SongciModel] = []
            datasource.forEach({
                if progressModels.count < pageNo {
                    progressModels.append($0)
                } else {
                    nonProgressModels.append($0)
                }
            })
            model.infos = progressModels
            guard let infos = model.toJSON() else { return }
            NormalUti.syncSC(infos: infos) { (result) in
                if (((result as? NSDictionary)?["result"] as? Bool) ?? false) {
                    self.recursiveProgressDatasource(datasource: nonProgressModels, resultAction: resultAction)
                } else {
                    resultAction(false)
                }
            }
        } else {
            // 处理当前数组所有数据 - 结束
            let model = SongciModelSyncModel()
            model.infos = datasource
            guard let infos = model.toJSON() else { return }
            NormalUti.syncSC(infos: infos) { (result) in
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

// MARK: 作者信息
extension SongciBll {
    
    /// 根据文件的sha值获取作者信息
    func getAuthorBlob(sha: String, path: String) {
        self.authorFilepath = path
        TangshiUti.getSCBlobAuthorInfos(filesha: sha) { (infos: [SongciAuthorModel?]) in
            self.tsauthorDatasource = infos as! [SongciAuthorModel]
            for eachItem in self.tsauthorDatasource {
                eachItem.id = eachItem.description.md5()
                eachItem.desc = eachItem.description
            }
        }


    }

    /// 同步成功则记录flag
    func progressAuthorDiskFlag() {
        let obj = YYCache(name: yycacheName)
        obj?.setObject("1" as NSString, forKey: self.authorFilepath)
        print("自动同步数据完毕，持久化flag完毕")
    }

    /// 递归同步TS作者信息
    func recursiveProgressAuthorDatasource(datasource: [SongciAuthorModel], resultAction: @escaping (_ action: Bool) -> Void) {
        if datasource.count <= 0 {
            progressAuthorDiskFlag()
            resultAction(true)
            return
        }
        if datasource.count >= pageNo {
            // 处理50个如果成功 递归处理后面数据
            let model = SCAuthorSyncModel()
            var progressModels: [SongciAuthorModel] = []
            var nonProgressModels: [SongciAuthorModel] = []
            datasource.forEach({
                if progressModels.count < pageNo {
                    progressModels.append($0)
                } else {
                    nonProgressModels.append($0)
                }
            })
            model.infos = progressModels
            guard let infos = model.toJSON() else { return }
            NormalUti.syncSCAuthor(infos: infos) { (result) in
                if (((result as? NSDictionary)?["result"] as? Bool) ?? false) {
                    self.recursiveProgressAuthorDatasource(datasource: nonProgressModels, resultAction: resultAction)
                } else {
                    resultAction(false)
                }
            }
        } else {
            // 处理当前数组所有数据 - 结束
            let model = SCAuthorSyncModel()
            model.infos = datasource
            guard let infos = model.toJSON() else { return }
            NormalUti.syncSCAuthor(infos: infos) { (result) in
                if (((result as? NSDictionary)?["result"] as? Bool) ?? false) {
                    self.progressAuthorDiskFlag()
                    resultAction(true)
                } else {
                    resultAction(false)
                }
            }
        }
    }
}

// MARK: delegate
extension SongciBll {

}
