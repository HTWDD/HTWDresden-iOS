//
//  MealsForWeekTableViewModel.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 27.09.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

class MealsForWeekTableViewModel {

    // MARK: - Properties
    private let context: HasCanteen
    private let week: CanteenService.WeekState
    private let detail: CanteenDetail
    
    // MARK: - Lifecycle
    init(context: HasCanteen, week: CanteenService.WeekState, detail: CanteenDetail) {
        self.context    = context
        self.week       = week
        self.detail     = detail
    }
    
    func load() -> Observable<[Meals]>  {
        return context
            .canteenService
            .requestMeals(for: week, and: detail.canteen.id)
            .map { (meals: [[Meal]]) -> [Meals] in
                var mapResult: [Meals] = []
                for (index, elements) in meals.enumerated() {
                    if !elements.isEmpty {
                        let day: String
                        let dayDate: Date
                        switch index {
                        case 0:
                            day = R.string.localizable.monday()
                            dayDate = self.week == CanteenService.WeekState.current ? Date().dateOfWeek(for: Date.Week.beginn)    : Date().dateOfWeek(for: UInt(Date.Week.beginn.rawValue + 7))
                        case 1:
                            day = R.string.localizable.tuesday()
                            dayDate = self.week == CanteenService.WeekState.current ? Date().dateOfWeek(for: Date.Week.second)    : Date().dateOfWeek(for: UInt(Date.Week.second.rawValue + 7))
                        case 2:
                            day = R.string.localizable.wednesday()
                            dayDate = self.week == CanteenService.WeekState.current ? Date().dateOfWeek(for: Date.Week.mid)       : Date().dateOfWeek(for: UInt(Date.Week.mid.rawValue + 7))
                        case 3:
                            day = R.string.localizable.thursday()
                            dayDate = self.week == CanteenService.WeekState.current ? Date().dateOfWeek(for: Date.Week.lead)      : Date().dateOfWeek(for: UInt(Date.Week.lead.rawValue + 7))
                        default:
                            day = R.string.localizable.friday()
                            dayDate = self.week == CanteenService.WeekState.current ? Date().dateOfWeek(for: Date.Week.end)       : Date().dateOfWeek(for: UInt(Date.Week.end.rawValue + 7))
                        }
                        
                        mapResult.append(.header(model: MealHeader(header: day, subheader: dayDate.string(format: "dd. MMMM"))))
                        
                        elements.forEach { element in
                            mapResult.append(.meal(model: element))
                        }
                    }
                }
                return mapResult
            }
            .catchErrorJustReturn([Meals]())
    }
    
}
