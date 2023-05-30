//
//  Talk.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 6/1/19.
//  Copyright © 2019 Vina Melody. All rights reserved.
//

import Foundation

struct LocalScheduleData: Codable {
    struct Schedule: Codable {
        var talks: [Talk]
        
        enum CodingKeys: String, CodingKey {
            case talks = "schedule"
        }
    }
    var data: Schedule
}

public enum TalkType: String, Codable {
    case registration
    case openingAddress
    case closingAddress
    case shortbreak
    case lunch
    case normalTalk
    case lightningTalk
    case afterparty
    case workshop
    case groupPhoto
    case quiz
    case energyboost
    case combinedTalk
    case panel
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawString = try container.decode(String.self)
        
        if let type = TalkType(rawValue: rawString) {
            self = type
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot initalise TalkType from invalid String value \(rawString)")
        }
    }
}

struct Talk: Codable {
    var id: Int
    var title: String
    var talkType: TalkType
    var startAt: Date?
    var talkDescription: String?
    var activityName: String?
    var speakers: [Speaker]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case talkType = "talk_type"
        case startAt = "start_at"
        case talkDescription = "talk_description"
        case activityName = "activity"
        case speakers
    }
    
}
