//
//  WelcomeViewController.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 31.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var lblWelcomeGreeting: UILabel!
    @IBOutlet weak var lblSchedule: UILabel!
    @IBOutlet weak var lblScheduleDescription: UILabel!
    @IBOutlet weak var lblCanteen: UILabel!
    @IBOutlet weak var lblCanteenDescription: UILabel!
    @IBOutlet weak var lblGrades: UILabel!
    @IBOutlet weak var lblGradesDescription: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - Setup
extension WelcomeViewController {
    
    private func setup() {
        lblWelcome.apply {
            $0.text         = R.string.localizable.onboardingWelcomeWelcome()
            $0.textColor    = UIColor.htw.Label.primary
        }
        lblWelcomeGreeting.attributedText   = R.string.localizable.onboardingWelcomeGreeting()
            .attrubutedString([NSAttributedString.Key.foregroundColor : UIColor.htw.Label.primary],
                                                              manipulation: "HTW Dresden App",
                                                              manipulated: [NSAttributedString.Key.foregroundColor : UIColor.htw.Material.orange, NSAttributedString.Key.font : UIFont(name:"HelveticaNeue-Bold", size: 18.0)!])
        lblSchedule.apply {
            $0.text         = R.string.localizable.scheduleTitle()
            $0.textColor    = UIColor.htw.Material.blue
        }
        lblScheduleDescription.apply {
            $0.text         = R.string.localizable.onboardingWelcomeScheduleDescription()
            $0.textColor    = UIColor.htw.Label.secondary
        }
        
        lblCanteen.apply {
            $0.text         = R.string.localizable.canteenTitle()
            $0.textColor    = UIColor.htw.Material.blue
        }
        lblCanteenDescription.apply {
            $0.text         = R.string.localizable.onboardingWelcomeCanteenDescription()
            $0.textColor    = UIColor.htw.Label.secondary
        }
        
        lblGrades.apply {
            $0.text         = R.string.localizable.gradesTitle()
            $0.textColor    = UIColor.htw.Material.blue
        }
        lblGradesDescription.apply {
            $0.text         = R.string.localizable.onboardingWelcomeGradesDescription()
            $0.textColor    = UIColor.htw.Label.secondary
        }
    }
}
