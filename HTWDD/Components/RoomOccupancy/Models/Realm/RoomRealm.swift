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
    @objc dynamic var numberOfOccupancies: Int  = 0
}

// MARK: - Extensions
extension RoomRealm {
    static func save(room: String, numberOf occupancies: Int) {
        let realm = try! Realm()
        
        let id = room.uid
        let realmModel = realm.objects(RoomRealm.self).filter { $0.id == id }.first ?? RoomRealm()
        
        try! realm.write {
            realm.add(realmModel.also { model in
                model.id                    = id
                model.name                  = room
                model.numberOfOccupancies   = occupancies
            })
        }
    }
    
    static func delete(room: RoomRealm) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(room)
        }
    }
}
