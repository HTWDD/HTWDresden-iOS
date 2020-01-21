//
//  StudentAdministration.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 01.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation

// MARK: - Studen Administration
struct StudentAdministration: Codable {
    let offeredServices: [String]
    let officeHours: [OfficeHour]
    let link: String
}

// MARK: - Office Hour
struct OfficeHour: Codable {
    
    enum DayType: String, Codable {
        case monday     = "Mo"
        case tuesday    = "Di"
        case thursday   = "Do"
        
        var localizedDescription: String {
            switch self {
            case .monday: return R.string.localizable.monday()
            case .tuesday: return R.string.localizable.tuesday()
            case .thursday: return R.string.localizable.thursday()
            }
        }
    }
    
    let day: DayType
    let times: [Time]
}

// MARK: - Office Times
struct Time: Codable {
    let begin: String
    let end: String
}
