//
//  DateExtensions.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 7/1/19.
//  Copyright © 2019 Vina Melody. All rights reserved.
//

import Foundation


extension Date {
    
    public func toConferenceTime() -> String {
        
        let df = DateFormatter()
        df.timeZone = TimeZone(abbreviation: "SGT")
        df.dateFormat = "HH:mm"
        
        return df.string(from: self)
    }
}
