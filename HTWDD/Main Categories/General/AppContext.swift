//
//  AppContext.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 17.09.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

class User {
    
}

protocol HasDashboard {
    var dashboardService: DashboardService { get }
}

protocol HasSchedule {
    var scheduleService: ScheduleService { get }
}

protocol HasRoomOccupancy {
    var roomOccupanyService: RoomOccupancyService { get }
}

protocol HasExam {
    var examService: ExamService { get }
}

protocol HasGrade {
    var gradeService: GradeService { get }
}

protocol HasCanteen {
    var canteenService: CanteenService { get }
}

protocol HasSettings {
	var settingsService: SettingsService { get }
}

protocol HasManagement {
    var managementService: ManagementService { get }
}

protocol HasApiService {
    var apiService: ApiService { get }
}

protocol HasTimetable {
    var timetableService: TimetableService { get }
}

class AppContext: HasSchedule, HasGrade, HasCanteen, HasExam, HasSettings, HasManagement, HasApiService, HasDashboard, HasRoomOccupancy, HasTimetable {
    lazy var dashboardService       = DashboardService(apiService: self.apiService, scheduleService: self.scheduleService)
    lazy var scheduleService        = ScheduleService()
    lazy var roomOccupanyService    = RoomOccupancyService(apiService: self.apiService)
	lazy var examService            = ExamService(apiService: self.apiService)
    lazy var gradeService           = GradeService(apiService: self.apiService)
    lazy var canteenService         = CanteenService(apiService: self.apiService)
	lazy var settingsService        = SettingsService()
    lazy var apiService             = ApiService.shared()
    lazy var managementService      = ManagementService(apiService: self.apiService)
    lazy var timetableService       = TimetableService(apiService: self.apiService)
}

