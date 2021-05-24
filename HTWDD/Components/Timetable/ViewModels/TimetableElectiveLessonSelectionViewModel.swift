//
//  TimetableElectiveLessonSelectionViewModel.swift
//  HTWDD
//
//  Created by Chris Herlemann on 18.05.21.
//  Copyright © 2021 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

class TimetableElectiveLessonSelectionViewModel {
    
    private let context: HasTimetable
    
    init(context: HasTimetable) {
        self.context = context
    }
    
    func loadElectiveLessons() -> Observable<[Lesson]> {
        return context
            .timetableService.requestElectiveLessons()
            .map { $0.sorted(by: { a, b in a.name < b.name }) }
    }
    
    func saveElectiveLesson(selected lesson: Lesson) {
        if TimetableRealm.exist(id: lesson.id) {
            TimetableRealm.update(from: lesson)
        } else {
            TimetableRealm.save(from: lesson)
        }
    }
}
