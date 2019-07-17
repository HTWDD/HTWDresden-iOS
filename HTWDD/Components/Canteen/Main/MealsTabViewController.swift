//
//  MealsTabViewController.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 15.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class MealsTabViewController: TabmanViewController {

    // MARK: - Properties
    var canteenDetail: CanteenDetails?
    var context: (HasCanteen & HasApiService)?
    weak var canteenCoordinator: CanteenCoordinator?
    
    private lazy var viewControllers: [UIViewController] = {
        [ self.canteenCoordinator?.getMealsViewController(for: self.canteenDetail!),
          self.canteenCoordinator?.getMealsForWeekViewController(for: self.canteenDetail!, and: .current),
          self.canteenCoordinator?.getMealsForWeekViewController(for: self.canteenDetail!, and: .next) ]
        }() as! [UIViewController]
    
    private lazy var bar: TMBar.ButtonBar = {
        return TMBar.ButtonBar().also {
            $0.layout.transitionStyle   = .snap
            $0.layout.contentMode       = .fit
            $0.fadesContentEdges        = true
            $0.backgroundColor          = UIColor(hex: 0x2457ad)
            $0.indicator.tintColor      = .white
            $0.backgroundView.style     = .clear
            $0.layout.contentInset = UIEdgeInsets(top: 5.0, left: 0, bottom: 1.0, right: 0)
            $0.buttons.customize { button in
                button.font                     = UIFont.from(style: .small, isBold: true)
                button.tintColor                = .white
                button.selectedTintColor        = .white
                button.contentVerticalAlignment = .center
            }
        }
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        addBar(bar, dataSource: self, at: .top)
        setup()
    }
}

// MARK: - PageBoy & TMBarDataSource
extension MealsTabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let title: String
        switch index {
        case 0: title = R.string.localizable.canteenToday()
        case 1: title = R.string.localizable.canteenWeek()
        default: title = R.string.localizable.canteenNextWeek()
        }
        return TMBarItem(title: title)
    }
}

// MARK: - Setup
extension MealsTabViewController {
    
    func setup() {
        let canteenName = canteenDetail?.canteen.name.components(separatedBy: ",").last ?? canteenDetail?.canteen.name
        title = canteenName?.replacingOccurrences(of: "Johannesstadt", with: "Johannstadt")
        view.backgroundColor = UIColor.htw.veryLightGrey
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .automatic
        }
    }
    
}
