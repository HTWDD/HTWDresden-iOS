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
    let context: HasGrade & AppContext
    var rootViewController: UIViewController { return self.gradeMainViewController }
    var childCoordinators: [Coordinator] = []
    private lazy var gradeMainViewController: GradesViewController = {
        return R.storyboard.grades.gradesViewController()!.also {
            $0.context = self.context
            $0.viewModel = GradesViewModel(context: context)
        }
    }()

    // MARK: Lifecycle
    init(context: HasGrade & AppContext) {
        self.context = context
    }
}
