//
//  TimetableDetailsViewModel.swift
//  HTWDD
//
//  Created by Chris Herlemann on 29.01.21.
//  Copyright © 2021 HTW Dresden. All rights reserved.
//

import RealmSwift

class TimetableDetailsViewModel {
    
    func saveCustomLesson(_ customLesson: CustomLesson) -> Bool {
        
        guard let name = customLesson.name,
              let day = customLesson.day,
              let beginTime = customLesson.beginTime,
              let endTime = customLesson.endTime,
              let week = customLesson.week,
              let weeksOnly = customLesson.weeksOnly
              
        else { return false }
        
        let newLesson: Lesson = Lesson(id: customLesson.id ?? UUID().uuidString,
                               lessonTag: customLesson.lessonTag,
                               name: name,
                               type: customLesson.type ?? .unkown,
                               day: day,
                               beginTime: beginTime,
                               endTime: endTime,
                               week: week,
                               weeksOnly: weeksOnly,
                               professor: customLesson.professor,
                               rooms: [customLesson.rooms ?? " "],
                               lastChanged: Date().localized)
        
        if TimetableRealm.exist(id: newLesson.id) {
            TimetableRealm.update(from: newLesson)
        } else {
            TimetableRealm.save(from: newLesson)
        }
        
        return true
    }
    
    func deleteCustomLesson(lessonId: String) {
        TimetableRealm.delete(ids: [lessonId])
    }
    
    func isCustomLesson(id: String) -> Bool {
        
        return TimetableRealm.exist(id: id)
    }
    
    func hideElectiveLesson(selected lesson: Lesson) {
        
        var hiddenLesson = lesson
        hiddenLesson.isHidden = true
        
        if TimetableRealm.exist(id: hiddenLesson.id) {
            TimetableRealm.update(from: hiddenLesson)
        } else {
            TimetableRealm.save(from: hiddenLesson)
        }
    }
}
