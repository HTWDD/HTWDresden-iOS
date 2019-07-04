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
import RealmSwift

// MARK: - Semester Planung
struct SemesterPlaning: Codable {
    
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
            Log.error(error)
            return ""
        }
    }
    
    var endDayFormated: String {
        do {
            return try Date.from(string: endDay, format: "yyyy-MM-dd").localized
        } catch {
            Log.error(error)
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
            Log.error(error)
            return ""
        }
    }
    
    var endDayFormated: String {
        do {
            return try Date.from(string: endDay, format: "yyyy-MM-dd").localized
        } catch {
            Log.error(error)
            return ""
        }
    }
}


// MARK: - Extension

extension SemesterPlaning {
    static func map(from object: SemesterPlaningRealm?) -> SemesterPlaning? {
        guard let object = object else { return nil }
        
        return SemesterPlaning(year: object.year,
                               type: SemesterPlaning.SemeterType(rawValue: object.type)!,
                               period: Period.map(from: object.period!),
                               freeDays: FreeDay.map(from: object.freeDays),
                               lecturePeriod:  Period.map(from: object.lecturePeriod!),
                               examsPeriod:  Period.map(from: object.examsPeriod!),
                               reregistration:  Period.map(from: object.examsPeriod!))
    }
}

extension Period {
    static func map(from object: PeriodRealm) -> Period {
        return Period(beginDay: object.beginDay, endDay: object.endDay)
    }
}

extension FreeDay {
    static func map(from objects: List<FreeDayRealm>) -> [FreeDay] {
        return objects.map { convert(from: $0) }
    }
    
    private static func convert(from object: FreeDayRealm) -> FreeDay {
        return FreeDay(name: object.name, beginDay: object.beginDay, endDay: object.endDay)
    }
}
