//
//  MangementCoordinator.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 21.06.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation

class ManagementCoordinator: Coordinator {
    
    // MARK: - Properties
    let context: HasManagement
    var rootViewController: UIViewController { return self.managementVC }
    var childCoordinators: [Coordinator] = []
    private lazy var managementVC = UIViewController()
    
    init(context: HasManagement) {
        self.context = context
    }
}
