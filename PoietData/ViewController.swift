//
//  *******************************************
//  
//  ViewController.swift
//  PoietData
//
//  Created by Noah_Shan on 2019/12/27.
//  Copyright © 2018 Inpur. All rights reserved.
//  
//  *******************************************
//


import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        TangshiUti.getAllDirAndFiles { (models) in
            print("fdas")
        }
    }


}

