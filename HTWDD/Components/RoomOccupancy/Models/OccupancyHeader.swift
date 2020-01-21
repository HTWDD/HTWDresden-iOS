//
//  OccupancyHeader.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 25.09.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation

struct OccupancyHeader {
    let header: Int
    let subheader: String
    
    var localizedHeader: String {
        let localizedDay: String
        switch header {
        case 1: localizedDay = R.string.localizable.monday()
        case 2: localizedDay = R.string.localizable.tuesday()
        case 3: localizedDay = R.string.localizable.wednesday()
        case 4: localizedDay = R.string.localizable.thursday()
        case 5: localizedDay = R.string.localizable.friday()
        case 6: localizedDay = R.string.localizable.saturday()
        case 7: localizedDay = R.string.localizable.sunday()
        default: return ""
        }
        return localizedDay
    }
}
