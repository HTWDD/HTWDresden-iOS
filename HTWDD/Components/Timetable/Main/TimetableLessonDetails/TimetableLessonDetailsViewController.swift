//
//  TimetableLessonDetailsViewController.swift
//  HTWDD
//
//  Created by Chris Herlemann on 18.12.20.
//  Copyright © 2020 HTW Dresden. All rights reserved.
//

import UIKit

class TimetableLessonDetailsViewController: UIViewController, HasSideBarItem {
    
    var viewModel: TimetableViewModel!
    var context: AppContext!
    var lesson: Lesson?
    
    @IBOutlet weak var lessonDetailsTable: UITableView!
    
    override func viewDidLoad() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = .red
        
        lessonDetailsTable.dataSource = self
        
        lessonDetailsTable.apply {
            $0.register(TimetableLessonInfoCell.self)
            $0.backgroundColor = UIColor.htw.veryLightGrey
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
}

extension TimetableLessonDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        lessonDetailsTable.dequeueReusableCell(TimetableLessonInfoCell.self, for: indexPath)!
//            .also {
//            $0.setup(with: model)
//        }
    }
    
    
}
