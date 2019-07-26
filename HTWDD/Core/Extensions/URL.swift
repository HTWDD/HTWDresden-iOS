//
//  URL.swift
//  HTWDD
//
//  Created by martin on 02.05.18.
//  Copyright © 2018 HTW Dresden. All rights reserved.
//

import Foundation

enum CoordinatorRoute {
    case dashboard
    case schedule
    case scheduleToday
    case roomOccupancy
    case exams
    case grades
    case canteen
    case meal(canteenDetail: CanteenDetail)
    case settings
    case management
}

extension CoordinatorRoute {
    typealias RawValue = String
    
    init?(rawValue: RawValue) {
        switch rawValue {
        case "dashboard": self  = .dashboard
        case "schedule": self = .schedule
        case "roomOccupancy": self = .roomOccupancy
        case "scheduleToday": self = .scheduleToday
        case "exams": self = .exams
        case "grades": self = .grades
        case "canteen": self = .canteen
        case "meal": self = .meal(canteenDetail: CanteenDetail(canteen:  Canteen(id: 0, name: "", address: "", coordinates: [0, 0]), meals: []))
        case "settings": self = .settings
        case "management": self = .management
        default:
            return nil
        }
    }
    
    public var rawValue: RawValue {
        switch self {
        case .dashboard: return "dashboard"
        case .schedule: return "schedule"
        case .roomOccupancy: return "roomOccupancy"
        case .scheduleToday: return "scheduleToday"
        case .exams: return "exams"
        case .grades: return "grades"
        case .canteen: return "canteen"
        case .meal(_): return "meal"
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
