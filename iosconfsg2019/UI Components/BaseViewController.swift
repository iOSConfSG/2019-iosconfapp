//
//  BaseViewController.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 4/1/20.
//  Copyright © 2020 Vina Melody. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var isDarkMode: Bool {
        if #available(iOS 12.0, *) {
            return self.traitCollection.userInterfaceStyle == .dark
        } else {
            return false
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logScreenView()
    }

    func logScreenView() {
        if let trackingEvent = self.trackingEvent() {
            AnalyticsManager.shared.log(event: trackingEvent)
        } else {
            print("Screen not tracked")
        }
    }

    open func trackingEvent() -> TrackingEvent? {
        let trackingEvent = TrackingEvent(screenView: self)
        trackingEvent?.addParameter(key: TrackingEvent.ParameterKey.userInterfaceStyle, value: isDarkMode ? "dark" : "light")
        return trackingEvent
    }
}
