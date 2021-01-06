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
    
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? ExamRealm {
            return id == object.id
        }
        return false
    }
    
}

extension TimetableRealm {
    
    static func read() -> [Lesson] {
        
        let realm = try! Realm()
        
        let searchResultSet = realm.objects(TimetableRealm.self)
        
        guard searchResultSet.count > 0 else { return [] }
        
        var result: [Lesson] = []
        
        searchResultSet.forEach { searchResult in
            
            let newItem : Lesson = Lesson(id: searchResult.id, lessonTag: searchResult.lessonTag, name: searchResult.name, type: LessonType(rawValue: searchResult.type) ?? .unkown, day: searchResult.day, beginTime: searchResult.beginTime, endTime: searchResult.endTime, week: searchResult.week, weeksOnly: searchResult.weeksOnly.toArray(), professor: searchResult.professor, rooms: searchResult.rooms.toArray(), lastChanged: searchResult.lastChanged)
            
            result.append(newItem)
        }
        
        return result
    }
    
    static func save(from codable: Lesson) {
        let realm = try! Realm()
        
        let id = codable.id
        let realmModel = realm.objects(TimetableRealm.self).filter { $0.id == id }.first ?? TimetableRealm()
        try! realm.write {
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
            })
            
        }
    }
    
    static func delete(items: [Lesson]) {
        let realm = try! Realm()
        try! realm.write {
            
            items.forEach { item in
                
                if let realmObject = realm.object(ofType: TimetableRealm.self, forPrimaryKey: item.id) {
                    realm.delete(realmObject)
                }
            }
        }
    }
}
