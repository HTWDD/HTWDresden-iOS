//
//  SemesterPlaningRealm.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 03.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: Semesterplaning
class SemesterPlaningRealm: Object {
    @objc dynamic var id: String                    = ""
    @objc dynamic var year: Int                     = 0
    @objc dynamic var type: String                  = ""
    @objc dynamic var period: PeriodRealm?
    let freeDays = List<FreeDayRealm>()
    @objc dynamic var lecturePeriod: PeriodRealm?
    @objc dynamic var examsPeriod: PeriodRealm?
    @objc dynamic var reregistration: PeriodRealm?
}

// MARK: - Period
class PeriodRealm: Object {
    @objc dynamic var id: String        = ""
    @objc dynamic var beginDay: String  = ""
    @objc dynamic var endDay: String    = ""
}

// MARK: - Freeday
class FreeDayRealm: Object {
    @objc dynamic var id: String        = ""
    @objc dynamic var name: String      = ""
    @objc dynamic var beginDay: String  = ""
    @objc dynamic var endDay: String    = ""
}

// MARK: Extensions
extension SemesterPlaningRealm {
    static func save(from codable: SemesterPlaning?) {
        guard let codable = codable else { return }
        
        let realm = try! Realm()
        
        let semesterPlaningId = "\(codable.year) \(codable.type)".uid
        let semesterPlaningRealm = realm.objects(SemesterPlaningRealm.self).filter { $0.id == semesterPlaningId }.first ?? SemesterPlaningRealm()
        
        try! realm.write {
            
            // Semesterplaning obj data setting
            realm.add(semesterPlaningRealm.also { model in
                model.id   = semesterPlaningId
                model.year = codable.year
                model.type = codable.type.rawValue
                
                // Period Semesterplaning
                model.period = PeriodRealm.map(from: codable.period)
                
                // Free Days
                codable.freeDays.forEach { freeDay in
                    model.freeDays.append(FreeDayRealm.map(from: freeDay))
                }
                
                // Lecture Period
                model.lecturePeriod = PeriodRealm.map(from: codable.lecturePeriod)
                
                // Exams Period
                model.examsPeriod = PeriodRealm.map(from: codable.examsPeriod)
                
                // Re-Registration Period
                model.reregistration = PeriodRealm.map(from: codable.reregistration)
            })
        }
    }
}

extension PeriodRealm {
    fileprivate static func map(from codable: Period) -> PeriodRealm {

        let realm = try! Realm()
        
        let id = "\(codable.beginDay) \(codable.endDay)".uid
        let realmModel = realm.objects(PeriodRealm.self).filter { $0.id == id }.first ?? PeriodRealm()
        
        return realmModel.also {
            $0.id       = id
            $0.beginDay = codable.beginDay
            $0.endDay   = codable.endDay
        }
    }
}

extension FreeDayRealm {
    
    fileprivate static func map(from codable: FreeDay) -> FreeDayRealm {
        
        let realm = try! Realm()
        
        let id = "\(codable.name) \(codable.beginDay) \(codable.endDay)".uid
        let realmModel = realm.objects(FreeDayRealm.self).filter { $0.id == id }.first ?? FreeDayRealm()
        
        return realmModel.also {
            $0.id       = id
            $0.name     = codable.name
            $0.beginDay = codable.beginDay
            $0.endDay   = codable.endDay
        }
    }
    
}
