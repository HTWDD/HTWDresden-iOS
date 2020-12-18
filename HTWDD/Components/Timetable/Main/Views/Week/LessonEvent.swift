//
//  LessonEvent.swift
//  HTWDD
//
//  Created by Chris Herlemann on 15.12.20.
//  Copyright © 2020 HTW Dresden. All rights reserved.
//

import Foundation
import JZCalendarWeekView

class LessonEvent: JZBaseEvent, Codable {
    
    let lessonTag: String?
    let name: String
    let type: LessonType
    let professor: String?
    let rooms: [String]
    let lastChanged: String
    
//    let day: Int
//    let beginTime: String
//    let endTime: String
//    let week: Int
//    let weeksOnly: [Int]

//
//    init(id: String, title: String, startDate: Date, endDate: Date, location: String) {
//        self.location = location
//        self.title = title
//
//        // If you want to have you custom uid, you can set the parent class's id with your uid or UUID().uuidString (In this case, we just use the base class id)
//        super.init(id: id, startDate: startDate, endDate: endDate)
//    }
//
    required init(from decoder: Decoder) throws {
        
        lessonTag = ""
        name = ""
        type = .lesson
        professor = ""
        rooms = []
        lastChanged = ""
        
        super.init(id: "TEST", startDate: Date(), endDate: Date())
    }

//    override func copy(with zone: NSZone?) -> Any {
//        return LessonEvent(id: id, title: title, startDate: startDate, endDate: endDate, location: location)
//    }
    
    enum LessonType: String, Codable {
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
}
