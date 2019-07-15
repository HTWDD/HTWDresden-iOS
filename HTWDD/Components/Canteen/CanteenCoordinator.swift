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
            $0.context = context
        }
    }()
    
    func getMealsViewController(for canteenDetail: CanteenDetails) -> MealsViewController {
        return R.storyboard.canteen.mealsViewController()!.also {
            $0.canteenDetail = canteenDetail
        }
    }
    
    func getMealsTabViewController(for canteenDetail: CanteenDetails) -> MealsTabViewController {
        return R.storyboard.canteen.mealsTabViewController()!.also {
            $0.canteenDetail = canteenDetail
        }
    }
    
    
    // MARK: Lifecycle
    init(context: Services) {
        self.context = context
    }
}
