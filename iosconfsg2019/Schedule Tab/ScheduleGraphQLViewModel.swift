//
//  ScheduleGraphQLViewModel.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 13/10/19.
//  Copyright © 2019 Vina Melody. All rights reserved.
//

import Foundation
import Apollo
import ConfAPI

protocol ScheduleGraphqlViewModelDelegate {
    func didFetchSchedule()
}

class ScheduleGraphqlViewModel {

    private var apollo: ApolloClient!
    private var scheduleSubscription: Cancellable?
    private var scheduleGraphql: [GetScheduleSubscription.Data.Schedule] = []
    private var schedule: [Talk] = []

    var delegate: ScheduleGraphqlViewModelDelegate?
    var selectedDay: Int?

    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return df
    }()

    enum ConferenceDay: Int, CaseIterable {
        case one = 0
        case two = 1

        var dateString: String {
            switch self {
            case .one:
                return "12 Jan"
            case .two:
                return "13 Jan"
            }
        }

        var activityName: String {
            switch self {
            case .one:
                return "iosconfsg23.day1"
            case .two:
                return "iosconfsg23.day2"
            }
        }

        var dateInt: Int {
            switch self {
            case .one:
                return 12
            case .two:
                return 13
            }
        }
    }

    init() {
        self.apollo = NetworkManager.shared.client
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
                let talkTypeString = item.talk_type,
                let talkType = TalkType(rawValue: talkTypeString) else {
                print("Incomplete data \(item)")
                return
            }
            
            var speakers: [Speaker] = []
            if !item.speakers.isEmpty {
                speakers = createSpeakers(from: item)
            }

            let talk = Talk(id: id,
                            title: title,
                            talkType: talkType,
                            startAt: dateFormatter.date(from: item.start_at ?? ""),
                            endAt: dateFormatter.date(from: item.end_at ?? ""),
                            talkDescription: item.talk_description,
                            activityName: item.activity ?? "",
                            speakers: speakers)
            self.schedule.append(talk)
        }
        delegate?.didFetchSchedule()
    }

    func createSpeakers(from talk: GetScheduleSubscription.Data.Schedule) -> [Speaker] {
        let speakers = talk.speakers.map { (speaker) -> Speaker in
            return Speaker(id: speaker.id ?? 1,
                           name: speaker.name ?? "",
                           shortBio: speaker.short_bio,
                           twitter: speaker.twitter,
                           linkedIn: speaker.linkedin,
                           company: speaker.company,
                           imageUrl: speaker.image_url)
        }
        return speakers
    }
    func numberOfRows() -> Int {
        return scheduleFor(day: self.selectedDay ?? 0).count
    }

    func getTalkForIndexpath(indexPath: IndexPath) -> Talk? {
        guard !self.schedule.isEmpty else { return nil }
        let selectedDay = self.selectedDay ?? 0
        let scheduleOnSelectedDay = scheduleFor(day: selectedDay)

        guard !scheduleOnSelectedDay.isEmpty, indexPath.row < scheduleOnSelectedDay.count else { return nil }

        return scheduleOnSelectedDay[indexPath.row]
    }

    private func scheduleFor(day: Int) -> [Talk] {
        guard let selectedDay = ConferenceDay(rawValue: day) else {
            return [Talk]()
        }

        let talksOnThatDay = self.schedule.filter({ $0.activityName == selectedDay.activityName })
        return talksOnThatDay
    }
}
