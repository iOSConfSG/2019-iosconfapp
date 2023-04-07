//
//  AppDelegate.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 3/11/18.
//  Copyright © 2018 Vina Melody. All rights reserved.
//

import UIKit
import FlagsmithClient

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
        
        if let flagsmithKey = ProcessInfo.processInfo.environment["FLAGSMITH_KEY"] {
            Flagsmith.shared.apiKey = flagsmithKey
            
            Flagsmith.shared.getFeatureFlags { result in
                switch result {
                case .success(let flags):
                    for flag in flags {
                        let name = flag.feature.name
                        let value = flag.value.stringValue
                        let enabled = flag.enabled
                        print(name, "= enabled:", enabled, "value:", value ?? "nil")
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

