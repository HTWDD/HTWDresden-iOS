//
//  SemesterPlaning.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 21.06.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift
import Marshal

// MARK: - Semester Planung
struct SemesterPlaning: Identifiable, Codable {
    let year: Int
    let type: String
    let period: Period
    let freeDays: [FreeDay]
    let lecturePeriod: Period
    let examsPeriod: Period
    let reregistration: Period
    
    static func get(network: Network) -> Observable<[SemesterPlaning]> {
        return network.getArray(url: SemesterPlaning.url)
    }
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


// MARK: - extensions
extension SemesterPlaning: Unmarshaling {
    static let url = "https://rubu2.rz.htw-dresden.de/API/v0/semesterplan.json"
    
    init(object: MarshaledObject) throws {
        self.year           = try object.value(for: "year")
        self.type           = try object.value(for: "type")
        self.period         = try object.value(for: "period")
        self.freeDays       = try object.value(for: "freeDays")
        self.lecturePeriod  = try object.value(for: "lecturePeriod")
        self.examsPeriod    = try object.value(for: "examsPeriod")
        self.reregistration = try object.value(for: "reregistration")
    }
}


extension Period: ValueType {}
extension FreeDay: ValueType {}
