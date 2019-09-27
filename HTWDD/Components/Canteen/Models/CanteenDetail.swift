//
//  CanteenDetails.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 11.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation

// MARK: - Canteen Details
struct CanteenDetail {
    let canteen: Canteen
    let meals: [Meal]
}

// MARK: - Equatable
extension CanteenDetail: Equatable {
    
    static func ==(lhs: CanteenDetail, rhs: CanteenDetail) -> Bool {
        return lhs.canteen == rhs.canteen && lhs.meals == rhs.meals
    }
    
}
