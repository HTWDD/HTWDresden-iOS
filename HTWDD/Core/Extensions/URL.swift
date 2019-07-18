//
//  URL.swift
//  HTWDD
//
//  Created by martin on 02.05.18.
//  Copyright © 2018 HTW Dresden. All rights reserved.
//

import Foundation

enum CoordinatorRoute {
    case schedule
    case scheduleToday
    case exams
    case grades
    case canteen
    case meals(canteenDetail: CanteenDetails)
    case settings
    case management
}

extension CoordinatorRoute {
    typealias RawValue = String
    
    init?(rawValue: RawValue) {
        switch rawValue {
        case "schedule": self = .schedule
        case "scheduleToday": self = .scheduleToday
        case "exams": self = .exams
        case "grades": self = .grades
        case "canteen": self = .canteen
        case "meals": self = .meals(canteenDetail: CanteenDetails(canteen:  Canteens(id: 0, name: "", address: "", coordinates: [0, 0]), meals: []))
        case "settings": self = .settings
        case "management": self = .management
        default:
            return nil
        }
    }
    
    public var rawValue: RawValue {
        switch self {
        case .schedule: return "schedule"
        case .scheduleToday: return "scheduleToday"
        case .exams: return "exams"
        case .grades: return "grades"
        case .canteen: return "canteen"
        case .meals(_): return "meals"
        case .settings: return "settings"
        case .management: return "management"
        }
    }
}

extension HTWNamespace where Base == URL {
    static var schemePrefix: String {
        return "htwdd://"
    }
    
    static func route(`for` host: CoordinatorRoute) -> URL? {
        return URL(string: URL.htw.schemePrefix + host.rawValue)
    }
}
