//
//  WorkshopViewModel.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 27/10/19.
//  Copyright © 2019 Vina Melody. All rights reserved.
//

import Foundation
import Apollo

protocol WorkshopViewModelDelegate {
    func didFetchSchedule()
}

class WorkshopViewModel {

    private var apollo: ApolloClient!
    private var scheduleSubscription: Cancellable!
    private var scheduleGraphql: [GetScheduleSubscription.Data.Schedule] = []
    private var schedule: [Talk] = []

    var delegate: WorkshopViewModelDelegate?
    var selectedDay: Int?

    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        df.timeZone = TimeZone(identifier: "Asia/Singapore")
        return df
    }()

    enum WorkshopDay: Int, CaseIterable {
        case one = 0
        case two = 1

        
        var dateString: String {
            switch self {
            case .one:
                return "18 Jan"
            case .two:
                return "19 Jan"
            }
        }

        var activityName: String {
            switch self {
            case .one:
                return "iosconfsg21.workshop1"
            case .two:
                return "iosconfsg21.workshop2"
            }
        }

        var dateInt: Int {
            switch self {
            case .one:
                return 18
            case .two:
                return 19
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
        let allConferenceDays = WorkshopDay.allCases
        return allConferenceDays.compactMap({ return $0.dateString })
    }

    func segmentedControlSelectedIndex() -> Int {
        if selectedDay == nil {
            let today = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: today)
            let day = components.day ?? 0

            switch day {
            case 16:
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
                            startAt: dateFormatter.date(from: item.startAt ?? ""),
                            endAt: dateFormatter.date(from: item.endAt ?? ""),
                            talkDescription: item.talkDescription,
                            activityName: item.activity ?? "",
                            speakers: speakers)
            self.schedule.append(talk)
        }
        delegate?.didFetchSchedule()
    }
    
    // TODO: refactor to a factory!
    func createSpeakers(from talk: GetScheduleSubscription.Data.Schedule) -> [Speaker] {
        let speakers = talk.speakers.map { (speaker) -> Speaker in
            return Speaker(id: speaker.id ?? 1,
                           name: speaker.name ?? "",
                           shortBio: speaker.shortBio,
                           twitter: speaker.twitter,
                           linkedIn: speaker.linkedinUrl,
                           company: speaker.company,
                           companyUrl: speaker.companyUrl,
                           imageUrl: speaker.imageUrl,
                           imageFilename: speaker.imageFilename)
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
        guard let selectedDay = WorkshopDay(rawValue: day) else {
            return [Talk]()
        }

        let talksOnThatDay = self.schedule.filter({ $0.activityName == selectedDay.activityName })
        return talksOnThatDay
    }
}
