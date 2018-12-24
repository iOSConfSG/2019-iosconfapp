//
//  AppDelegate.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 3/11/18.
//  Copyright © 2018 Vina Melody. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = WelcomeViewController()
//        window?.rootViewController = CustomTabBarController()
//        window?.rootViewController = UINavigationController(rootViewController: HomeViewController())
//        window?.rootViewController = UINavigationController(rootViewController: DetailViewController())
//        window?.rootViewController = UINavigationController(rootViewController: FeedbackViewController())
        return true
    }


}

