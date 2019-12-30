//
//  *******************************************
//  
//  TangshiDetailViewController.swift
//  PoietData
//
//  Created by Noah_Shan on 2019/12/27.
//  Copyright © 2018 Inpur. All rights reserved.
//  
//  *******************************************
//


import UIKit

/// 唐诗文件详情
class TangshiDetailViewController: UIViewController {

    var filePath: String = ""

    let bll = TanshiBLL()
    
    @IBOutlet weak var tab: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TS详情"

        self.bll.detailReloadAction = { [weak self] in
            MBProgressHUD.hide(for: self?.view ?? UIView(), animated: true)
            self?.tab.reloadData()
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        bll.getTSDetailInfo(path: self.filePath)
    }

}

extension TangshiDetailViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("DetailCellTableViewCell", owner: self, options: nil)?.first as? DetailCellTableViewCell
        cell?.titleLb.text = self.bll.detailDatasource[indexPath.row].title
        cell?.subtitleLb?.text = self.bll.detailDatasource[indexPath.row].realInfo
        cell?.authorLb.text = self.bll.detailDatasource[indexPath.row].author
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bll.detailDatasource.count
    }
}
