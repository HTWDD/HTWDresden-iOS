//
//  ScheduleCoordinator.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 29.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class ScheduleCoordinator: Coordinator {
    
    // MARK: Properties
    let context: HasSchedule
    var rootViewController: UIViewController { return self.scheduleMainViewController }
    var childCoordinators: [Coordinator] = []
    private lazy var scheduleMainViewController = ScheduleMainVC(context: self.context)
    
    var auth: ScheduleService.Auth? {
        didSet {
            self.scheduleMainViewController.auth = self.auth
        }
    }
    
    // MARK: Lifecycle
    init(context: HasSchedule) {
        self.context = context
    }
    
    func jumpToToday(animated: Bool = true) {
        self.scheduleMainViewController.jumpToToday(animated: animated)
    }
}
