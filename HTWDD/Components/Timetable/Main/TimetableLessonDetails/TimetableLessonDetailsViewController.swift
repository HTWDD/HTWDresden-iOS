//
//  TimetableLessonDetailsViewController.swift
//  HTWDD
//
//  Created by Chris Herlemann on 18.12.20.
//  Copyright © 2020 HTW Dresden. All rights reserved.
//

import UIKit

class TimetableLessonDetailsViewController: UIViewController {

    private enum Item {
        case generalInfo(model: LessonEvent?)
        case timeInfo(model: LessonEvent?)
    }
    
    var viewModel: TimetableViewModel!
    var context: AppContext!
    var lesson: LessonEvent?
    {
        didSet {
            lessonDetailsTable.reloadData()
        }
    }
    
    private var items = [Item]() {
        didSet {
            lessonDetailsTable.reloadData()
        }
    }
    
    @IBOutlet weak var navigationHeader: UIView!
    @IBOutlet weak var lessonDetailsTable: UITableView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    
    override func viewDidLoad() {
        
        self.title = "Edit Lesson"
        
        lessonDetailsTable.dataSource = self
        lessonDetailsTable.tableHeaderView?.isHidden = true
        lessonDetailsTable.apply {
            $0.register(TimetableLessonInfoCell.self)
            $0.register(TimetableLessonTimeCell.self)
            $0.backgroundColor = UIColor.htw.veryLightGrey
            
        }
        
        self.view.backgroundColor = UIColor.htw.veryLightGrey
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        items = [.generalInfo(model: lesson), .timeInfo(model: lesson)]
        
        styleButtons()
    }
    
    private func styleButtons(){
        closeBtn.layer.cornerRadius = 4
        closeBtn.backgroundColor = UIColor.htw.grey400
    
        saveBtn.layer.cornerRadius = 4
        saveBtn.backgroundColor = UIColor.htw.blue
    }
}

extension TimetableLessonDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        switch items[indexPath.row] {
        case .generalInfo(let model):
            let cell = lessonDetailsTable.dequeueReusableCell(TimetableLessonInfoCell.self, for: indexPath)!
            cell.setup(with: model)
            return cell
            
        case .timeInfo(let model):
            let cell = lessonDetailsTable.dequeueReusableCell(TimetableLessonTimeCell.self, for: indexPath)!
            cell.setup(with: model)
            return cell
        }
        
    }
    
    
}

class HTWTextField: UITextField {
    
    override func draw(_ rect: CGRect) {
        
        let border = CALayer()
        
        border.backgroundColor = UIColor.htw.lightGrey.cgColor
        border.frame = CGRect(x: 0, y: frame.size.height * 1.2, width: frame.width, height: 1)
        
        layer.addSublayer(border)
    }
}
