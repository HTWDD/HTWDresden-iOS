//
//  TimetableCoordinator.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 01.10.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation

class TimetableCoordinator: Coordinator {
    
    // MARK: - Typealias
    typealias Service = HasTimetable & AppContext
    
    // MARK: - Properties
    private let context: Service
    var rootViewController: UIViewController { return timetableViewController }
    var childCoordinators: [Coordinator] = []
    private lazy var timetableViewController: TimetableViewController = {
        return R.storyboard.timetable.timetableViewController()!.also {
            $0.context      = context
            $0.viewModel    = TimetableViewModel(context: context)
        }
    }()
    
    // MARK: - Lifecycle
    init(context: Service) {
        self.context = context
    }
    
    func start() -> UIViewController {
        return rootViewController
    }
}
