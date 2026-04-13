//
//  SGDate.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 31/03/26.
//

import Foundation

enum SGDate {
    
    static let timeZone = TimeZone(abbreviation: "SGT")!
    
    static var calendar: Calendar {
        var cal = Calendar(identifier: .iso8601)
        cal.timeZone = timeZone
        cal.locale = Locale(identifier: "en_US_POSIX")
        return cal
    }

    static func formatter(_ format: String) -> DateFormatter {
        let f = DateFormatter()
        f.calendar = calendar
        f.timeZone = timeZone
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = format
        return f
    }
    
    static func today() -> Date {
        calendar.startOfDay(for: Date())
    }

    static func stripTime(_ date: Date) -> Date {
        calendar.startOfDay(for: date)
    }
    
    static func dateFromAPI(_ string: String) -> Date? {
        formatter("yyyy-MM-dd").date(from: string)
    }
    
    static func dayName(from date: Date) -> String {
        return formatter("EEEE").string(from: date)
    }
}
