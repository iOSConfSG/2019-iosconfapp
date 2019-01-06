//
//  Talk.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 6/1/19.
//  Copyright © 2019 Vina Melody. All rights reserved.
//

import Foundation
import FirebaseDatabase

public enum TalkType: String {
    case registration
    case openingAddress
    case closingAddress
    case shortbreak
    case coffeeBreak
    case lunch
    case normalTalk
    case lightningTalk
    case afterparty
    case special
}
class Talk {
    
    var firebaseId: String
    var title: String
    var startAt: Date
    var endAt: Date
    var talkDescription: String
    var talkIconFilename: String
    var isOngoing: Bool = false
    var speakerId: String?
    var talkType: TalkType
    var speaker: Speaker?
    
    init(snapshot: DataSnapshot) {
        self.firebaseId = snapshot.key
        let talkDict = snapshot.value as! NSDictionary
        
        self.title = talkDict["title"] as! String
        self.talkDescription = talkDict["talk_description"] as! String
        if let speakerId = talkDict["speakerId"] as? String, speakerId != "" {
            self.speakerId = speakerId
        } else {
            self.speakerId = nil
            self.speaker = nil
        }
        
        let dateFormatter: DateFormatter = {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            df.timeZone = TimeZone(identifier: "Asia/Singapore")
            return df
        }()
        
        let startAt = talkDict["start_at"] as! String
        self.startAt = dateFormatter.date(from: startAt)!
        
        let endAt = talkDict["end_at"] as! String
        self.endAt = dateFormatter.date(from: endAt)!
        
        self.talkIconFilename = talkDict["icon_filename"] as! String
        self.talkType = TalkType(rawValue: self.talkIconFilename)!
    }
    
    func reloadSpeakerData() {
        
        if let speakerId = self.speakerId {
            Speaker.getSpeakerFromFirebase(speakerId: speakerId, block: { (receivedSpeaker) in
                self.speaker = receivedSpeaker
            })
        }
        
        
    }
    
}
