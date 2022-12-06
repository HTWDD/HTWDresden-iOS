//
//  Notes.swift
//  HTWDD
//
//  Created by Chris Herlemann on 30.12.21.
//  Copyright © 2021 HTW Dresden. All rights reserved.
//

import Foundation

struct Notes: Decodable {
    let timetableNote: String?
    let gradesNote: String?
    let examsNote: String?
    
    enum CodingKeys: String, CodingKey {
        case timetableNote = "timetable"
        case gradesNote = "grades"
        case examsNote = "exams"
        
    }
}
