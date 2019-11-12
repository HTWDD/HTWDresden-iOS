//
//  CanteenViewModel.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 27.09.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

class CanteenViewModel {
    
    // MARK: - Properties
    private let context: HasCanteen & HasApiService
    
    // MARK: - Lifecycle
    init(context: HasCanteen & HasApiService) {
        self.context = context
    }
    
    // MARK: - Load
    func load() -> Observable<[CanteenDetail]> {
        // Short Info: Request for each canteen the meals on the current day
        let currentDay = Date().string(format: "yyyy-MM-dd")
        return context
            .canteenService
            .request()
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .flatMap { canteens -> Observable<[CanteenDetail]> in
                let requests = canteens.map { [unowned self] canteen in
                    self.context
                        .canteenService
                        .requestMeals(for: canteen.id, and: currentDay)
                        .map { meals in
                            return CanteenDetail(canteen: canteen, meals: meals)
                        }
                        .catchErrorJustReturn(CanteenDetail(canteen: canteen, meals: []))
                    }
                return Observable.combineLatest(requests)
            }
        
    }
}
