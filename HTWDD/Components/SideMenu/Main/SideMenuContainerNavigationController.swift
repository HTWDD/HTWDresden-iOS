//
//  SideMenuContainerNavigationController.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 19.06.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import SideMenu

class SideMenuContainerNavigationController: NavigationController {
    
    lazy var sideMenuManager: SideMenuManager = {
       return SideMenuManager.default
    }()
    
    private lazy var sideMenuViewController: UIViewController = {
       return UIStoryboard(name: "SideMenu", bundle: nil).instantiateViewController(withIdentifier: "SideMenuVC") as UIViewController
    }()
    
    override func viewDidLoad() {
        sideMenuManager.apply {
            $0.menuLeftNavigationController = UISideMenuNavigationController(rootViewController: sideMenuViewController)
            $0.menuPushStyle        = .preserveAndHideBackButton
            $0.menuPresentMode      = .menuSlideIn
            $0.menuWidth            = 290.0
            $0.menuFadeStatusBar    = false
            
            if let viewController = viewControllers.first {
                $0.menuAddScreenEdgePanGesturesToPresent(toView: viewController.view, forMenu: UIRectEdge.left)
            }
        }
    }
    
}
