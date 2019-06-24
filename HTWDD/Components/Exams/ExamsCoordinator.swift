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
    let context: HasExams
    var rootViewController: UIViewController { return self.examController }
    var childCoordinators = [Coordinator]()
    private lazy var examController = ExamsMainVC(context: self.context)
    
    var auth: ScheduleService.Auth? {
        didSet {
            self.examController.auth = self.auth
        }
    }
    
    // MARK: - Lifecycle
    init(context: HasExams) {
        self.context = context
    }
    
}
