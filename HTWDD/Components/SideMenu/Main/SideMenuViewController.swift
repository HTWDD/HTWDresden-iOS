//
//  SideMenuViewController.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 19.06.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation

class SideMenuViewController: ViewController {
    
    // MARK: IBOutlet
    @IBOutlet weak var classMenuButton: UIButton!
    @IBOutlet weak var examsMenuButton: UIButton!
    @IBOutlet weak var gradesMenuButton: UIButton!
    @IBOutlet weak var canteenMenuButton: UIButton!
    @IBOutlet weak var settingsMenuButton: UIButton!
    @IBOutlet var menuButtons: [UIButton]!
    
    // MARK: Properties
    private let defaultTintColor: UIColor = .darkGray
    private let selectedTintColor: UIColor = UIColor.htw.blue
    
    var childCoordiantors: [Coordinator] = [Coordinator]()
    
    override func viewDidLoad() {
        prepareMenuButtons()
    }
    
    fileprivate func prepareMenuButtons() {
        
        func setTitleAndTintColor(for button: inout UIButton, title: String, tintColor: UIColor = .darkGray) {
            button.apply { b in
                b.setTitle(title, for: .normal)
                b.tintColor = tintColor
            }
        }
        
        setTitleAndTintColor(for: &classMenuButton, title: Loca.Schedule.title, tintColor: selectedTintColor)
        setTitleAndTintColor(for: &examsMenuButton, title: Loca.Exams.title)
        setTitleAndTintColor(for: &gradesMenuButton, title: Loca.Grades.title)
        setTitleAndTintColor(for: &canteenMenuButton, title: Loca.Canteen.title)
        setTitleAndTintColor(for: &settingsMenuButton, title: Loca.Settings.title)
    }
    
    @IBAction func onMenuButtonTouchUpInside(_ sender: UIButton) {
        menuButtons.filter { $0 != sender }.forEach { (button) in
            button.tintColor = defaultTintColor
        }
        
        sender.apply {
            $0.tintColor = selectedTintColor
        }
        
        switch sender {
        case classMenuButton:
            (childCoordiantors.filter { $0 is ScheduleCoordinator}.first as? ScheduleCoordinator)?.start()
            break
        case examsMenuButton:
            (childCoordiantors.filter { $0 is ExamsCoordinator}.first as? ExamsCoordinator)?.start()
            break
        case gradesMenuButton:
            (childCoordiantors.filter { $0 is GradeCoordinator}.first as? GradeCoordinator)?.start()
            break
        case canteenMenuButton:
            (childCoordiantors.filter { $0 is CanteenCoordinator}.first as? CanteenCoordinator)?.start()
            break
        case settingsMenuButton:
            (childCoordiantors.filter { $0 is SettingsCoordinator}.first as? SettingsCoordinator)?.start()
            break
        default:
            break
        }
        
        dismiss(animated: true, completion: nil)
    }
}
