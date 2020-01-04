//
//  PushNotificationManager.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 4/1/20.
//  Copyright © 2020 Vina Melody. All rights reserved.
//

import UIKit
import OneSignal

class PushNotificationManager: NSObject, UIApplicationDelegate {

    private func setupPushNotification(launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) {
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
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        setupPushNotification(launchOptions: launchOptions)
        return false
    }
}
