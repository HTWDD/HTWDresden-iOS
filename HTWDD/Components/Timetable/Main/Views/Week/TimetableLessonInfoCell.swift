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
    @IBOutlet weak var lessonTypeSelectionField: LessonDetailsSelectionField!
    weak var lesson: LessonEvent!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        generalBox.apply {
            $0.layer.cornerRadius   = 4
        }
        
        lessonTypeSelectionField.selectionOptions = .lessonType(selection: .none)
        
        createPickerView()
        dismissPickerView()
    }
}

extension TimetableLessonInfoCell: FromNibLoadable {

    func setup(with data: LessonEvent?) {
        
    }
}

extension TimetableLessonInfoCell: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        lessonTypeSelectionField.inputView = pickerView
    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(selectLessonType))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        lessonTypeSelectionField.inputAccessoryView = toolBar
    }
    @objc func selectLessonType() {
        lessonTypeSelectionField.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return  LessonType.allValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return LessonType.allValues[row].localizedDescription
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        lessonTypeSelectionField.text = LessonType.allValues[row].localizedDescription
    }
}
