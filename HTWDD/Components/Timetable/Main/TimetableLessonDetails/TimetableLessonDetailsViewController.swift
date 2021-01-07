//
//  TimetableLessonDetailsViewController.swift
//  HTWDD
//
//  Created by Chris Herlemann on 18.12.20.
//  Copyright © 2020 HTW Dresden. All rights reserved.
//

import UIKit

protocol TimetableLessonDetailsDelegateCellDelegate {
    
    func changeDetails(_ newLessonDetails: CustomLesson)
}

class TimetableLessonDetailsViewController: UIViewController {

    private enum Item {
        case generalInfo(model: CustomLesson)
        case timeInfo(model: CustomLesson)
    }
    
    var viewModel: TimetableViewModel!
    var context: AppContext!
    var lesson: CustomLesson = CustomLesson()
    
    private var items = [Item]() {
        didSet {
            lessonDetailsTable.reloadData()
        }
    }
    
    @IBOutlet weak var lessonDetailsTable: UITableView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    
    override func viewDidLoad() {
        
        self.title = R.string.localizable.editLesson()
        
        lessonDetailsTable.dataSource = self
        lessonDetailsTable.tableHeaderView?.isHidden = true
        lessonDetailsTable.keyboardDismissMode = .onDrag
        lessonDetailsTable.apply {
            $0.register(TimetableLessonInfoCell.self)
            $0.register(TimetableLessonTimeCell.self)
            $0.backgroundColor = UIColor.htw.veryLightGrey
            
        }
        
        self.view.backgroundColor = UIColor .htw.veryLightGrey
        styleButtons()
        
        items = [.generalInfo(model: lesson), .timeInfo(model: lesson)]
    }
    
    func setup(model: CustomLesson) {
        self.lesson = model
        items = [.generalInfo(model: lesson), .timeInfo(model: lesson)]
    }

    private func styleButtons(){
        closeBtn.setTitle(R.string.localizable.close(), for: .normal)
        closeBtn.layer.cornerRadius = 4
        closeBtn.backgroundColor = UIColor.htw.grey400
        closeBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
    
        saveBtn.setTitle(R.string.localizable.save(), for: .normal)
        saveBtn.layer.cornerRadius = 4
        saveBtn.backgroundColor = UIColor.htw.blue
        saveBtn.addTarget(self, action: #selector(save), for: .touchUpInside)
    }
    
    @objc
    private func close() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func save() {
        
        print(lesson)
        
        
//        check
        
//        TimetableRealm.save(from: lesson)
//        close()
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
            cell.delegate = self
            cell.setup(with: model)
            return cell
            
        case .timeInfo(let model):
            let cell = lessonDetailsTable.dequeueReusableCell(TimetableLessonTimeCell.self, for: indexPath)!
            cell.delegate = self
            cell.setup(with: model)
            
            
            return cell
        }
        
    }
}

extension TimetableLessonDetailsViewController: TimetableLessonDetailsDelegateCellDelegate {
    func changeDetails(_ newLessonDetails: CustomLesson) {
        self.lesson = newLessonDetails
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
