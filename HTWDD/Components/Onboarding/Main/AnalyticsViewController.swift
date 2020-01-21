//
//  AnalyticsViewController.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 01.08.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit
import Lottie
import Firebase

class AnalyticsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var lblAnalytics: UILabel!
    @IBOutlet weak var lblAnalyticsDescription: UILabel!
    @IBOutlet weak var lblAnalyticsInformation: UILabel!
    @IBOutlet weak var lblAnalyticsRevokeDescription: UILabel!
    @IBOutlet weak var chartsAnimationView: AnimationView!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var lblHelpQuestion: UILabel!
    @IBOutlet weak var btnYes: UIButton!
    
    // MARK: - Properties
    weak var delegate: UIPageViewSwipeDelegate?
    private lazy var animation: Animation? = {
        return Animation.named(!UserDefaults.standard.analytics ? "PulseBlue" : "PulseGrey")
    }()
    private lazy var chartsAnimation: Animation? = {
        return Animation.named("BarchartsGrey")
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
            if !UserDefaults.standard.analytics {
                self.animationView.play()
            }
            self.chartsAnimationView.play()
        }
    }
    
    // MARK: - User Interaction
    @IBAction func onYesTouch(_ sender: UIButton) {
        UserDefaults.standard.analytics = true
        
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
        btnYes.isEnabled        = !UserDefaults.standard.analytics
        lblAnalytics.textColor  = UIColor.htw.Label.primary
        lblAnalyticsDescription.apply {
            $0.text         = R.string.localizable.onboardingAnalyticsDescription()
            $0.textColor    = UIColor.htw.Label.primary
        }
        lblAnalyticsInformation.apply {
            $0.text         = R.string.localizable.onboardingAnalyticsInformation()
            $0.textColor    = UIColor.htw.Label.secondary
        }
        lblAnalyticsRevokeDescription.apply {
            $0.text         = R.string.localizable.onboardingAnalyticsRevokeDescription()
            $0.textColor    = UIColor.htw.Material.orange
        }
        lblHelpQuestion.apply {
            $0.text         = R.string.localizable.onboardingAnalyticsHelpQuestion()
            $0.textColor    = UIColor.htw.Material.blue
        }
        btnYes.setTitle(R.string.localizable.yes(), for: .normal)
        animationView.apply {
            $0.animation    = animation
            $0.contentMode  = .scaleAspectFit
            $0.loopMode     = .loop
        }
        chartsAnimationView.apply {
            $0.animation    = chartsAnimation
            $0.contentMode  = .scaleAspectFit
            $0.loopMode     = .repeat(Float.random(in: 1...6))
        }
    }
    
}
