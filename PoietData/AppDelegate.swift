//
//  *******************************************
//  
//  AppDelegate.swift
//  PoietData
//
//  Created by Noah_Shan on 2019/12/27.
//  Copyright © 2018 Inpur. All rights reserved.
//  
//  *******************************************
//


import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let con = UINavigationController(rootViewController: MainPageViewController())
        self.window?.rootViewController = con
        self.window?.makeKeyAndVisible()
        
        return true
    }


}

