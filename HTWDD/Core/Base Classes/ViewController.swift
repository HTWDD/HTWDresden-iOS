//
//  ViewController.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 15/11/2016.
//  Copyright © 2016 HTW Dresden. All rights reserved.
//

import UIKit
import SideMenu

class ViewController: UIViewController {
    
    private lazy var sideMenuManager: SideMenuManager = {
       return SideMenuManager.default
    }()
    
    private lazy var sideMenuNavigationButton: UIBarButtonItem = {
       return UIBarButtonItem(image: #imageLiteral(resourceName: "Hamburger"), style: .plain, target: self, action: #selector(self.openSideMenu))
    }()
    
	init() {
		super.init(nibName: nil, bundle: nil)
		self.initialSetup()
	}

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		self.initialSetup()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.initialSetup()
	}

	func initialSetup() {
		// Intentionally left empty
        self.navigationItem.leftBarButtonItem = sideMenuNavigationButton
	}

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    @objc
    func dismissOrPopViewController() {
        if let presenting = self.presentingViewController {
            presenting.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func openSideMenu() {
        present(sideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }

}
