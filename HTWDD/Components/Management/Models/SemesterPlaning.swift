//
//  SemesterPlaning.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 21.06.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation

// MARK: - Semester Planung
struct SemesterPlaning: Identifiable, Codable {
    let year: Int
    let type: String
    let period: Period
    let freeDays: [FreeDay]
    let lecturePeriod: Period
    let examsPeriod: Period
    let reregistration: Period
}

// MARK: - Period
struct Period: Codable {
    let beginDay: String
    let endDay: String
}

// MARK: - FreeDay
struct FreeDay: Codable {
    let name: String
    let beginDay: String
    let endDay: String
}
