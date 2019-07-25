//
//  SideMenuViewController.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 19.06.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

class SideMenuViewController: ViewController {
    
    // MARK: IBOutlet
    @IBOutlet weak var classMenuButton: UIButton!
    @IBOutlet weak var examsMenuButton: UIButton!
    @IBOutlet weak var gradesMenuButton: UIButton!
    @IBOutlet weak var canteenMenuButton: UIButton!
    @IBOutlet weak var settingsMenuButton: UIButton!
    @IBOutlet weak var managementMenuButton: UIButton!
    @IBOutlet weak var dashboardMenuButton: UIButton!
    @IBOutlet weak var bookingMenuButton: UIButton!
    @IBOutlet var menuButtons: [UIButton]!
    
    // MARK: Properties
    private let defaultTintColor: UIColor = UIColor.htw.darkGrey
    private let selectedTintColor: UIColor = UIColor.htw.blue
    
    weak var coordinator: AppCoordinator?
    
    var childCoordiantors: [Coordinator] = [Coordinator]()
    
    override func viewDidLoad() {
        prepareMenuButtons()

        self.title = "HTW Dresden"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Back"), style: .plain, target: self, action: #selector(dismissSideMenu))
    }
    
    fileprivate func prepareMenuButtons() {
        
        func setTitleAndTintColor(for button: inout UIButton, title: String, tintColor: UIColor = UIColor.htw.darkGrey) {
            button.apply { b in
                b.setTitle(title, for: .normal)
                b.tintColor = tintColor
            }
        }
        
        setTitleAndTintColor(for: &dashboardMenuButton, title: R.string.localizable.dashboardTitle(), tintColor: selectedTintColor)
        setTitleAndTintColor(for: &bookingMenuButton, title: R.string.localizable.roomOccupancyTitle())
        setTitleAndTintColor(for: &classMenuButton, title: Loca.Schedule.title)
        setTitleAndTintColor(for: &examsMenuButton, title: Loca.Exams.title)
        setTitleAndTintColor(for: &gradesMenuButton, title: Loca.Grades.title)
        setTitleAndTintColor(for: &canteenMenuButton, title: Loca.Canteen.pluralTitle)
        setTitleAndTintColor(for: &settingsMenuButton, title: Loca.Settings.title)
        setTitleAndTintColor(for: &managementMenuButton, title: Loca.Management.title)
    }
    
    func setTimeTableHighLight() {
        menuButtons.forEach({ $0.tintColor = defaultTintColor })
        classMenuButton.tintColor = selectedTintColor
    }
    
    @objc fileprivate func dismissSideMenu() {
        dismiss(animated: true, completion: nil)
    }
    
    private let disposeBag = DisposeBag()
    
    @IBAction func onMenuButtonTouchUpInside(_ sender: UIButton) {
        sender.apply { $0.tintColor = selectedTintColor }
        
        menuButtons.filter { $0 != sender }.forEach { (button) in
            button.tintColor = defaultTintColor
        }
        
        switch sender {
        case dashboardMenuButton: coordinator?.goTo(controller: .dashboard)
        case classMenuButton: coordinator?.goTo(controller: .schedule)
        case examsMenuButton: coordinator?.goTo(controller: .exams)
        case gradesMenuButton: coordinator?.goTo(controller: .grades)
        case canteenMenuButton: coordinator?.goTo(controller: .canteen)
        case settingsMenuButton: coordinator?.goTo(controller: .settings)
        case managementMenuButton: coordinator?.goTo(controller: .management)
        default:
            break
        }
        
        dismiss(animated: true, completion: nil)
    }
}
