//
//  TimetableRealm.swift
//  HTWDD
//
//  Created by Chris Herlemann on 05.01.21.
//  Copyright © 2021 HTW Dresden. All rights reserved.
//

import Foundation
import RealmSwift


class TimetableRealm: Object {
    
    @objc dynamic var id: String            = ""
    @objc dynamic var lessonTag: String?    = ""
    @objc dynamic var name: String          = ""
    @objc dynamic var type: String          = ""
    @objc dynamic var day: Int              = 0
    @objc dynamic var beginTime: String     = ""
    @objc dynamic var endTime: String       = ""
    @objc dynamic var week: Int             = 0
    let weeksOnly: List<Int>                = List<Int>()
    @objc dynamic var professor: String?    = ""
    let rooms: List<String>   = List<String>()
    @objc dynamic var lastChanged: String   = ""
    @objc dynamic var isHidden: Bool        = false
    
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? ExamRealm {
            return id == object.id
        }
        return false
    }
    
    override static func primaryKey() -> String? {
      return "id"
    }
    
}

extension TimetableRealm {
    
    static func read() -> [Lesson] {
        
        let realm = try! Realm()
        
        let searchResultSet = realm.objects(TimetableRealm.self)
        
        guard searchResultSet.count > 0 else { return [] }
        
        var result: [Lesson] = []
        
        searchResultSet.forEach { searchResult in
            
            let newItem : Lesson = Lesson(id: searchResult.id, lessonTag: searchResult.lessonTag, name: searchResult.name, type: LessonType(rawValue: searchResult.type) ?? .unkown, day: searchResult.day, beginTime: searchResult.beginTime, endTime: searchResult.endTime, week: searchResult.week, weeksOnly: searchResult.weeksOnly.toArray(), professor: searchResult.professor, rooms: searchResult.rooms.toArray(), lastChanged: searchResult.lastChanged, isHidden: searchResult.isHidden)
            
            result.append(newItem)
        }
        
        return result
    }
    
    static func save(from codable: Lesson) {
        let realm = try! Realm()
        print("TEST FUCK!")
        let id = codable.id
        let realmModel = realm.objects(TimetableRealm.self).filter { $0.id == id }.first ?? TimetableRealm()
        try! realm.write {
            print("Fuck this")
            realm.add(realmModel.also { model in
                model.id            = id
                model.lessonTag     = codable.lessonTag
                model.name          = codable.name
                model.type          = codable.type.rawValue
                model.day           = codable.day
                model.beginTime     = codable.beginTime
                model.endTime       = codable.endTime
                model.week          = codable.week
                codable.weeksOnly.forEach{ week in model.weeksOnly.append(week) }
                model.professor     = codable.professor
                codable.rooms.forEach{room in model.rooms.append(room) }
                model.lastChanged   = codable.lastChanged
                model.isHidden      = codable.isHidden ?? false
            })
            
        }
    }
    
    static func update(from codable: Lesson) {
        
        let realm = try! Realm()
        let objects = realm.objects(TimetableRealm.self).filter("id = %@", codable.id)

        if let object = objects.first {
            try! realm.write {
                object.setValue(codable.lessonTag, forKey: "lessonTag")
                object.setValue(codable.name, forKey: "name")
                object.setValue(codable.type.rawValue, forKey: "type")
                object.setValue(codable.day, forKey: "day")
                object.setValue(codable.beginTime, forKey: "beginTime")
                object.setValue(codable.endTime, forKey: "endTime")
                object.setValue(codable.week, forKey: "week")
                object.weeksOnly.removeAll()
                codable.weeksOnly.forEach{ week in object.weeksOnly.append(week) }
                object.setValue(codable.professor, forKey: "professor")
                object.rooms.removeAll()
                codable.rooms.forEach{room in object.rooms.append(room) }
                object.setValue(codable.lastChanged, forKey: "lastChanged")
                object.setValue(codable.isHidden, forKey: "isHidden")
            }
        }
    }
    
    static func exist(id: String) -> Bool {
        let realm = try! Realm()
        let objects = realm.objects(TimetableRealm.self).filter("id = %@", id)
        
        return objects.first != .none
    }
    
    static func delete(ids: [String]) {
        let realm = try! Realm()
        try! realm.write {
            
            ids.forEach { id in
                
                if let realmObject = realm.object(ofType: TimetableRealm.self, forPrimaryKey: id) {
                    realm.delete(realmObject)
                }
            }
        }
    }
}
