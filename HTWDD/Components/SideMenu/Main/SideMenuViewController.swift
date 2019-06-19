//
//  SideMenuViewController.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 19.06.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation

class SideMenuViewController: UIViewController {
    
    @IBOutlet weak var classMenuButton: UIButton!
    @IBOutlet weak var examsMenuButton: UIButton!
    @IBOutlet weak var gradesMenuButton: UIButton!
    @IBOutlet weak var canteenMenuButton: UIButton!
    @IBOutlet weak var settingsMenuButton: UIButton!
    
    override func viewDidLoad() {
        classMenuButton.setTitle(Loca.Schedule.title, for: .normal)
        examsMenuButton.setTitle(Loca.Exams.title, for: .normal)
        gradesMenuButton.setTitle(Loca.Grades.title, for: .normal)
        canteenMenuButton.setTitle(Loca.Canteen.title, for: .normal)
        settingsMenuButton.setTitle(Loca.Settings.title, for: .normal)
    }
}
