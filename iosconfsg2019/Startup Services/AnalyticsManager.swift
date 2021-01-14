//
//  AnalyticsManager.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 4/1/20.
//  Copyright © 2020 Vina Melody. All rights reserved.
//

import UIKit

class AnalyticsManager: NSObject {
    static let shared = AnalyticsManager()

    func log(event: TrackingEvent) {
        // do nothing for this time round
        return
    }

    private func convertParameters(_ trackingEventParams: [TrackingEvent.ParameterKey: String]) -> [String: String] {
        var params = [String: String]()

        for (key, value) in trackingEventParams {
            params[key.rawValue] = value
        }
        return params
    }
}

extension AnalyticsManager: UIApplicationDelegate {

    private func setupAnalytics() {
        // another analytics in the future
        // FirebaseApp.configure()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        setupAnalytics()
        return false
    }
}

class TrackingEvent {

    enum EventType {
        case tap
        case screenView

        var identifier: String {
            switch self {
            case .tap:
                return "hikari_tap" // intentional name ... just a name ^^
            case .screenView:
                return "hikari_screen_view"
            }
        }
    }

    enum ParameterKey: String {
        case eventCategory = "event_category"
        case eventLabel = "event_label"
        case eventAction = "event_action"
        case screenName = "screen_name"
        case contentCategory = "content_category"
        case userInterfaceStyle = "user_interface_style"
    }

    let eventType: EventType
    var parameters: [ParameterKey: String] = [ParameterKey: String]()

    init(eventType: EventType) {
        self.eventType = eventType
    }

    convenience init(tap label: String, category: String) {
        self.init(eventType: .tap)
        parameters[.eventCategory] = category
        parameters[.eventLabel] = label
        parameters[.eventAction] = "Tap"
    }

    convenience init?(screenView viewController: UIViewController, screenName: String? = nil) {
        self.init(eventType: .screenView)
        switch viewController {
        case is ScheduleGraphqlViewController:
            parameters[.screenName] = "Schedule Screen"
            parameters[.contentCategory] = "Schedule"
        case is DetailGraphqlViewController:
            if let screenName = screenName {
                parameters[.screenName] = screenName
            } else {
                parameters[.screenName] = "Activity Detail Screen"
            }
            parameters[.contentCategory] = "Schedule"
        case is FeedbackViewController:
            parameters[.screenName] = "Feedback Popup"
            parameters[.contentCategory] = "Schedule"
        case is WorkshopViewController:
            parameters[.screenName] = "Workshop Screen"
            parameters[.contentCategory] = "Workshop"
        case is AboutViewController:
            parameters[.screenName] = "About Screen"
            parameters[.contentCategory] = "About"
        case is WelcomeViewController:
            parameters[.screenName] = "Welcome Screen"
            parameters[.contentCategory] = "Welcome"
        case is CustomAlertViewController:
            parameters[.screenName] = "Alert Popup"
        case is NewsViewController:
            parameters[.screenName] = "News Screen"
            parameters[.contentCategory] = "News"
        case is VenueViewController:
            parameters[.screenName] = "Venue Screen"
            parameters[.contentCategory] = "Venue"
        default:
            return nil
        }
    }

    func addParameter(key: ParameterKey, value: String) {
        self.parameters[key] = value
    }
}
