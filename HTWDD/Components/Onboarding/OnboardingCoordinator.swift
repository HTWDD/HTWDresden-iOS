//
//  OnboardingCoordinator.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 12.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class OnboardingCoordinator: Coordinator {

    // MARK: - Properties
    private let context: AppContext
    var childCoordinators: [Coordinator] = []
    var rootViewController: UIViewController { return UIViewController() }

    // MARK: - Lifecycle
    init(context: AppContext) {
        self.context = context
    }

    func start() -> OnboardingMainViewController {
        return R.storyboard.onboarding.onboardingMainViewController()!.also {
            $0.modalPresentationStyle   = .overCurrentContext
            $0.context                  = context
        }
    }
}
