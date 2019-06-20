//
//  CanteenCoordinator.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 29.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class CanteenCoordinator: Coordinator {
    lazy var tabBarController: UITabBarController? = {
        return self.rootViewController.tabBarController
    }()
    
    var rootViewController: UIViewController {
        return self.canteenMainVC.inNavigationController()
    }
    var childCoordinators: [Coordinator] = []

    private lazy var canteenMainVC = CanteenMainVC(context: self.context)

    let context: HasCanteen
    init(context: HasCanteen) {
        self.context = context
    }

    func start() {
        tabBarController?.selectedIndex = 3
    }
}
