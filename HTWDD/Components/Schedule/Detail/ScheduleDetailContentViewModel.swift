//
//  ScheduleDetailContentViewModel.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 30.09.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

class ScheduleDetailContentViewModel {

    private let lecture: Lecture

	init(lecture: Lecture) {
		self.lecture = lecture
	}
	
	var type: String {
		return self.lecture.type
	}
	
	var tag: String {
		return self.lecture.tag ?? ""
	}
	
	var title: String {
		return self.lecture.name
	}
	
	var rooms: [String] {
		return self.lecture.rooms
	}
	
	var begin: DateComponents {
		return self.lecture.begin
	}
	
	var end: DateComponents {
		return self.lecture.end
	}
	
	var professor: String? {
		return self.lecture.professor
	}
	
	var day: Day {
		return self.lecture.day
	}
	
	var week: Week {
		return self.lecture.week
	}

}
