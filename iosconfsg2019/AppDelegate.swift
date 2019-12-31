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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // OneSignal
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
        if let oneSignalDict = Helpers.dictionaryFromPlist(filename: "OneSignal-Info") {
            
            if let oneSignalAppId = oneSignalDict["ONE_SIGNAL_APP_ID"] {
                
                let appIdString = oneSignalAppId as! String
            
                OneSignal.initWithLaunchOptions(launchOptions,
                                                appId: appIdString,
                                                handleNotificationAction: nil,
                                                settings: onesignalInitSettings)
                
                OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
            }
            else {
                print("ERROR: Failed to initialize OneSignal - ONE_SIGNAL_APP_ID missing from plist.")
            }
            
        }
        else {
            print("ERROR: Failed to initialize OneSignal - missing OneSignal-Info.plist file.")
        }
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        
        // Which screen to show?
        
//        if UserDefaults.standard.object(forKey: "sawWelcomeScreen") == nil {
//            window?.rootViewController = WelcomeViewController()
//            return true
//        } else {
//            window?.rootViewController = CustomTabBarController()
//            return true
//        }
//        window?.rootViewController = UINavigationController(rootViewController: ScheduleGraphqlViewController())
        window?.rootViewController = CustomTabBarController()
        return true
    }

}

