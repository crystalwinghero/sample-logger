//
//  MainTabVC.swift
//  sample-logger
//
//  Created by Crystalwing B. on 10/10/24.
//

import UIKit

final class MainTabVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Global.logger.log(#function)
        setup()
    }
    
    private func setup() {
        Global.logger.log(#function)
        let mainVC = MainVC(screenTitle: "Main")
        let mainNav = UINavigationController(rootViewController: mainVC)
        mainNav.tabBarItem.title = "Main"
        mainNav.tabBarItem.image = UIImage(systemName: "house")
        let settingVC = SettingVC(screenTitle: "Settings")
        let settingNav = UINavigationController(rootViewController: settingVC)
        settingNav.tabBarItem.title = "Settings"
        settingNav.tabBarItem.image = UIImage(systemName: "gear")
        
        self.setViewControllers([mainNav, settingNav], animated: false)
    }
}
