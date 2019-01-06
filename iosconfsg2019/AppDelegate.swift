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
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
        
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "6cae02d0-cce0-4457-bb58-0ed5302980f3",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        window = UIWindow()
        window?.makeKeyAndVisible()
//        window?.rootViewController = WelcomeViewController()
        window?.rootViewController = CustomTabBarController()
//        window?.rootViewController = UINavigationController(rootViewController: HomeViewController())
//        window?.rootViewController = UINavigationController(rootViewController: DetailViewController())
//        window?.rootViewController = UINavigationController(rootViewController: FeedbackViewController())
        return true
    }


}

