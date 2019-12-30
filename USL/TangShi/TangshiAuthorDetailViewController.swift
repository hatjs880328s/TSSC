//
//  *******************************************
//  
//  TangshiAuthorDetailViewController.swift
//  PoietData
//
//  Created by Noah_Shan on 2019/12/27.
//  Copyright © 2018 Inpur. All rights reserved.
//  
//  *******************************************
//


import UIKit

/// 唐诗作者详情
class TangshiAuthorDetailViewController: UIViewController {

    @IBOutlet weak var tab: UITableView!

    var path: String = ""

    let bll = TanshiBLL()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "唐诗作者"
        self.bll.tsauthorReloadAction = { [weak self] in
            MBProgressHUD.hide(for: self?.view ?? UIView(), animated: true)
            self?.tab.reloadData()
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.bll.getTSAuthorInfo(path: path)
    }

}

extension TangshiAuthorDetailViewController: UITableViewDelegate, UITableViewDataSource {

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
