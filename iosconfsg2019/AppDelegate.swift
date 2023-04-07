//
//  AppDelegate.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 3/11/18.
//  Copyright © 2018 Vina Melody. All rights reserved.
//

import UIKit
import FlagsmithClient
import Yams

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

struct Fig: Codable {
    var minimumVersion: String
    var scheduleMode: ScheduleMode
    var flags: Flags
    
    enum ScheduleMode: String, Codable {
        case local
        case remote
    }
    
    struct Flags: Codable {
        var submitFeedback: Bool
    }
}

extension Fig: CustomStringConvertible {
    var description: String {
        """
        ----- REMOTE CONFIG -----
        minimumVersion: \(minimumVersion)
        scheduleMode: \(scheduleMode)
        
        ----- Flags -----
        submitFeedback: \(flags.submitFeedback)
        """
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
                        let decoder = YAMLDecoder()
                        
                        do {
                            guard let value = flag.value.stringValue else { return }
                            let decoded = try decoder.decode(Fig.self, from: value)
                            print(decoded)
                        } catch {
                            // TODO: Fallback to local config
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

