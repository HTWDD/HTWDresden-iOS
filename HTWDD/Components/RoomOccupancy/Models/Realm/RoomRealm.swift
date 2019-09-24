//
//  RoomRealm.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 25.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - Rooms
class RoomRealm: Object {
    @objc dynamic var id: String                = ""
    @objc dynamic var name: String              = ""
    let occupancies = List<OccupancyRealm>()
    
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? RoomRealm {
            return id == object.id
        }
        return false
    }
}

// MARK: - Occupancy
class OccupancyRealm: Object {
    @objc dynamic var id: String            = ""
    @objc dynamic var name: String          = ""
    @objc dynamic var type: String          = ""
    @objc dynamic var day: Int              = 0
    @objc dynamic var beginTime: String     = ""
    @objc dynamic var endTime: String       = ""
    @objc dynamic var week: Int             = 0
    @objc dynamic var professor: String     = ""
    @objc dynamic var weeksOnly: String     = ""
    
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? OccupancyRealm {
            return id == object.id
        }
        return false
    }
}

// MARK: - Extensions
extension RoomRealm {
    static func save(room: String, lessons: [Lesson]) {
        let realm = try! Realm()
        
        let id = room.uid
        let realmModel = realm.objects(RoomRealm.self).filter { $0.id == id }.first ?? RoomRealm()
        
        try! realm.write {
            realm.add(realmModel.also { model in
                model.id                    = id
                model.name                  = room
                
                model.occupancies.removeAll()
                lessons.forEach { lesson in
                    model.occupancies.append(OccupancyRealm.map(from: lesson))
                }
            })
        }
    }
    
    static func delete(room: RoomRealm) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(room)
        }
    }
    
    static func clear() {
        let realm = try! Realm()
        try! realm.write {
            let content = realm.objects(RoomRealm.self)
            realm.delete(content)
        }
    }
}


extension OccupancyRealm {
    
    static func map(from codable: Lesson) -> OccupancyRealm {
        let realm       = try! Realm()
        let id          = codable.id.uid
        let realmModel  = realm.objects(OccupancyRealm.self).filter { $0.id == id }.first ?? OccupancyRealm()
        return realmModel.also { model in
            model.id           = id
            model.name         = codable.name
            model.type         = codable.type.localizedDescription
            model.day          = codable.day
            model.beginTime    = codable.beginTime
            model.endTime      = codable.endTime
            model.week         = codable.week
            model.professor    = codable.professor ?? ""
            model.weeksOnly    = codable.weeksOnly.description
        }
    }
    
}
