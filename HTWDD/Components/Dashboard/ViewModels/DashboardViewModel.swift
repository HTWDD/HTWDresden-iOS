//
//  DashboardViewModel.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 30.09.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

enum Dashboards {
    case header(model: DashboardHeader)
    case lesson(model: Lesson)
    case freeDay
    case grade(model: DashboardGrade)
    case noAuthToken
    case noStudyToken
    case emptyGrade
    case meals(models: [Meal])
}

class DashboardViewModel {
    
    // MARK: - Properties
    private let context: HasDashboard
    
    // MARK: - Lifecycle
    init(context: HasDashboard) {
        self.context = context
    }

    // MARK: - Data Request
    func load() -> Observable<[Dashboards]> {
        return Observable
            .combineLatest(
                requestTimetable()
                    .observeOn(SerialDispatchQueueScheduler(qos: .background)),
                requestGrades()
                    .observeOn(SerialDispatchQueueScheduler(qos: .background)),
                requestMeals()
                    .observeOn(SerialDispatchQueueScheduler(qos: .background))
            ) { (timetable: [Dashboards], grades: [Dashboards], meals: [Dashboards]) -> [Dashboards] in
                timetable + grades + meals
            }
    }
    
     func requestTimetable() -> Observable<[Dashboards]> {
        
        return context
            .dashboardService
            .requestTimetable()
            .debug()
            .map { (lessons: [Lesson]) -> [Dashboards] in
                var result: [Dashboards] = []
                result.append(.header(model: DashboardHeader(header: R.string.localizable.scheduleTitle(), subheader: Date().string(format: "EEEE, dd. MMMM"))))
                if !lessons.isEmpty {
                    let currentLesson: Lesson? = lessons
                        .filter { $0.weeksOnly.contains(Date().weekNumber) }
                        .filter { $0.day == ((Date().weekDay - 1) % 7) }
                        .sorted(by: { (lhs, rhs) -> Bool in
                            lhs.beginTime < rhs.beginTime
                        })
                        .filter { $0.endTime >= Date().string(format: "HH:mm:ss") }
                        .first
                    
                    if let lesson = currentLesson {
                        result.append(.lesson(model: lesson))
                    } else {
                        result.append(.freeDay)
                    }
                } else {
                    result.append(.freeDay)
                }
                return result
            }
            .catchErrorJustReturn([.header(model: DashboardHeader(header: R.string.localizable.scheduleTitle(), subheader: Date().string(format: "EEEE, dd. MMMM"))), .noStudyToken])
    }
    
    private func requestGrades() -> Observable<[Dashboards]> {
        return context
            .dashboardService
            .requestGrades()
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .map { (grades: [Grade]) -> [Dashboards] in
                var result: [Dashboards] = []
                if !grades.isEmpty {
                    let totalCredits = grades.map { $0.credits }.reduce(0.0, +)
                    let totalGrades = grades.map { $0.credits * Double($0.grade ?? 0) }.reduce(0.0, +)
                    let totalAverage = totalGrades > 0 ? (totalGrades / totalCredits) / 100 : 0.0
                    let gradesCount = grades.compactMap { $0.grade }.count
                    let lastGrade = grades.sorted().filter { $0.grade != nil }.last
                    result.append(.header(model: DashboardHeader(header: R.string.localizable.gradesTitle(), subheader: R.string.localizable.gradesAverage(totalAverage))))
                    result.append(.grade(model: DashboardGrade(grades: gradesCount, credits: totalCredits, lastGrade: lastGrade)))
                
                } else {
                    result.append(.header(model: DashboardHeader(header: R.string.localizable.gradesTitle(), subheader: R.string.localizable.gradesAverage(0.0))))
                    result.append(.emptyGrade)
                }
                return result
        }.catchErrorJustReturn([.header(model: DashboardHeader(header: R.string.localizable.gradesTitle(), subheader: R.string.localizable.gradesAverage(0.0))), .noAuthToken])
    }
    
    private func requestMeals() -> Observable<[Dashboards]> {
        return context
            .dashboardService
            .requestMeals()
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .asObservable()
            .map { (items: [Meal]) -> [Dashboards] in
                var result: [Dashboards] = []
                if !items.isEmpty {
                    result.append(.header(model: DashboardHeader(header: R.string.localizable.canteenTitle(), subheader: "⭐️ Reichenbachstraße")))
                    result.append(.meals(models: items))
                }
                return result
            }
            .catchErrorJustReturn([Dashboards]())
    }
    
}
