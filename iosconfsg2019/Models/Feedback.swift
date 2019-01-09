//
//  Feedback.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 9/1/19.
//  Copyright © 2019 Vina Melody. All rights reserved.
//

import Foundation

class Feedback {
    
    public enum Feeling {
        case frowning, neutral, smile, grin, starstruck
        
        // Unicode 1F929 will appear as 🤩 .. cool!
        var emoji: String {
            switch self {
            case .frowning:
                return "🙁"
            case .neutral:
                return "😐"
            case .smile:
                return "🙂"
            case .grin:
                return "\u{1F601}"
            case .starstruck:
                return "\u{1F929}"
            }
        }
    }
    
    var feeling: Feeling
    var comments: String
    var firebaseId: String?
    
    init(feeling: Feeling, comments: String) {
        self.feeling = feeling
        self.comments = comments
    }
}
