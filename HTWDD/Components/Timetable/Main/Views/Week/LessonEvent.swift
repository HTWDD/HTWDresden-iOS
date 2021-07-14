//
//  LessonEvent.swift
//  HTWDD
//
//  Created by Chris Herlemann on 15.12.20.
//  Copyright © 2020 HTW Dresden. All rights reserved.
//

import Foundation
import JZCalendarWeekView

class LessonEvent: JZBaseEvent {
    
    var lesson: Lesson
    
    init(id: String, lesson: Lesson, startDate: Date, endDate: Date) {
        self.lesson = lesson
        
        super.init(id: id, startDate: startDate, endDate: endDate)
    }
    
    override func copy(with zone: NSZone?) -> Any {
        return LessonEvent(id: id, lesson: lesson, startDate: startDate, endDate: endDate)
    }
}
