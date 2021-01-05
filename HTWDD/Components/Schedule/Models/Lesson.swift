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
    let weeksOnly: [Int]
    let professor: String?
    let rooms: [String]
    let lastChanged: String
    
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
    
}

protocol LessonDetailsPickerSelection {
    static var allValues: [LessonDetailsPickerSelection] { get }
    static var caseCount: Int { get }
    var localizedDescription: String { get }
}

// MARK: - Lessontypes
enum LessonType: String, Codable, LessonDetailsPickerSelection {

    static var allValues: [LessonDetailsPickerSelection] { return [practical, lesson, exercise, requested, block, unkown] }
    static var caseCount: Int { return allValues.count }
    
    
    case practical
    case lesson
    case exercise
    case requested
    case block
    case unkown
    
    var localizedDescription: String {
        switch self {
        case .practical: return R.string.localizable.scheduleLectureTypePractical()
        case .lesson: return R.string.localizable.scheduleLectureTypeLecture()
        case .exercise: return R.string.localizable.scheduleLectureTypeExercise()
        case .requested: return R.string.localizable.scheduleLectureTypeRequested()
        case .block: return R.string.localizable.scheduleLectureTypeBlock()
        case .unkown: return R.string.localizable.scheduleLectureTypeUnknown()
        }
    }
    
    var timetableColor: UIColor {
        switch self {
        case .lesson: return UIColor.htw.red_300
        case .exercise: return UIColor.htw.green_300
        case .block: return UIColor.htw.blue_grey_300
        default: return UIColor.htw.indigo_400
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer().decode(String.self)
        
        switch container {
        case let str where str.hasPrefix("V"): self = .lesson
        case let str where str.hasPrefix("Ü"): self = .exercise
        case let str where str.hasPrefix("P"): self = .practical
        case let str where str.hasPrefix("Buchung"): self = .requested
        case let str where str.hasPrefix("Block"): self = .block
        default:
            self = .unkown
        }
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
