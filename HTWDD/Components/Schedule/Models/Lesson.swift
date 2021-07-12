//
//  Lesson.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 22.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import UIKit

struct Lesson: Codable {
    let id: String
    let lessonTag: String?
    let name: String
    let type: LessonType
    let day: Int
    let beginTime: String
    let endTime: String
    let week: Int
    var weeksOnly: [Int]
    let professor: String?
    let rooms: [String]
    let lastChanged: String
    var isStudiesIntegrale: Bool?
    var isHidden: Bool? = false
    
    var isElective: Bool {
        type == .electiveLesson || type == .electiveExercise || type == .electivePractical
    }
    
    var lessonDays: [String] {
        let date = Date()
        var lastWeek    = Calendar.current.component(.weekOfYear, from: date)
        var year        = Calendar.current.component(.year, from: date)
        let diffWeeks   = zip(weeksOnly.dropFirst(), weeksOnly).map(-).filter({ $0 < 0 })
        return weeksOnly.map { week -> String in
            if (diffWeeks.count > 0) {
                if (lastWeek - week) < -10 {
                    year -= 1
                } else if (lastWeek - week) >= abs(diffWeeks.first!) {
                    year += 1
                }
            }
            let component = DateComponents(weekday: (day % 7) + 1, weekOfYear: week, yearForWeekOfYear: year)
            lastWeek = week
            return Calendar.current.date(from: component)!.string(format: "dd.MM.yyyy")
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case lessonTag
        case name
        case type
        case day
        case beginTime
        case endTime
        case week
        case weeksOnly
        case professor
        case rooms
        case lastChanged
        case isStudiesIntegrale = "studiumIntegrale"
        case isHidden
    }
}

// MARK: - Hashable
extension Lesson: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id.hashValue ^ lessonTag.hashValue ^ day.hashValue ^ week.hashValue)
    }
    
    static func ==(lhs: Lesson, rhs: Lesson) -> Bool {
        return lhs.id == rhs.id
            && lhs.lessonTag == rhs.lessonTag
            && lhs.day == rhs.day
            && lhs.week == rhs.week
    }
    
}

struct CustomLesson {
    var id: String?
    var lessonTag: String?
    var name: String?
    var type: LessonType?
    var day: Int?
    var week: Int?
    var beginTime: String?
    var endTime: String?
    var weeksOnly: [Int]?
    var professor: String?
    var rooms: String?
    var lastChanged: String?
    var ishidden: Bool? = false
}

protocol LessonDetailsPickerSelection: CaseIterable {
    var localizedDescription: String { get }
}

// MARK: - Lessontypes
enum LessonType: String, Codable, LessonDetailsPickerSelection {
    case practical
    case electivePractical
    case lesson
    case electiveLesson
    case exercise
    case electiveExercise
    case requested
    case block
    case unkown
    
    var localizedDescription: String {
        switch self {
        case .practical, .electivePractical: return R.string.localizable.scheduleLectureTypePractical()
        case .lesson, .electiveLesson: return R.string.localizable.scheduleLectureTypeLecture()
        case .exercise, .electiveExercise: return R.string.localizable.scheduleLectureTypeExercise()
        case .requested: return R.string.localizable.scheduleLectureTypeRequested()
        case .block: return R.string.localizable.scheduleLectureTypeBlock()
        case .unkown: return R.string.localizable.scheduleLectureTypeUnknown()
        }
    }
    
    var timetableColor: UIColor {
        switch self {
        case .lesson, .electiveLesson: return UIColor.htw.red_300
        case .exercise, .electiveExercise: return UIColor.htw.green_300
        case .block: return UIColor.htw.blue_grey_300
        default: return UIColor.htw.indigo_400
        }
    }
    
    static var allCases: [LessonType] = [.lesson, .practical, .exercise, requested, .block]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer().decode(String.self)
        
        switch container {
        case let str where str.hasPrefix("V"):
            if str.contains("(w)") {
                self = .electiveLesson
            } else {
                self = .lesson
            }
            
        case let str where str.hasPrefix("Ü"):
            if str.contains("(w)") {
                self = .electiveExercise
            } else {
                self = .exercise
            }
            
        case let str where str.hasPrefix("P"):
            if str.contains("(w)") {
                self = .electivePractical
            } else {
                self = .practical
            }
        case let str where str.hasPrefix("Buchung"):
            self = .requested
        case let str where str.hasPrefix("Block"):
            self = .block
        default:
            self = .unkown
        }
    }
}

enum LessonDetailsOptions {
    case lectureType(selection: LessonType?)
    case weekRotation(selection: CalendarWeekRotation?)
    case weekDay(selection: CalendarWeekDay?)
    
    var count: Int {
        switch self {
        case .lectureType(_): return LessonType.allCases.count
        case .weekRotation(_): return CalendarWeekRotation.allCases.count
        case .weekDay(_): return CalendarWeekDay.allCases.count
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .lectureType(let selection): return selection?.localizedDescription ?? ""
        case .weekRotation(let selection): return selection?.localizedDescription ?? ""
        case .weekDay(let selection): return selection?.localizedDescription ?? ""
        }
    }
    
}

enum CalendarWeekRotation: Int, LessonDetailsPickerSelection {
    case once = 1
    case everyWeek = 2
    case evenWeeks = 3
    case unevenWeeks = 4
    
    var localizedDescription: String {
    
        switch self {
        case .once: return R.string.localizable.calendarWeekOnce()
        case .everyWeek: return R.string.localizable.calendarWeekEvery()
        case .evenWeeks: return R.string.localizable.calendarWeekEven()
        case .unevenWeeks: return R.string.localizable.calendarWeekUneven()
        }
    }
}

enum CalendarWeekDay: Int, LessonDetailsPickerSelection {
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    
    var localizedDescription: String {
        
        switch self {
        case .monday: return R.string.localizable.monday()
        case .tuesday: return R.string.localizable.tuesday()
        case .wednesday: return R.string.localizable.wednesday()
        case .thursday: return R.string.localizable.thursday()
        case .friday: return R.string.localizable.friday()
        }
    }
}
