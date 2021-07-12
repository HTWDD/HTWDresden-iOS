//
//  LessonAttributes.swift
//  HTWDD
//
//  Created by Chris Herlemann on 12.07.21.
//  Copyright © 2021 HTW Dresden. All rights reserved.
//

import UIKit

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
