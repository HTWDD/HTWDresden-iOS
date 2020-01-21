//
//  MangementCoordinator.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 21.06.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation

class ManagementCoordinator: Coordinator {
    
    // MARK: - Typealias
    typealias Services = HasManagement & HasApiService
    
    // MARK: - Properties
    let context: Services
    var rootViewController: UIViewController { return managementViewController }
    var childCoordinators: [Coordinator] = []
    private lazy var managementViewController: ManagementViewController = {
        let vc = R.storyboard.management.managementMainVC()!
        vc.context = context
        return vc
    }()
    
    // MARK: - Lifecycle
    init(context: Services) {
        self.context = context
    }
}
