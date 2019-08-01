//
//  CrashlyticsViewController.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 01.08.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit
import Lottie

class CrashlyticsViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var lblCrashlyticsDescription: UILabel!
    @IBOutlet weak var lblCrashlyticsInformation: UILabel!
    @IBOutlet weak var lblCrashlyticsHelpQuestion: UILabel!
    @IBOutlet weak var lblCrashlyticsRevoke: UILabel!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var btnYes: UIButton!
    
    
    // MARK: - Properties
    weak var delegate: UIPageViewSwipeDelegate?
    private lazy var animation: Animation? = {
        return Animation.named("PulseBlue")
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.animationView.play()
        }
    }
    
    // MARK: - User Interaction
    @IBAction func onYesTouch(_ sender: UIButton) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.animation                  = Animation.named("PulseGrey")
            self.animationView.animation    = self.animation
            sender.isEnabled                = false
        }
        delegate?.next(animated: true)
    }
}

// MARK: - Setup
extension CrashlyticsViewController {
    
    private func setup() {
        lblCrashlyticsDescription.text  = R.string.localizable.onboardingCrashlyticsDescription()
        lblCrashlyticsInformation.text  = R.string.localizable.onboardingCrashlyticsInformation()
        lblCrashlyticsHelpQuestion.text = R.string.localizable.onboardingCrashlyticsHelpQuestion()
        lblCrashlyticsRevoke.text       = R.string.localizable.onboardingCrashlyticsRevokeDescription()
        btnYes.titleLabel?.text         = R.string.localizable.yes()
        animationView.apply {
            $0.animation    = animation
            $0.contentMode  = .scaleAspectFit
            $0.loopMode     = .loop
        }
    }
    
}
