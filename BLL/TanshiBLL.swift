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

    func getData(path: String) {
        TangshiUti.getAllDirAndFiles(path: path) { (models) in
            self.dataSource = models
        }
    }

    func getTSDetailInfo(path: String) {
        TangshiUti.getTSFileDetailInfos(filePath: path) { (result) in
            self.detailDatasource = result as! [TangshiModel]
        }
    }

    /// tssc数据同步
    func syncDetailDatasource() {
        if self.detailDatasource.count == 0 { return }
        
    }

    func getTSAuthorInfo(path: String) {
        TangshiUti.getTSAuthorInfos(filepath: path) { (result) in
            self.tsauthorDatasource = result as! [TangshiAuthorModel]
        }
    }
}
