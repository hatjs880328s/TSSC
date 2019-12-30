//
//  *******************************************
//  
//  TangshiViewController.swift
//  PoietData
//
//  Created by Noah_Shan on 2019/12/27.
//  Copyright © 2018 Inpur. All rights reserved.
//  
//  *******************************************
//


import UIKit

class TangshiViewController: UIViewController {

    @IBOutlet weak var contentTab: UITableView!

    let bll = TanshiBLL()

    var path: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.bll.getData(path: path)
        self.title = "唐诗宋词"
        self.bll.reloadAction = { [weak self] in
            MBProgressHUD.hide(for: self?.view ?? UIView(), animated: true)
            self?.contentTab.reloadData()
        }
    }

}

extension TangshiViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "reuseid")
        cell.textLabel?.text = self.bll.dataSource[indexPath.row].name
        cell.detailTextLabel?.text = "path: \(self.bll.dataSource[indexPath.row].path)"
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bll.dataSource.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 唐诗详情 | 作者详情

        // error文件夹
        if self.bll.dataSource[indexPath.row].type != "file" {
            let con = TangshiViewController()
            con.path = self.bll.dataSource[indexPath.row].path
            self.navigationController?.pushViewController(con, animated: true)
            return
        }
        //其他文件
        if self.bll.dataSource[indexPath.row].path.contains("authors") {
            let path = self.bll.dataSource[indexPath.row].path
            let con = TangshiAuthorDetailViewController()
            con.path = path
            self.navigationController?.pushViewController(con, animated: true)
        } else {
            let path = self.bll.dataSource[indexPath.row].path
            let con = TangshiDetailViewController()
            con.filePath = path
            self.navigationController?.pushViewController(con, animated: true)
        }

    }
}
