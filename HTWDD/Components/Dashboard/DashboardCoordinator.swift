//
//  DashboardCoordinator.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 18.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation

class DashboardCoordinator: Coordinator {
    // MARK: - Typealias
    typealias Services = HasDashboard & HasApiService & AppContext
    
    // MARK: - Properties
    let context: Services
    var rootViewController: UIViewController { return dashboardViewController }
    var childCoordinators: [Coordinator] = []
    private lazy var dashboardViewController: DashboardViewController = {
        return R.storyboard.dashboard.dashboardViewController()!.also {
            $0.context = context
            $0.viewModel = DashboardViewModel(context: context)
        }
    }()
    
    // MARK: - Lifecycle
    init(context: Services) {
        self.context = context
    }
}
