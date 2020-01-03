//
//  *******************************************
//  
//  MainPageViewController.swift
//  PoietData
//
//  Created by Noah_Shan on 2019/12/27.
//  Copyright © 2018 Inpur. All rights reserved.
//  
//  *******************************************
//


import UIKit

class MainPageViewController: UIViewController {

    @IBOutlet weak var tab: UITableView!

    let bll = MainPageBll()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Main Page"
    }

}

extension MainPageViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "reuseid")
        cell.textLabel?.text = self.bll.dataSource[indexPath.row].0
        cell.detailTextLabel?.text = self.bll.dataSource[indexPath.row].1
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bll.dataSource.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let con = TangshiViewController()
            con.path = "json"
            self.navigationController?.pushViewController(con, animated: true)
        default:
            break
        }
    }
}
