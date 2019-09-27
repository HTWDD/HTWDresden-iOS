//
//  MealsViewModel.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 27.09.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

// MARK: - Items
enum Meals {
    case header(model: MealHeader)
    case meal(model: Meal)
}

// MARK: - VM
class MealsViewModel {
    
    private let data: CanteenDetail
    
    init(data: CanteenDetail) {
        self.data = data
    }
    
    func load() -> Observable<[Meals]> {
        return Observable.deferred {
            var result: [Meals] = []
            let categoriesSet = self.data.meals.reduce(into: Set<String>(), { categories, meal in
                categories.insert(meal.category)
            })
                
            Array(categoriesSet.sorted()).forEach { category in
                let meals = self.data.meals.filter { $0.category == category }
                let mealsCount = meals.count
                
                result.append(.header(model: MealHeader(header: category, subheader: mealsCount > 1 ? R.string.localizable.canteenMealCountPlural(mealsCount) : R.string.localizable.canteenMealCount(mealsCount))))
                meals.forEach { meal in
                    result.append(.meal(model: meal))
                }
            }
            return .just(result)
        }
        .observeOn(SerialDispatchQueueScheduler(qos: .background))
        .catchErrorJustReturn([Meals]())
    }
     
}
