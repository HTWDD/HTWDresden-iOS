//
//  TimetableLessonTimeCell.swift
//  HTWDD
//
//  Created by Chris Herlemann on 04.01.21.
//  Copyright © 2021 HTW Dresden. All rights reserved.
//

import UIKit

class TimetableLessonTimeCell: UITableViewCell {

    @IBOutlet weak var generalBox: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var calendarWeekSelectionView: LessonDetailsSelectionField!
    @IBOutlet weak var calendarDaySelectionView: LessonDetailsSelectionField!
    @IBOutlet weak var lessonBlockSelectionView: LessonDetailsSelectionField!
    @IBOutlet weak var calendarWeeksTextField: HTWTextField!
    
    var delegate: TimetableLessonDetailsDelegateCellDelegate?
    var lesson: Lesson!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        generalBox.apply {
            $0.layer.cornerRadius   = 4
        }
        
        timeLabel.text = R.string.localizable.time()
        
        calendarWeekSelectionView.placeholder = R.string.localizable.weekRotation()
        calendarWeekSelectionView.selectionOptions = .weekRotation(selection: .none)
        
        calendarDaySelectionView.placeholder = R.string.localizable.weekday()
        calendarDaySelectionView.selectionOptions = .weekDay(selection: .none)
        
        lessonBlockSelectionView.placeholder = R.string.localizable.lessonBlock()
        lessonBlockSelectionView.selectionOptions = .lessonBlock(selection: .none)
        
        calendarWeeksTextField.placeholder = R.string.localizable.onlyWeeks()
    }
}

extension TimetableLessonTimeCell: FromNibLoadable {

    func setup(with data: Lesson?) {
        
        guard let data = data else { return }
        
        calendarDaySelectionView.text = CalendarWeekDay.allValues[data.day].localizedDescription
        calendarWeekSelectionView.text = CalendarWeekRotation.allValues[data.week].localizedDescription
        
        calendarWeeksTextField.text = data.weeksOnly.map { String($0) }.joined(separator: ", ")
    }
}

class LessonDetailsSelectionField: UITextField {
    
    var selectionOptions: LessonDetailsOptions?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        createDropDownIcon()
        createPickerView()
        dismissPickerView()
    }
    
    func createDropDownIcon() {
        let iconView = UIImageView(frame:
                                    CGRect(x: 10, y: 5, width: 20, height: 20))
        iconView.image = UIImage(named: "Down")
        let iconContainerView: UIView = UIView(frame:
                                                CGRect(x: 20, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        
        rightView = iconContainerView
        rightViewMode = .always
    }
}

extension LessonDetailsSelectionField: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        self.inputView = pickerView
    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: R.string.localizable.done(), style: .plain, target: self, action: #selector(selectLessonType))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        self.inputAccessoryView = toolBar
    }
    
    @objc func selectLessonType() {
        self.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return selectionOptions?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        guard let selectionOptions = selectionOptions else {
            return ""
        }
        
        switch selectionOptions {
        case .lectureType(_): return LessonType.allValues[row].localizedDescription
        case .weekRotation(_): return CalendarWeekRotation.allValues[row].localizedDescription
        case .weekDay(_): return CalendarWeekDay.allValues[row].localizedDescription
        case .lessonBlock(_): return LessonBlock.allValues[row].localizedDescription
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch selectionOptions {
        case .lectureType(_): selectionOptions = .lectureType(selection: LessonType.allValues[row] as? LessonType)
        case .weekRotation(_): selectionOptions = .weekRotation(selection: CalendarWeekRotation.allValues[row] as? CalendarWeekRotation)
        case .weekDay(_): selectionOptions = .weekDay(selection: CalendarWeekDay.allValues[row] as? CalendarWeekDay)
        case .lessonBlock(_): selectionOptions = .lessonBlock(selection: LessonBlock.allValues[row] as? LessonBlock)
        case .none: break
        }
        
        self.text = selectionOptions?.localizedDescription ?? ""
    }
}
