//
//  OnboardingFinishViewController.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 07.08.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit
import Lottie
import SwiftKeychainWrapper

class OnboardingFinishViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var lblFinishHeader: UILabel!
    @IBOutlet weak var lblFinishDescription: UILabel!
    @IBOutlet weak var finishAnimationView: AnimationView!
    @IBOutlet weak var btnFinish: UIButton!
    
    // MARK: - Properties
    private lazy var finishAnimation: Animation? = {
        return Animation.named("FinishGrey")
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
            self.lblFinishHeader.emitConfetti(duration: Double.random(in: 1.8...4.2))
            self.finishAnimationView.play { [weak self] finish in
                guard let self = self else { return }
                self.btnFinish.setState(with: finish ? .active : .inactive)
            }
        }
    }
    
    // MARK: - User Interaction
    @IBAction func onFinishTap(_ sender: UIButton) {
        UserDefaults.standard.needsOnboarding = false
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Setup
extension OnboardingFinishViewController {
    
    private func setup() {
        finishAnimationView.apply {
            $0.animation    = finishAnimation
            $0.contentMode  = .scaleAspectFit
            $0.loopMode     = .playOnce
        }
        lblFinishHeader.text        = R.string.localizable.onboadingFinishHeader()
        lblFinishDescription.text   = R.string.localizable.onboadingFinishDescription()
        btnFinish.apply {
            $0.setTitle(R.string.localizable.letsgo(), for: .normal)
            $0.setState(with: .inactive)
        }
    }
    
}
