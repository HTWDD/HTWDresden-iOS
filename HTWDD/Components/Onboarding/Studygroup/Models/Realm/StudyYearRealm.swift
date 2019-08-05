//
//  StudyYearRealm.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 05.08.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import RealmSwift

class StudyYearRealm: Object {
    
    @objc dynamic var year: Int     = 0
    @objc dynamic var major: String = ""
    @objc dynamic var group: String = ""

}


// MARK: - Extensions
extension StudyYearRealm {
    
    static func save(year: Int?, major: String?, group: String?) {
        guard let year = year, let major = major, let group = group else { return }
        let realm = try! Realm()
        let realmModel = realm.objects(StudyYearRealm.self).first ?? StudyYearRealm()
        try! realm.write {
            realm.add(realmModel.also { model in
                model.year  = year
                model.major = major
                model.group = group
            })
        }
    }
    
    static func clear() {
        let realm = try! Realm()
        if let realmModel = realm.objects(StudyYearRealm.self).first {
            try! realm.write {
                realm.delete(realmModel)
            }
        }
    }
    
}
