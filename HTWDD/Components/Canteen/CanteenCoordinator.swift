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
    
    func getMealsViewController(for canteen: Canteens) -> MealsViewController {
        return R.storyboard.canteen.mealsViewController()!.also {
            $0.canteen = canteen
        }
    }
    
    
    // MARK: Lifecycle
    init(context: Services) {
        self.context = context
    }
}
