//
//  Examination.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 07.08.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation

struct Examination: Decodable {
    let title: String
    let examType: String
    let studyBranch: String
    let day: String
    let startTime: String
    let endTime: String
    let examiner: String
    let nextChance: String
    let rooms: [String]
    
    enum CodingKeys: String, CodingKey {
        case title          = "Title"
        case examType       = "ExamType"
        case studyBranch    = "StudyBranch"
        case day            = "Day"
        case startTime      = "StartTime"
        case endTime        = "EndTime"
        case examiner       = "Examiner"
        case nextChance     = "NextChance"
        case rooms          = "Rooms"
    }
}
