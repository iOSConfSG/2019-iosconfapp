//
//  BaseViewController.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 4/1/20.
//  Copyright © 2020 Vina Melody. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

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
        return TrackingEvent(screenView: self)
    }
}
