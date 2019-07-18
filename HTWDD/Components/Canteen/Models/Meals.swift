//
//  Meals.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 10.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation


// MARK: - Meals
struct Meals: Codable {
    let id: Int
    let name: String
    let category: String
    let prices: Prices
    let notes: [String]
}

// MARK: - Prices
struct Prices: Codable {
    let students: Double?
    let employees: Double?
}

// MARK: - Extensions
extension Prices {
    var studentsPrice: String {
        return students.asCurrency
    }
    
    var employeesPrice: String {
        return employees.asCurrency
    }
}
