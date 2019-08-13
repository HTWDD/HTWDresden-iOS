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
        lblWelcome.text                     = R.string.localizable.onboardingWelcomeWelcome()
        lblWelcomeGreeting.attributedText   = R.string.localizable.onboardingWelcomeGreeting()
                                                .attrubutedString([NSAttributedString.Key.foregroundColor : UIColor.htw.darkGrey],
                                                              manipulation: "HTW Dresden App",
                                                              manipulated: [NSAttributedString.Key.foregroundColor : UIColor.htw.mediumOrange, NSAttributedString.Key.font : UIFont(name:"HelveticaNeue-Bold", size: 18.0)!])
        lblSchedule.text            = R.string.localizable.scheduleTitle()
        lblScheduleDescription.text = R.string.localizable.onboardingWelcomeScheduleDescription()
        lblCanteen.text             = R.string.localizable.canteenTitle()
        lblCanteenDescription.text  = R.string.localizable.onboardingWelcomeCanteenDescription()
        lblGrades.text              = R.string.localizable.gradesTitle()
        lblGradesDescription.text   = R.string.localizable.onboardingWelcomeGradesDescription()
    }
    
}
