//
//  CanteenCoordinator.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 29.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class CanteenCoordinator: Coordinator {
    
    // MARK: - Properties
    let context: HasCanteen
    var rootViewController: UIViewController { return self.canteenMainVC }
    var childCoordinators: [Coordinator] = []
    private lazy var canteenMainVC = CanteenMainVC(context: self.context)

    // MARK: Lifecycle
    init(context: HasCanteen) {
        self.context = context
    }
}
