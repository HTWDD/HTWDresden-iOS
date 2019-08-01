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
    @IBOutlet weak var lblAnalyticsRevokeDescription: UILabel!
    @IBOutlet weak var animationView: AnimationView!
    
    // MARK: - Properties
    private lazy var animation: Animation? = {
        return Animation.named("PulseBlue")
    }()
    
    weak var delegate: UIPageViewSwipeDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        animationView.apply {
            $0.animation    = animation
            $0.contentMode  = .scaleAspectFit
            $0.loopMode     = .loop
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.animationView.play()
        }
    }
    
    @IBAction func onYesTouch(_ sender: UIButton) {
        delegate?.next(animated: true)
    }
}
