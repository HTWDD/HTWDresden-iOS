//
//  Course.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04/01/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

// MARK: Codable
struct Course: Codable {
    let graduation: String
    let examinationRegulations: Int
    let graduationNumber: String
    let majorNumber: String
    let major: String

    enum CodingKeys: String, CodingKey {
        case graduation             = "AbschlTxt"
        case examinationRegulations = "POVersion"
        case graduationNumber       = "AbschlNr"
        case majorNumber            = "StgNr"
        case major                  = "StgTxt"
    }
}

// MARK: - Equatable
extension Course: Equatable {
    static func ==(lhs: Course, rhs: Course) -> Bool {
        return lhs.graduation == rhs.graduation
            && lhs.examinationRegulations == rhs.examinationRegulations
            && lhs.graduationNumber == rhs.graduationNumber
            && lhs.majorNumber == rhs.majorNumber
            && lhs.major == rhs.major
    }
}
