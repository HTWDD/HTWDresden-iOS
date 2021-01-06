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
    static var empty  = Lesson(id: UUID().uuidString, lessonTag: .none, name: "", type: .unkown, day: 0, beginTime: "", endTime: "", week: 0, weeksOnly: [], professor: .none, rooms: [], lastChanged: "")
    
    var id: String
    var lessonTag: String?
    var name: String
    var type: LessonType
    var day: Int
    var beginTime: String
    var endTime: String
    var week: Int
    var weeksOnly: [Int]
    var professor: String?
    var rooms: [String]
    var lastChanged: String
    
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

enum LessonDetailsOptions {
    case lectureType(selection: LessonType?)
    case weekRotation(selection: CalendarWeekRotation?)
    case weekDay(selection: CalendarWeekDay?)
    case lessonBlock(selection: LessonBlock?)
    
    var count: Int {
        switch self {
        case .lectureType(_): return LessonType.caseCount
        case .weekRotation(_): return CalendarWeekRotation.caseCount
        case .weekDay(_): return CalendarWeekDay.caseCount
        case .lessonBlock(_): return LessonBlock.caseCount
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .lectureType(let selection): return selection?.localizedDescription ?? ""
        case .weekRotation(let selection): return selection?.localizedDescription ?? ""
        case .weekDay(let selection): return selection?.localizedDescription ?? ""
        case .lessonBlock(let selection): return selection?.localizedDescription ?? ""
        }
    }
    
}

enum CalendarWeekRotation: LessonDetailsPickerSelection {
    case notSet
    case everyWeek
    case evenWeeks
    case unevenWeeks
    
    static var allValues: [LessonDetailsPickerSelection] { return [notSet, everyWeek, evenWeeks, unevenWeeks] }
    static var caseCount: Int { return allValues.count }
    
    var localizedDescription: String {
    
        switch self {
        case .notSet: return ""
        case .everyWeek: return R.string.localizable.calendarWeekEvery()
        case .evenWeeks: return R.string.localizable.calendarWeekEven()
        case .unevenWeeks: return R.string.localizable.calendarWeekUneven()
        }
    }
}

enum CalendarWeekDay: LessonDetailsPickerSelection {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    
    static var allValues: [LessonDetailsPickerSelection] { return [monday, tuesday, wednesday, thursday, friday] }
    static var caseCount: Int { return allValues.count }
    
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

enum LessonBlock: LessonDetailsPickerSelection {
    case firstBlock
    case secondBlock
    case thirdBlock
    case fourthBlock
    case fifthBlock
    case sixthBlock
    case seventhBlock
    case eighthBlock
    
    var localizedDescription: String {
    
        switch self {
        case .firstBlock: return R.string.localizable.lessonBlockOne()
        case .secondBlock: return R.string.localizable.lessonBlockTwo()
        case .thirdBlock: return R.string.localizable.lessonBlockThree()
        case .fourthBlock: return R.string.localizable.lessonBlockFour()
        case .fifthBlock: return R.string.localizable.lessonBlockFive()
        case .sixthBlock: return R.string.localizable.lessonBlockSix()
        case .seventhBlock: return R.string.localizable.lessonBlockSeven()
        case .eighthBlock: return R.string.localizable.lessonBlockEight()
        }
    }
    
    static var allValues: [LessonDetailsPickerSelection] { return [firstBlock, secondBlock, thirdBlock, fourthBlock, fifthBlock, sixthBlock, seventhBlock, eighthBlock] }
    static var caseCount: Int { return allValues.count }
    
    static func getLessonBlock(startTime: String, endTime: String) -> LessonBlock? {
        
        if startTime == "07:30", endTime == "09:00" { return .firstBlock }
        if startTime == "09:20", endTime == "10:50" { return .secondBlock }
        if startTime == "11:10", endTime == "12:40" { return .thirdBlock }
        if startTime == "13:20", endTime == "09:00" { return .fourthBlock }
        if startTime == "07:30", endTime == "09:00" { return .fifthBlock }
        if startTime == "07:30", endTime == "09:00" { return .sixthBlock }
        if startTime == "07:30", endTime == "09:00" { return .seventhBlock }
        if startTime == "07:30", endTime == "09:00" { return .eighthBlock }
        
        return .none
    }
}
