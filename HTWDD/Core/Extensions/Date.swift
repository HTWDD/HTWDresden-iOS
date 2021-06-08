//
//  Date.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04/01/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import Marshal

private var dateFormatters = [String: DateFormatter]()
private func dateFormatter(format: String) -> DateFormatter {
    if let cached = dateFormatters[format] {
        return cached
    }
    let new = DateFormatter()
    new.timeZone = TimeZone.current
    new.dateFormat = format
    dateFormatters[format] = new
    return new
}

extension Date {

    static func from(string: String, format: String) throws -> Date {
        guard let date = dateFormatter(format: format).date(from: string) else {
            throw MarshalError.typeMismatch(expected: format, actual: string)
        }
        return date
    }
    
    static func from(day: Int, month: Int, year: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) -> Date? {
        var c = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute, second: second)
        c.timeZone = TimeZone.autoupdatingCurrent
        return Calendar.current.date(from: c)
    }
    
    static func from(time: String, date: String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss dd.MM.yyyy"
        
        return dateFormatter.date(from: time + " " + date)
    }

    func string(format: String) -> String {
        return dateFormatter(format: format).string(from: self)
    }

    func byAdding(days n: TimeInterval) -> Date {
        return self.addingTimeInterval(n.days)
    }
    
    var beginOfWeek: Date {
        return self.byAdding(days: -1 * TimeInterval(self.weekday.rawValue))
    }

    var weekday: Day {
        guard let rawDay = self.components.weekday else {
            fatalError("Expected a date to have a weekday.")
        }

        guard let day = Day(rawValue: rawDay - 2 < 0 ? 6 : rawDay - 2) else {
            fatalError("Expected rawDay to be between 1 and 7")
        }
        return day
    }

    var weekNumber: Int {
        let c = Calendar.current.dateComponents(in: TimeZone.current, from: self)
        guard let week = c.weekOfYear else {
            fatalError("Expected date to have a week number.")
        }
        return week
    }
    
    var weekDay: Int {
        return Calendar.current.dateComponents([.weekday], from: self).weekday ?? 0
    }

    var components: DateComponents {
        return Calendar.current.dateComponents(in: TimeZone.current, from: self)
    }
    
    var localDate: Date {
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: self))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: self) else {return Date()}

        return localDate
    }
 
    func daysSince(other day: Date) -> Int {
        let cal = Calendar.current
        let components = cal.dateComponents([.day], from: day, to: self)
        return components.day ?? 0
    }

    func sameDayAs(other day: Date) -> Bool {
        let cal = Calendar.current
        let other = cal.dateComponents([.day, .month, .year], from: day)
        let mine = cal.dateComponents([.day, .month, .year], from: self)
        return mine == other
    }
    
    func isBetween(_ startDate: Date, and endDate: Date) -> Bool {
        return (min(startDate, endDate) ... max(startDate, endDate)).contains(self)
    }
    
    var localized: String {
        let df          = DateFormatter()
        df.dateFormat   = R.string.localizable.managementSemesterPeriodsFormat()
        df.locale       = Locale.current
        return df.string(from: self)
    }
    
    // MARK: - Week Position
    enum Week: Int, CaseIterable {
        case beginn     = 1
        case second     = 2
        case mid        = 3
        case lead       = 4
        case end        = 5
    }
    
    // Get Date specified position of Week
    func dateOfWeek(for weekPosition: Week) -> Date {
        let saturday = Calendar.gregorian.date(from: Calendar.gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        return Calendar.gregorian.date(byAdding: .day, value: weekPosition.rawValue, to: saturday!)!
    }
    
    func dateOfWeek(for weekPosition: UInt) -> Date {
        let saturday = Calendar.gregorian.date(from: Calendar.gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        return Calendar.gregorian.date(byAdding: .day, value: Int(weekPosition), to: saturday!)!
    }
    
    // Get all Dates in Week
    func allDateForWeek() -> [Date] {
        var dates: [Date] = []
        for key in Week.allCases {
            dates.append(dateOfWeek(for: key))
        }
        return dates
    }
    
    // Get all Dates in NextWeek
    func allDateForNextWeek() -> [Date] {
        var dates: [Date] = []
        for i in 8...12 {
           dates.append(dateOfWeek(for: UInt(i)))
        }
        return dates
    }
    
    func localizedDescription(local: Locale = .current, timeZone: TimeZone = .current, dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .none) -> String {
        let formater = DateFormatter().also {
            $0.locale = local
            $0.timeZone = timeZone
            $0.dateStyle = dateStyle
            $0.timeStyle = timeStyle
        }
        return formater.string(from: self)
    }

}
