//
//  AnalyticsViewController.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 01.08.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit
import Lottie

class AnalyticsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var lblAnalyticsDescription: UILabel!
    @IBOutlet weak var lblAnalyticsInformation: UILabel!
    @IBOutlet weak var lblAnalyticsRevokeDescription: UILabel!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var lblHelpQuestion: UILabel!
    @IBOutlet weak var btnYes: UIButton!
    
    // MARK: - Properties
    private lazy var animation: Animation? = {
        return Animation.named("PulseBlue")
    }()
    
    weak var delegate: UIPageViewSwipeDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.animationView.play()
        }
    }
    
    // MARK: - User Interaction
    @IBAction func onYesTouch(_ sender: UIButton) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.animation                  = Animation.named("PulseGrey")
            self.animationView.animation    = self.animation
            self.btnYes.isEnabled           = false
        }
        delegate?.next(animated: true)
    }
}

// MARK: - Setup
extension AnalyticsViewController {
    
    private func setup() {
        lblAnalyticsDescription.text        = R.string.localizable.onboardingAnalyticsDescription()
        lblAnalyticsInformation.text        = R.string.localizable.onboardingAnalyticsInformation()
        lblAnalyticsRevokeDescription.text  = R.string.localizable.onboardingAnalyticsRevokeDescription()
        lblHelpQuestion.text                = R.string.localizable.onboardingAnalyticsHelpQuestion()
        btnYes.titleLabel?.text             = R.string.localizable.yes()
        animationView.apply {
            $0.animation    = animation
            $0.contentMode  = .scaleAspectFit
            $0.loopMode     = .loop
        }
    }
    
}
