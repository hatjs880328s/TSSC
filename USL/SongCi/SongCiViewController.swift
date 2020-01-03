//
//  *******************************************
//  
//  SongCiViewController.swift
//  PoietData
//
//  Created by Noah_Shan on 2020/1/3.
//  Copyright © 2018 Inpur. All rights reserved.
//  
//  *******************************************
//


import UIKit

/// 宋词
class SongCiViewController: UIViewController {

    @IBOutlet weak var tab: UITableView!

    let bll = SongciBll()

    var path: String = ""

    /// 是否需要自动同步操作 - 默认为false
    private var shouldAutoStart: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.bll.getData(path: path)
        self.title = "SC Path list"
        self.bll.reloadAction = { [weak self] in
            MBProgressHUD.hide(for: self?.view ?? UIView(), animated: true)
            self?.tab.reloadData()
        }
        initVw()
    }

    func initVw() {
        let syncBtn = UIBarButtonItem(title: "auto-sync", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.syncInfos))
        self.navigationItem.rightBarButtonItem = syncBtn
    }

    /// 自动同步开始
    @objc func syncInfos() {
        self.shouldAutoStart = true

        self.bll.autoSYNCTSInfos { [weak self] (path) in
            self?.jump2TSDetail(path: path, shouldAutoSync: true)
        }
    }

    /// 自动同步处理
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if self.shouldAutoStart {
            self.bll.autoSYNCTSInfos { [weak self] (path) in
                self?.jump2TSDetail(path: path, shouldAutoSync: true)
            }
        }
    }

    /// 跳入TS详情页面
    func jump2TSDetail(path: String, shouldAutoSync: Bool) {
        let con = SongciDetailViewController()
        con.filePath = path
        con.shouldAutoSync = shouldAutoSync
        self.navigationController?.pushViewController(con, animated: true)
    }

}

extension SongCiViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "reuseid")
        let model = self.bll.dataSource[indexPath.row]
        cell.textLabel?.text = model.name
        cell.detailTextLabel?.text = "同步状态: \(model.calPathFlag ? "✅" : "❌")  路径: \(self.bll.dataSource[indexPath.row].path)"
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bll.dataSource.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // error文件夹
        if self.bll.dataSource[indexPath.row].type != "file" {
            let con = SongCiViewController()
            con.path = self.bll.dataSource[indexPath.row].path
            self.navigationController?.pushViewController(con, animated: true)
            return
        }
        if self.bll.dataSource[indexPath.row].path.contains("ci.song") {
            jump2TSDetail(path: self.bll.dataSource[indexPath.row].path, shouldAutoSync: false)
        } else {

        }
    }
}
