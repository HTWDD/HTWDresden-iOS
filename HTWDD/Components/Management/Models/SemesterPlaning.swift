//
//  SemesterPlaning.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 21.06.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift
import Moya

// MARK: - Semester Planung
struct SemesterPlaning: Identifiable, Codable {
    
    fileprivate static var bag = DisposeBag()
    
    // MARK: - Semester Type
    enum SemeterType: String, Codable {
        case summer = "S"
        case winter = "W"
        
        var localizedDescription: String {
            switch self {
            case .summer: return Loca.Management.Semester.summer
            case .winter: return Loca.Management.Semester.winter
            }
        }
    }
    
    // MARK: - Properties
    let year: Int
    let type: SemeterType
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
    
    // MARK: - Formated Dates
    var beginDayFormated: String {
        do {
            return try Date.from(string: beginDay, format: "yyyy-MM-dd").localized
        } catch {
            return ""
        }
    }
    
    var endDayFormated: String {
        do {
            return try Date.from(string: endDay, format: "yyyy-MM-dd").localized
        } catch {
            return ""
        }
    }
}

// MARK: - FreeDay
struct FreeDay: Codable {
    let name: String
    let beginDay: String
    let endDay: String
    
    // MARK: - Formated Dates
    var beginDayFormated: String {
        do {
            return try Date.from(string: beginDay, format: "yyyy-MM-dd").localized
        } catch {
            return ""
        }
    }
    
    var endDayFormated: String {
        do {
            return try Date.from(string: endDay, format: "yyyy-MM-dd").localized
        } catch {
            return ""
        }
    }
}

// MARK: - extensions
extension SemesterPlaning {
    static let url = "https://rubu2.rz.htw-dresden.de/API/v0/semesterplan.json"
}
