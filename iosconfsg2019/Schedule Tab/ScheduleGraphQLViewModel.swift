//
//  ScheduleGraphQLViewModel.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 13/10/19.
//  Copyright © 2019 Vina Melody. All rights reserved.
//

import Foundation
import Apollo

protocol ScheduleGraphqlViewModelDelegate {
    func didFetchSchedule()
}

class ScheduleGraphqlViewModel {

    private var apollo: ApolloClient!
    private var scheduleSubscription: Cancellable?
    private var scheduleGraphql: [GetScheduleSubscription.Data.Schedule] = []
    private var schedule: [TalkV2] = []

    var delegate: ScheduleGraphqlViewModelDelegate?
    var selectedDay: Int?

    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        df.timeZone = TimeZone(identifier: "Asia/Singapore")
        return df
    }()

    enum ConferenceDay: Int, CaseIterable {
        case one = 0
        case two = 1

        var dateString: String {
            switch self {
            case .one:
                return "17 Jan"
            case .two:
                return "18 Jan"
            }
        }

        var activityName: String {
            switch self {
            case .one:
                return "iosconfsg20.day1"
            case .two:
                return "iosconfsg20.day2"
            }
        }

        var dateInt: Int {
            switch self {
            case .one:
                return 17
            case .two:
                return 18
            }
        }
    }

    init(failInitClosure: (()-> Void)) {
        guard let connection = NetworkManager.shared.apolloClient else {
            failInitClosure()
            return
        }
        self.apollo = connection
    }

    func segmentedControlLabels() -> [String] {
        let allConferenceDays = ConferenceDay.allCases
        return allConferenceDays.compactMap({ return $0.dateString })
    }

    func segmentedControlSelectedIndex() -> Int {
        if selectedDay == nil {
            let today = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: today)
            let day = components.day ?? 0

            switch day {
            case 18:
                self.selectedDay = 1
            default:
                self.selectedDay = 0
            }
        }
        return selectedDay ?? 0

    }

    func tryFetchSchedule() {
        scheduleSubscription = apollo.subscribe(subscription: GetScheduleSubscription(), resultHandler: { [weak self] (result) in
            switch result {
            case .success(let object):
                if let data = object.data {
                    self?.createSchedule(from: data.schedule)
                }
            case .failure(let error):
                self?.handleError(error: error)
            }
        })
    }

    func handleError(error: Error) {
        print("Error = \(error.localizedDescription)")
    }

    func createSchedule(from response: [GetScheduleSubscription.Data.Schedule]) {
        if !self.schedule.isEmpty {
            self.schedule.removeAll()
        }
        for item in response {
            guard let id = item.id,
                let title = item.title,
                let talkTypeString = item.talkType,
                let talkType = TalkType(rawValue: talkTypeString) else {
                print("Incomplete data")
                return
            }

            let talk = TalkV2(id: id,
                              title: title,
                              talkType: talkType,
                              startAt: dateFormatter.date(from: item.startAt ?? ""),
                              endAt: dateFormatter.date(from: item.endAt ?? ""),
                              talkDescription: item.talkDescription,
                              speakerImage: item.speakerImage ?? "welcome_icon",
                              speakerTwitter: item.speakerTwitter ?? "N/A",
                              speakerCompany: item.speakerCompany ?? "N/A",
                              speakerName: item.speakerName ?? "iOS Conf SG",
                              speakerBio: item.speakerBio,
                              speakerLinkedin: item.speakerLinkedin,
                              activityName: item.activity ?? "")
            self.schedule.append(talk)
        }
        delegate?.didFetchSchedule()
    }

    func numberOfRows() -> Int {
        return scheduleFor(day: self.selectedDay ?? 0).count
    }

    func getTalkForIndexpath(indexPath: IndexPath) -> TalkV2? {
        guard !self.schedule.isEmpty else { return nil }
        let selectedDay = self.selectedDay ?? 0
        let scheduleOnSelectedDay = scheduleFor(day: selectedDay)

        guard !scheduleOnSelectedDay.isEmpty, indexPath.row < scheduleOnSelectedDay.count else { return nil }

        return scheduleOnSelectedDay[indexPath.row]
    }

    private func scheduleFor(day: Int) -> [TalkV2] {
        guard let selectedDay = ConferenceDay(rawValue: day) else {
            return [TalkV2]()
        }

        let talksOnThatDay = self.schedule.filter({ $0.activityName == selectedDay.activityName })
        return talksOnThatDay
    }
}
