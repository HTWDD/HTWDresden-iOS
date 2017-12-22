//
//  Week.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 08/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

enum Week: Int, Codable {
    case all = 0, odd, even

    func validate(weekNumber: Int) -> Bool {
        switch self {
        case .all:
            return true
        case .even:
            return weekNumber % 2 == 0
        case .odd:
            return weekNumber % 2 == 1
        }
    }

    var stringValue: String {
        switch self {
        case .all:
            return Loca.Schedule.Weeks.all
        case .even:
            return Loca.Schedule.Weeks.even
        case .odd:
            return Loca.Schedule.Weeks.odd
        }
    }
}
