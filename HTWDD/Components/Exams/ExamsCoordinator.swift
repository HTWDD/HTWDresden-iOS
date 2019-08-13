//
//  ExamsCoordinator.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class ExamsCoordinator: Coordinator {
    
    // MARK: - Typealias
    typealias Services = AppContext
    
    // MARK: - Properties
    let context: Services
    var rootViewController: UIViewController { return self.examViewController }
    var childCoordinators = [Coordinator]()
    
    private lazy var examViewController = {
        return R.storyboard.exam.examViewController()!.also {
            $0.context = self.context
        }
    }()
    
    // MARK: - Lifecycle
    init(context: Services) {
        self.context = context
    }
    
    func start() -> ExamViewController {
        return examViewController
    }
}
