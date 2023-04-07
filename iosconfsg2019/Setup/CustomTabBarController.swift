//
//  CustomTabBarController.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 10/11/18.
//  Copyright © 2018 Vina Melody. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scheduleController = ScheduleGraphqlViewController()
        let scheduleTab = UINavigationController(rootViewController: scheduleController)
        scheduleTab.title = "Conference"
        scheduleTab.tabBarItem.image = UIImage(systemName: "calendar")
        
        let newsController = NewsViewController()
        let newsTab = UINavigationController(rootViewController: newsController)
        newsTab.title = "News"
        newsTab.tabBarItem.image = UIImage(imageLiteralResourceName: "news_icon")
        
        let aboutController = AboutViewController()
        let aboutTab = UINavigationController(rootViewController: aboutController)
        aboutTab.title = "About"
        aboutTab.tabBarItem.image = UIImage(imageLiteralResourceName: "iosconfsg_icon")
        
        viewControllers = [scheduleTab, newsTab, aboutTab]
//        tabBar.isTranslucent = false
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0.5)
        topBorder.backgroundColor = UIColor.lightGray.cgColor
        
        tabBar.layer.addSublayer(topBorder)
        tabBar.clipsToBounds = true
        tabBar.tintColor = StyleSheet.shared.theme.primaryLabelColor
    }
}


