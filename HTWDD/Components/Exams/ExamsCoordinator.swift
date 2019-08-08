//
//  ExamsCoordinator.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class ExamsCoordinator: Coordinator {
    
    // MARK: - Properties
    let context: AppContext
    var rootViewController: UIViewController { return self.examController }
    var childCoordinators = [Coordinator]()
    private lazy var examController = ExamsMainVC(context: self.context)
    
    private lazy var examViewController = {
        return R.storyboard.exam.examViewController()!.also {
            $0.context = self.context
        }
    }()
    
    var auth: ScheduleService.Auth? {
        didSet {
            self.examController.auth = self.auth
        }
    }
    
    // MARK: - Lifecycle
    init(context: AppContext) {
        self.context = context
    }
    
    func start() -> ExamViewController {
        return examViewController
    }
}
