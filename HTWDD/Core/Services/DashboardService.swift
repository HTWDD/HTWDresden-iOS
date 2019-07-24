//
//  DashboardService.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 18.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

// MARK: - Item Types
enum DashboardItem {
    case meal(model: Meal)
    case lesson(model: Lesson?)
    case grade(models: [GradeService.Information])
    
    var meal: Meal? {
        switch self {
        case .meal(let model): return model
        default: return nil
        }
    }
}

class DashboardService: Service {
    
    // MARK: - Properties
    private var apiService: ApiService
    private var scheduleService: ScheduleService
    private let persistanceService = PersistenceService()
    
    // MARK: - Lifecycle
    init(apiService: ApiService, scheduleService: ScheduleService) {
        self.apiService         = apiService
        self.scheduleService    = scheduleService
    }
    
    func load(parameters: ()) -> Observable<()> {
        return Observable.empty()
    }
    
    func loadMealFor(canteen id: Int = 80) -> Single<[DashboardItem]> {
        return apiService.requestMeals(for: id, and: Date().string(format: "yyyy-MM-dd"))
            .map { $0.map( { DashboardItem.meal(model: $0) } ) }
    }
    
    func loadTimeTable() -> Single<[Lesson]> {
        if let auth = scheduleService.auth {
            return apiService
                .requestLessons(for: auth.year, major: auth.major, group: auth.group)
        } else {
            return Observable.just([]).asSingle()
        }
    }
    
    func loadGrades() -> Observable<[GradeService.Information]> {
        return persistanceService.loadGradesCache()
            .ifEmpty(switchTo: Observable.just([]))
    }
}

extension DashboardService: HasDashboard {
    var dashboardService: DashboardService {
        return self
    }
}
