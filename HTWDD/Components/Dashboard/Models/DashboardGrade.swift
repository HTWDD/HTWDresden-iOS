//
//  DashboardGrade.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 30.09.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation

struct DashboardGrade {
    
    let grades: Int
    let credits: Double
    let lastGrade: Grade?
    
    var gradesLocalized: String {
        return R.string.localizable.gradesNumbersPlural(grades)
    }
    
    var creditsLocalized: String {
        return R.string.localizable.gradesCreditsNumberPlural(credits)
    }
}
