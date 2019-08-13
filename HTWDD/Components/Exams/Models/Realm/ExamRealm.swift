//
//  ExaminationRealm.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 08.08.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import RealmSwift

class ExamRealm: Object {
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

// MARK: - Handling
extension ExamRealm {
    
    static func save(from codables: [Exam]) {
        let realm = try! Realm()
        codables.forEach { codable in
            let id = "\(codable.title):\(codable.examType)".uid
            let realmModel = realm.objects(ExamRealm.self).filter { $0.id == id }.first ?? ExamRealm()
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
    
    static func clear() {
        let realm = try! Realm()
        try! realm.write {
            let content = realm.objects(ExamRealm.self)
            realm.delete(content)
        }
    }
}
