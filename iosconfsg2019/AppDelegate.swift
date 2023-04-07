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
        window?.rootViewController = CustomTabBarController()
        return true
    }

}

extension AppDelegate {
    private func registerModules() {
        // Nothing to append
    }
}

