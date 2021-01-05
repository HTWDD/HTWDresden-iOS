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
    
    weak var lesson: LessonEvent!
    
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
        lessonTypeSelectionField.placeholder = R.string.localizable.lessonType()
        lessonTypeSelectionField.selectionOptions = .lectureType(selection: .none)
        roomTextField.placeholder = R.string.localizable.room()
    }
}

extension TimetableLessonInfoCell: FromNibLoadable {

    func setup(with data: LessonEvent?) {
        lessonNameTextField.text = data?.lesson.name
        abbrevationTextField.text = data?.lesson.lessonTag
        docentNameTextField.text = data?.lesson.professor
        lessonTypeSelectionField.text = data?.lesson.type.localizedDescription
        roomTextField.text = data?.lesson.rooms.joined(separator: ", ")
    }
}
