//
//  Meals.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 10.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation


// MARK: - Meals
struct Meal: Codable {
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
        if let students = students {
             return R.string.localizable.canteenMealPriceStudents(students)
        } else {
            return R.string.localizable.canteenMealPriceNoStudents()
        }
    }
    
    var employeesPrice: String {
        if let  employees = employees {
            return R.string.localizable.canteenMealPriceEmployee(employees)
        } else {
            return R.string.localizable.canteenMealPriceNoEmployee()
        }
    }
}

// MARK: - Equatable
extension Meal: Equatable {
    
    static func ==(lhs: Meal, rhs: Meal) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.prices == rhs.prices
    }
}

extension Prices: Equatable {
    
    static func ==(lhs: Prices, rhs: Prices) -> Bool {
        return lhs.students == rhs.students && lhs.employees == rhs.employees
    }
    
}
