//
//  GradeAverage.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 29.09.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation

struct GradeAverage {
    let average: Double
    let credits: Double
    
    var localizedAverage: String {
        return R.string.localizable.gradesAverage(average)
    }
    
    var localizedCredits: String {
        return R.string.localizable.gradesDetailCredits(credits)
    }
}
