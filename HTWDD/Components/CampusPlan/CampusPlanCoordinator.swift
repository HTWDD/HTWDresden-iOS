//
//  CampusPlanCoordinator.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 25.09.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation

class CampusPlanCoordinator: Coordinator {
    
    // MARK: - Typealias
    typealias Service = HasCampusPlan
    
    // MARK: - Properties
    let context: Service
    var rootViewController: UIViewController { return campusPlanViewController }
    var childCoordinators: [Coordinator] = []
    private lazy var campusPlanViewController: CampusPlanViewController = {
        return R.storyboard.campusPlan.campusPlanViewController()!.also {
            $0.context      = context
            $0.viewModel    = CampusPlanViewModel(context: context)
        }
    }()
    
    // MARK: - Lifecycle
    init(context: Service) {
        self.context = context
    }
}
