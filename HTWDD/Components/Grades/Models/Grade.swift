//
//  Grade.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 27.09.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation

// MARK: - Codable
struct Grade: Codable {
    let tries: Int
    let remark: Remark?
    let examNumber: Int
    let examDate: String?
    let typeOfExamination: String
    let credits: Double
    let grade: Int?
    let semester: Int
    let examination: String
    let state: State
    let id: Int
    
    // MARK: - Coding-Keys
    enum CodingKeys: String, CodingKey {
        case tries              = "tries"
        case remark             = "note"
        case examNumber         = "nr"
        case examDate           = "examDate"
        case typeOfExamination  = "form"
        case credits            = "credits"
        case grade              = "grade"
        case semester           = "semester"
        case examination        = "text"
        case state              = "state"
        case id                 = "id"
    }
    
    // MARK: - State
    enum State: String, Codable {
        case enrolled       = "AN"
        case passed         = "BE"
        case failed         = "NB"
        case finalFailed    = "EN"
        case unkown
        
        var localizedDescription: String {
            switch self {
            case .enrolled: return R.string.localizable.gradesStatusSignedUp()
            case .passed: return R.string.localizable.gradesStatusPassed()
            case .failed: return R.string.localizable.gradesStatusFailed()
            case .finalFailed: return R.string.localizable.gradesStatusUltimatelyFailed()
            default: return R.string.localizable.scheduleLectureTypeUnknown()
            }
        }
    }
    
    enum Remark: String, Codable {
        case recognised             = "a"
        case unsubscribed           = "e"
        case blocked                = "g"
        case ill                    = "k"
        case notPermitted           = "nz"
        case missedWithoutExcuse    = "5ue"
        case notEntered             = "5na"
        case notSecondRequested     = "kA"
        case freeTrail              = "PFV"
        case successfully           = "mE"
        case failed                 = "N"
        case prepraticalOpen        = "VPo"
        case volutaryDateNotMet     = "f"
        case conditionally          = "uV"
        case cheated                = "TA"
        case unkown
        
        var localizedDescription: String {
            switch self {
            case .recognised:
                return R.string.localizable.gradesRemarkRecognized()
            case .unsubscribed:
                return R.string.localizable.gradesRemarkSignOff()
            case .blocked:
                return R.string.localizable.gradesRemarkBlocked()
            case .ill:
                return R.string.localizable.gradesRemarkIll()
            case .notPermitted:
                return R.string.localizable.gradesRemarkNotAllowed()
            case .missedWithoutExcuse:
                return R.string.localizable.gradesRemarkUnexcusedMissing()
            case .notEntered:
                return R.string.localizable.gradesRemarkNotStarted()
            case .notSecondRequested:
                return R.string.localizable.gradesRemarkNoRetest()
            case .freeTrail:
                return R.string.localizable.gradesRemarkFreeTry()
            case .successfully:
                return R.string.localizable.gradesRemarkWithSuccess()
            case .failed:
                return R.string.localizable.gradesRemarkFailed()
            case .prepraticalOpen:
                return R.string.localizable.gradesRemarkPrePlacement()
            case .volutaryDateNotMet:
                return R.string.localizable.gradesRemarkVoluntaryAppointment()
            case .conditionally:
                return R.string.localizable.gradesRemarkConditional()
            case .cheated:
                return R.string.localizable.gradesRemarkAttempt()
            default:
                return R.string.localizable.gradesRemarkUnkown()
            }
        }
    }
}

// MARK: - Equatable
extension Grade: Equatable {
    
    static func ==(lhs: Grade, rhs: Grade) -> Bool {
        return lhs.id == rhs.id
            && lhs.tries == rhs.tries
            && lhs.examNumber == rhs.examNumber
            && lhs.credits == rhs.credits
            && lhs.state == rhs.state
    }
    
}

// MARK: - Comparable
extension Grade: Comparable {
    
    static func < (lhs: Grade, rhs: Grade) -> Bool {
        guard let lhsDate = lhs.examDate else { return false }
        guard let rhsDate = rhs.examDate else { return false }
        return lhsDate < rhsDate
    }
    
}
