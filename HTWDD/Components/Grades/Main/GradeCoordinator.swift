//
//  GradeCoordinator.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 29.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class GradeCoordinator: Coordinator {
    var rootViewController: UIViewController {
        return self.gradeMainViewController.inNavigationController()
    }

    var childCoordinators: [Coordinator] = []

    private lazy var gradeMainViewController = GradeMainVC(context: self.context)

    var auth: GradeService.Auth? {
        set { self.gradeMainViewController.auth = newValue }
        get { return nil }
    }

    let context: HasGrade
    init(context: HasGrade) {
        self.context = context
    }

}
