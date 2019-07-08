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

protocol HasSchedule {
    var scheduleService: ScheduleService { get }
}

protocol HasExams {
	var examsService: ExamsService { get }
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

class AppContext: HasSchedule, HasGrade, HasCanteen, HasExams, HasSettings, HasManagement, HasApiService {
    lazy var scheduleService    = ScheduleService()
	lazy var examsService       = ExamsService()
	lazy var gradeService       = GradeService()
    lazy var canteenService     = CanteenService()
	lazy var settingsService    = SettingsService()
    lazy var managementService  = ManagementService()
    lazy var apiService         = ApiService.shared()
}
