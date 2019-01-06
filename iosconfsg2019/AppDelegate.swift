//
//  AppDelegate.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 3/11/18.
//  Copyright © 2018 Vina Melody. All rights reserved.
//

import UIKit
import OneSignal
import Firebase
import FirebaseDatabase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Firebase
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        
        Auth.auth().signInAnonymously { (user, error) in
            if let error = error {
                #if DEBUG
                print("FirebaseAuth Error: \(error.localizedDescription)")
                #endif
            }
            #if DEBUG
            print("FirebaseAuth signed in anonymously")
            #endif
        }
        
        // OneSignal
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
        
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "6cae02d0-cce0-4457-bb58-0ed5302980f3",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        
        // Which screen to show?
        
        if UserDefaults.standard.object(forKey: "sawWelcomeScreen") == nil {
            window?.rootViewController = WelcomeViewController()
            return true
        } else {
            window?.rootViewController = CustomTabBarController()
            return true
        }
    }

}

