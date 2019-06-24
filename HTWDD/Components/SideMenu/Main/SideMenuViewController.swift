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
    @IBOutlet var menuButtons: [UIButton]!
    
    // MARK: Properties
    private let defaultTintColor: UIColor = .darkGray
    private let selectedTintColor: UIColor = UIColor.htw.blue
    
    var childCoordiantors: [Coordinator] = [Coordinator]()
    
    override func viewDidLoad() {
        prepareMenuButtons()

        self.title = "HTW Dresden"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Back"), style: .plain, target: self, action: #selector(dismissSideMenu))
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
        setTitleAndTintColor(for: &canteenMenuButton, title: Loca.Canteen.pluralTitle)
        setTitleAndTintColor(for: &settingsMenuButton, title: Loca.Settings.title)
        setTitleAndTintColor(for: &managementMenuButton, title: Loca.Management.title)
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
        case managementMenuButton:
            SemesterPlaning.get(network: Network())
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] respone in
                    guard let self = self else { return }
                    Log.info("response \(respone)")
                    }, onError: { [weak self] _ in }).disposed(by: self.disposeBag)
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
