//
//  TimetableBaseViewController.swift
//  HTWDD
//
//  Created by Chris Herlemann on 03.12.20.
//  Copyright © 2020 HTW Dresden. All rights reserved.
//

import UIKit

class TimetableBaseViewController: UIViewController {
    
    var viewModel: TimetableViewModel!
    var context: AppContext!
    var refreshControl: UIRefreshControl?
    
    let stateView: EmptyResultsView = {
        return EmptyResultsView().also {
            $0.isHidden = true
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    func setup() {
        fatalError("pls implement")
    }
    
    func reloadData() {
        fatalError("pls implement")
    }
    
    func scrollToToday(notAnimated: Bool = true) {
        fatalError("pls implement")
    }
    
    func getAllLessons() -> [Lesson]? {
        fatalError("pls implement")
    }
    
    func getSemesterWeeks() -> [Int] {
        fatalError("pls implement")
    }
    
    func showSuccessMessage() {
        let alert = UIAlertController(title: R.string.localizable.exportSuccessful(),
                                      message: nil,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default))
        
        self.present(alert, animated: true, completion: nil)
    }
}
