//
//  Lesson.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 22.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation

struct Lesson: Codable {
    static let  customLessonPrefix: String = "custom_"
    
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
        type.isElective
    }
    
    var isCustom: Bool {
        id.hasPrefix(Lesson.customLessonPrefix)
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
