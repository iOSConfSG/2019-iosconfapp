//
//  DateTimeUtils.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 13/1/21.
//  Copyright © 2021 Vina Melody. All rights reserved.
//

import Foundation

class DateTimeUtils {
    static let shared = DateTimeUtils()
    public let SG_TIMEZONE: String = "Asia/Singapore"
    
    var selectedTimezone: TimeZone
    
    private init() {
        // Default is local timezone
        selectedTimezone = TimeZone.current
    }
    
    // This determines if the toggle should be turn on or not
    public func shouldEnableZoneToggle() -> Bool {
        return TimeZone.current.identifier != SG_TIMEZONE
    }
    
    public func isInSgTimezone() -> Bool {
        return selectedTimezone.identifier == SG_TIMEZONE
    }
    
    public func toggleSelectedTimezone() {
        if isInSgTimezone() {
            resetToLocal()
        } else {
            // Show in Singapore tz
            selectedTimezone = TimeZone(identifier: SG_TIMEZONE)!
        }
    }
    
    private func resetToLocal() {
        selectedTimezone = TimeZone.current
    }
    
    private func flag(from country:String) -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in country.uppercased().unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return s
    }
    
    public func titleForRezoneButton() -> String {
        let country = selectedTimezone.identifier == SG_TIMEZONE ? "\(Locale.current.regionCode ?? "Local")" : "SG"
        let flagEmoji = flag(from: country)
        return "Show in \(flagEmoji) time"
    }
    
    public func titleForCurrentZoneInfo() -> NSAttributedString {
        let plain = "Times are shown in \(selectedTimezone.identifier) time zone"
        let attrText = NSMutableAttributedString(string: plain)
        attrText.colorSubstrings(substrings: [selectedTimezone.identifier], color: StyleSheet.shared.theme.primaryLabelColor)
        return attrText
    }
}
