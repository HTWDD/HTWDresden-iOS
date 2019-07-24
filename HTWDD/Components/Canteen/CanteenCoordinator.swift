//
//  CanteenCoordinator.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 29.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class CanteenCoordinator: Coordinator {
    // MARK: - Typealias
    typealias Services = HasCanteen & HasApiService
    
    // MARK: - Properties
    let context: Services
    var rootViewController: UIViewController { return canteenViewController }
    var childCoordinators: [Coordinator] = []
    private lazy var canteenViewController: CanteenViewController = {
        return R.storyboard.canteen.canteenViewController()!.also {
            $0.context              = context
            $0.canteenCoordinator   = self
        }
    }()
    
    // MARK: Meals Tab View Controller - Contains Sub ViewControllers
    func getMealsTabViewController(for canteenDetail: CanteenDetail) -> MealsTabViewController {
        return R.storyboard.canteen.mealsTabViewController()!.also {
            $0.context              = context
            $0.canteenDetail        = canteenDetail
            $0.canteenCoordinator   = self
        }
    }
    
    // MARK: Meals View Controller - Detail for Today
    func getMealsViewController(for canteenDetail: CanteenDetail) -> MealsViewController {
        return R.storyboard.canteen.mealsViewController()!.also {
            $0.canteenDetail = canteenDetail
        }
    }
    
    func getMealsForWeekViewController(for canteenDetail: CanteenDetail, and weekState: CanteenService.WeekState) -> MealsForWeekTableViewController {
        return R.storyboard.canteen.mealsForWeekTableViewController()!.also {
            $0.canteenDetail    = canteenDetail
            $0.context          = context
            $0.weekState        = weekState
        }
    }
    
    // MARK: Lifecycle
    init(context: Services) {
        self.context = context
    }
}
