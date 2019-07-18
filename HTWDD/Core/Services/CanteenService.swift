//
//  CanteenService.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 10.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

class CanteenService {
    
    // MARK: - Properties
    private let apiService: ApiService

    // MARK: - Week Switch
    enum WeekState {
        case current
        case next
    }
    
    // MARK: - Lifecycle
    init(apiService: ApiService) {
        self.apiService = apiService
    }
    
    /// Requesting all canteens Dresden 20 KM Radius
    func request() -> Observable<[Canteens]> {
        return apiService.requestCanteens()
            .map { $0.sorted(by: { (lhs, rhs) in lhs.name < rhs.name }) }
            .map { $0.sorted(by: { (lhs, rhs) in lhs.name.contains("Reichenbachstraße") }) }
            .asObservable()
    }
    
    func requestMeals(for canteenId: Int, and day: String) -> Observable<[Meals]> {
        return apiService.requestMeals(for: canteenId, and: day).asObservable()
    }
    
    func requestMeals(for week: WeekState, and canteenId: Int) -> Observable<[[Meals]]> {
        switch week {
        case .current: return requestMealsForCurrentWeek(for: canteenId)
        case .next: return requestMealsForNextWeek(for: canteenId)
        }
    }
    
    private func requestMealsForCurrentWeek(for canteenId: Int) -> Observable<[[Meals]]> {
        return Observable.combineLatest(Date().allDateForWeek()
            .map { $0.string(format: "yyyy-MM-dd") }
            .map { requestMeals(for: canteenId, and: $0) })
    }
    
    private func requestMealsForNextWeek(for canteenId: Int) -> Observable<[[Meals]]> {
        return Observable.combineLatest(Date().allDateForNextWeek()
            .map { $0.string(format: "yyyy-MM-dd") }
            .map { requestMeals(for: canteenId, and: $0) })
    }
}

extension CanteenService: HasCanteen {
    var canteenService: CanteenService { return self }
}
