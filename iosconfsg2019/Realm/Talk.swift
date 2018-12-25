//
//  Talk.swift
//  iosconfsg2019
//
//  Created by Vina Rianti on 27/11/18.
//  Copyright © 2018 Vina Melody. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class Talk: Object, Decodable {

    enum Property: String {
        case key, title, startAt, endAt, speakers, talkDescription, talkIconFilename, isOngoing, feedback
    }

    private enum CodingKeys: String, CodingKey {
        case title, speakers, feedback
        case startAt = "start_at"
        case endAt = "end_at"
        case talkDescription = "talk_description"
        case talkIconFilename = "icon_filename"
        case isOngoing = "is_ongoing"
    }

    dynamic var key: String = UUID().uuidString
    dynamic var title: String = ""
    dynamic var startAt: Date?
    dynamic var endAt: Date?
    dynamic var talkDescription: String = ""
    dynamic var talkIconFilename: String = ""
    dynamic var isOngoing: Bool = false
    let speakers: List<Speaker> = List<Speaker>()
    let feedback: List<Feedback> = List<Feedback>()

    override static func primaryKey() -> String? {
        return Talk.Property.key.rawValue
    }

    convenience init(title: String, startAt: Date, endAt: Date, talkDescription: String) {
        self.init()
        self.title = title
        self.startAt = startAt
        self.endAt = endAt
        self.talkDescription = talkDescription
    }

    convenience init(title: String, startAt: Date, endAt: Date? = nil, talkDescription: String, talkIconFilename: String, speakers: List<Speaker>) {
        self.init()
        self.title = title
        self.startAt = startAt
        self.endAt = endAt
        self.talkDescription = talkDescription
        self.talkIconFilename = talkIconFilename
        self.speakers.append(objectsIn: speakers)
    }

    convenience required init(from decoder: Decoder) throws {

        let dateFormatter: DateFormatter = {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            df.timeZone = TimeZone(identifier: "Asia/Singapore")
            return df
        }()

        let container = try decoder.container(keyedBy: CodingKeys.self)

        let title = try container.decode(String.self, forKey: .title)

        let startDateString = try container.decode(String.self, forKey: .startAt)
        guard let startAt = dateFormatter.date(from: startDateString) else {
            throw DecodingError.dataCorruptedError(forKey: .startAt, in: container, debugDescription: "Failed parsing date")
        }

        let talkDescription = try container.decode(String.self, forKey: .talkDescription)
        let talkIconFilename = try container.decode(String.self, forKey: .talkIconFilename)
        let speakersArray = try container.decode([Speaker].self, forKey: .speakers)
        let speakersList = List<Speaker>()
        speakersList.append(objectsIn: speakersArray)

        print("title = \(title)")
        print("speakers = \(speakersList)")
        print("============\n\n")

        var endAt: Date? = nil
        let endAtString = try container.decodeIfPresent(String.self, forKey: .endAt)
        if let s = endAtString {
            endAt = dateFormatter.date(from: s)
        }

        self.init(title: title, startAt: startAt, endAt: endAt, talkDescription: talkDescription, talkIconFilename: talkIconFilename, speakers: speakersList)
    }

    @discardableResult
    internal func add(to realm: Realm) -> Talk {
        do {
            try realm.write {
                realm.add(self)
            }
        } catch let error {
            print("Realm writing talk error: \(error.localizedDescription)")
        }
        return self
    }
}
