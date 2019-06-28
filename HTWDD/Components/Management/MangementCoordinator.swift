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
    private lazy var managementVC: ManagementViewController = {
        let vc = UIStoryboard(name: "Management", bundle: nil).instantiateViewController(withIdentifier: "ManagementMainVC") as! ManagementViewController
        vc.context = self.context
        return vc
    }()
    
    // MARK: - Lifecycle
    init(context: HasManagement) {
        self.context = context
    }
}
