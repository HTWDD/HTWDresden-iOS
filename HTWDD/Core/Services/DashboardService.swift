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
    
    func requestMeals(for canteenId: Int = 80) -> Single<[Meal]> {
        return apiService.requestMeals(for: canteenId, and: Date().string(format: "yyyy-MM-dd"))
    }
    
    // MARK: - Grades
    func requestGrades() -> Observable<[Grade]> {
        return requestCourses()
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .flatMap { (courses: [Course]) -> Observable<[[Grade]]> in
                let requests: [Observable<[Grade]>] = courses.map { [unowned self] (course: Course) in
                    self.requestGrades(for: course).catchErrorJustReturn([Grade]())
                }
                return Observable.combineLatest(requests)
            }
            .map { (grades: [[Grade]]) -> [Grade] in
                return grades.reduce([], +)
            }
    }
    
    private func requestCourses() -> Observable<[Course]> {
        guard let auth = KeychainService.shared[.authToken] else { return Observable.error(AuthError.noAuthToken) }
        return apiService
            .requestCourses(auth: auth)
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .asObservable()
    }
    
    private func requestGrades(for course: Course) -> Observable<[Grade]> {
        guard let auth = KeychainService.shared[.authToken] else { return Observable.error(AuthError.noAuthToken) }
        return apiService
            .requestGrades(auth: auth, course: course)
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .asObservable()
    }
    
    // MARK: - Timetable
    func requestTimetable() -> Observable<[Lesson]> {
        let (year, major, group, _) = KeychainService.shared.readStudyToken()
        if let year = year, let major = major, let group = group {
            return apiService
                .requestLessons(for: year, major: major, group: group)
                .observeOn(SerialDispatchQueueScheduler(qos: .background))
                .asObservable()
        } else {
            return Observable.error(AuthError.noStudyToken)
        }
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
