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
        df.timeZone = DateTimeUtils.shared.selectedTimezone
        df.dateFormat = "HH:mm"
        return df.string(from: self)
    }
    
    public func toConferenceDate() -> String {
        let df = DateFormatter()
        df.timeZone = DateTimeUtils.shared.selectedTimezone
        df.dateFormat = "d MMM yyyy"
        return df.string(from: self)
    }
}
