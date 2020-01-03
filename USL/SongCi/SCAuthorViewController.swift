//
//  *******************************************
//  
//  SCAuthorViewController.swift
//  PoietData
//
//  Created by Noah_Shan on 2020/1/3.
//  Copyright © 2018 Inpur. All rights reserved.
//  
//  *******************************************
//


import UIKit

class SCAuthorViewController: UIViewController {

    @IBOutlet weak var tab: UITableView!
    
    var sha: String = ""

    var path: String = ""

    let bll = SongciBll()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SC作者"
        self.bll.tsauthorReloadAction = { [weak self] in
            MBProgressHUD.hide(for: self?.view ?? UIView(), animated: true)
            self?.tab.reloadData()
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.bll.getAuthorBlob(sha: self.sha, path: self.path)
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
        self.bll.recursiveProgressAuthorDatasource(datasource: self.bll.tsauthorDatasource) { (result) in
            hud.hide(animated: true)
        }
    }

}

extension SCAuthorViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("DetailCellTableViewCell", owner: self, options: nil)?.first as? DetailCellTableViewCell
        cell?.titleLb.text = self.bll.tsauthorDatasource[indexPath.row].name
        cell?.subtitleLb?.text = self.bll.tsauthorDatasource[indexPath.row].desc
        cell?.authorLb.text = self.bll.tsauthorDatasource[indexPath.row].id
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bll.tsauthorDatasource.count
    }
}
