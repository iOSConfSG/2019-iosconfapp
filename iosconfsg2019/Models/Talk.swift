//
//  Talk.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 6/1/19.
//  Copyright © 2019 Vina Melody. All rights reserved.
//

import Foundation

public enum TalkType: String {
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
}

struct TalkV2 {
    var id: Int
    var title: String
    var talkType: TalkType
    var startAt: Date?
    var endAt: Date?
    var talkDescription: String?
    var speakerImage: String?
    var speakerTwitter: String?
    var speakerCompany: String?
    var speakerName: String?
    var speakerBio: String?
    var speakerLinkedin: String?
    var speakerImageUrl: String?
    var activityName: String?
}
