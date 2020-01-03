//
//  *******************************************
//  
//  SongciDetailViewController.swift
//  PoietData
//
//  Created by Noah_Shan on 2020/1/3.
//  Copyright © 2018 Inpur. All rights reserved.
//  
//  *******************************************
//


import UIKit

class SongciDetailViewController: UIViewController {

    @IBOutlet weak var tab: UITableView!

    let bll = SongciBll()

    var filePath: String = ""

    /// 是否是自动同步并处理ui
    var shouldAutoSync: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SC详情"

        self.bll.detailReloadAction = { [weak self] in
            MBProgressHUD.hide(for: self?.view ?? UIView(), animated: true)
            self?.tab.reloadData()

            if self?.shouldAutoSync ?? false {
                self?.syncInfos()
            }
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        bll.getTSDetailInfo(path: self.filePath)

        initVw()
    }

    func initVw() {
        let syncBtn = UIBarButtonItem(title: "同步", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.syncInfos))
        self.navigationItem.rightBarButtonItem = syncBtn
    }

    @objc func syncInfos() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .annularDeterminate
        hud.label.text = "async..."
        self.bll.recursiveProgressDatasource(datasource: self.bll.detailDatasource) { (result) in
            hud.hide(animated: true)

            if self.shouldAutoSync {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }


}

extension SongciDetailViewController: UITableViewDelegate, UITableViewDataSource {

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
