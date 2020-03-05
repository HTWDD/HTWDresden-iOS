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
    
    weak var coordinator: AppCoordinator?
    
    lazy var sideMenuManager: SideMenuManager = {
       return SideMenuManager.default
    }()
    
    private lazy var sideMenuViewController: SideMenuViewController = {
       return UIStoryboard(name: "SideMenu", bundle: nil).instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuViewController
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        self.delegate = self
        sideMenuManager.apply { manager in
            sideMenuViewController.coordinator = self.coordinator
            manager.leftMenuNavigationController = SideMenuNavigationController(rootViewController: sideMenuViewController).also {
                $0.pushStyle            = .preserveAndHideBackButton
                $0.presentationStyle    = .menuSlideIn
                $0.menuWidth            = 290.0
            }
            
            if let _ = viewControllers.first {
                manager.addScreenEdgePanGesturesToPresent(toView: self.view, forMenu: .left)
            }
        }
        sideMenuViewController.view.dropShadow()
        style()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        style()
    }
    
    func setTimeTableButtonHighLight() {
        sideMenuViewController.setTimeTableHighLight()
    }
    
    private func style() {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance().also {
                $0.configureWithOpaqueBackground()
                $0.titleTextAttributes      = [.foregroundColor: UIColor.white]
                $0.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
                $0.backgroundEffect         = UIBlurEffect(style: .dark)
                $0.backgroundColor          = UIColor.htw.blue.withAlphaComponent(traitCollection.userInterfaceStyle == .dark ? 0 : 0.8)
            }
            navigationBar.apply {
                $0.standardAppearance   = navBarAppearance
                $0.scrollEdgeAppearance = navBarAppearance
            }
        }
    }
}

protocol HasSideBarItem {
    func addLeftBarButtonItem()
}

extension HasSideBarItem where Self: UIViewController {
    func addLeftBarButtonItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Hamburger"), style: .plain, target: nil, action: nil)
    }
}

extension SideMenuContainerNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let hasSideMenu = viewController as? HasSideBarItem {
            hasSideMenu.addLeftBarButtonItem()
            viewController.navigationItem.leftBarButtonItem?.action = #selector(self.openSideMenu)
        }
    }
    
    @objc private func openSideMenu() {
        present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
    }
}

