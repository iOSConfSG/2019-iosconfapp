//
//  AppDelegate.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 3/11/18.
//  Copyright © 2018 Vina Melody. All rights reserved.
//

import UIKit
import OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var modules: [UIApplicationDelegate] = [UIApplicationDelegate]()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        registerModules()

        _ = modules.compactMap {
            _ = $0.application?(application, didFinishLaunchingWithOptions: launchOptions)
        }
        
        window = UIWindow()
        if #available(iOS 12.0, *) {
            window?.tintColor = (window?.traitCollection.userInterfaceStyle == .dark) ? UIColor.orange : UIColor.purple
        } else {
            window?.tintColor = UIColor.purple
        }
        window?.makeKeyAndVisible()
        
        // Which screen to show?
        if UserDefaults.standard.object(forKey: "sawWelcomeScreen") == nil {
            window?.rootViewController = WelcomeViewController()
            return true
        } else {
            window?.rootViewController = CustomTabBarController()
            return true
        }
//        window?.rootViewController = UINavigationController(rootViewController: ScheduleGraphqlViewController())
//        window?.rootViewController = CustomTabBarController()
//        return true
    }

}

extension AppDelegate {
    private func registerModules() {
        modules.append(PushNotificationManager())
        modules.append(AnalyticsManager())
    }
}

