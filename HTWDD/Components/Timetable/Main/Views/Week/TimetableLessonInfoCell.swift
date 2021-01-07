//
//  TimetableWeekView.swift
//  HTWDD
//
//  Created by Chris Herlemann on 15.12.20.
//  Copyright © 2020 HTW Dresden. All rights reserved.
//

import UIKit

class TimetableLessonInfoCell: UITableViewCell {

    @IBOutlet weak var generalBox: UIView!
    @IBOutlet weak var generalLabel: UILabel!
    @IBOutlet weak var lessonNameTextField: HTWTextField!
    @IBOutlet weak var abbrevationTextField: HTWTextField!
    @IBOutlet weak var docentNameTextField: HTWTextField!
    @IBOutlet weak var lessonTypeSelectionField: LessonDetailsSelectionField!
    @IBOutlet weak var roomTextField: HTWTextField!
    
    var lesson: CustomLesson!
    var delegate: TimetableLessonDetailsDelegateCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        generalBox.apply {
            $0.layer.cornerRadius   = 4
        }
        
        generalLabel.text = R.string.localizable.general()
        lessonNameTextField.placeholder = R.string.localizable.lessonName()
        abbrevationTextField.placeholder = R.string.localizable.abbreviation()
        docentNameTextField.placeholder = R.string.localizable.docentName()
        roomTextField.placeholder = R.string.localizable.room()
        
        lessonTypeSelectionField.placeholder = R.string.localizable.lessonType()
        lessonTypeSelectionField.selectionOptions = .lectureType(selection: .none)
        lessonTypeSelectionField.selectionDelegate = self
    }
    
    @IBAction func lessonNameChanged(_ sender: HTWTextField) {
        lesson.name = sender.text
        delegate?.changeDetails(lesson)
    }
    
    @IBAction func abbrevationChanged(_ sender: HTWTextField) {
        lesson.lessonTag = sender.text
        delegate?.changeDetails(lesson)
    }
    
    @IBAction func docentChanged(_ sender: HTWTextField) {
        lesson.professor = sender.text
        delegate?.changeDetails(lesson)
    }
    
    @IBAction func roomChanged(_ sender: HTWTextField) {
        lesson.rooms = sender.text
        delegate?.changeDetails(lesson)
    }
}

extension TimetableLessonInfoCell: FromNibLoadable {

    func setup(with data: CustomLesson) {
        
        self.lesson = data
        
        lessonNameTextField.text = data.name
        abbrevationTextField.text = data.lessonTag
        docentNameTextField.text = data.professor
        lessonTypeSelectionField.text = data.type?.localizedDescription
        roomTextField.text = data.rooms
    }
}

extension TimetableLessonInfoCell: LessonDetailsSelectionFieldDelegate {
    func done(_ selectionOptions: LessonDetailsOptions) {
        switch selectionOptions {
        case .lectureType(let selection): lesson.type = selection
        default: break
        }
        
        delegate?.changeDetails(lesson)
    }
    
}
