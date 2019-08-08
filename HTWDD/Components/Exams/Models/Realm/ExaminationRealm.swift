//
//  ExaminationRealm.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 08.08.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import RealmSwift

class ExaminationRealm: Object {
    @objc dynamic var id: String            = ""
    @objc dynamic var title: String         = ""
    @objc dynamic var examType: String      = ""
    @objc dynamic var studyBranch: String   = ""
    @objc dynamic var day: String           = ""
    @objc dynamic var startTime: String     = ""
    @objc dynamic var endTime: String       = ""
    @objc dynamic var examiner: String      = ""
    @objc dynamic var nextChance: String    = ""
    @objc dynamic var rooms: String         = ""
}

// MARK: - Save from Codable
extension ExaminationRealm {
    
    static func save(from codables: [Examination]) {
        let realm = try! Realm()
        codables.forEach { codable in
            let id = "\(codable.title):\(codable.examType)".uid
            let realmModel = realm.objects(ExaminationRealm.self).filter { $0.id == id }.first ?? ExaminationRealm()
            try! realm.write {
                realm.add(realmModel.also { model in
                    model.id            = id
                    model.title         = codable.title
                    model.examType      = codable.examType
                    model.studyBranch   = codable.studyBranch
                    model.day           = codable.day
                    model.startTime     = codable.startTime
                    model.endTime       = codable.endTime
                    model.examiner      = codable.examiner
                    model.nextChance    = codable.nextChance
                    model.rooms         = codable.rooms.description
                })
                
            }
        }
    }
    
}
