//
//  GradeCoordinator.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 29.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class GradeCoordinator: Coordinator {
    
    // MARK: - Properties
    let context: HasGrade
    var rootViewController: UIViewController { return self.gradeMainViewController }
    var childCoordinators: [Coordinator] = []
    private lazy var gradeMainViewController = GradeMainVC(context: self.context)

    var auth: GradeService.Auth? {
        set { self.gradeMainViewController.auth = newValue }
        get { return nil }
    }
    
    // MARK: Lifecycle
    init(context: HasGrade) {
        self.context = context
    }
}
