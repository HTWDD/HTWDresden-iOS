//
//  OnboardingMainViewController.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 05.08.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit

class OnboardingMainViewController: UIViewController {

    // MARK: - Properties
    weak var context: AppContext?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let destinationViewController = segue.destination as? OnboardingPageViewController {
            destinationViewController.context = context
        }
    }
}
