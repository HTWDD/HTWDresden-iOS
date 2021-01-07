//
//  LessonDetailsSelectionField.swift
//  HTWDD
//
//  Created by Chris Herlemann on 07.01.21.
//  Copyright © 2021 HTW Dresden. All rights reserved.
//

protocol LessonDetailsSelectionFieldDelegate {
    func done( _ selectionOptions: LessonDetailsOptions)
}

class LessonDetailsSelectionField: UITextField {
    
    var selectionOptions: LessonDetailsOptions!
    var selectionDelegate: LessonDetailsSelectionFieldDelegate?
    
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
    
        selectionDelegate?.done(selectionOptions)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return selectionOptions?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch selectionOptions {
        case .lectureType(_): return LessonType.allValues[row].localizedDescription
        case .weekRotation(_): return CalendarWeekRotation.allValues[row].localizedDescription
        case .weekDay(_): return CalendarWeekDay.allValues[row].localizedDescription
        case .lessonBlock(_): return LessonBlock.allValues[row].localizedDescription
        default: return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch selectionOptions {
        case .lectureType(_): selectionOptions = .lectureType(selection: LessonType.allValues[row] as? LessonType)
        case .weekRotation(_): selectionOptions = .weekRotation(selection: CalendarWeekRotation.allValues[row] as? CalendarWeekRotation)
        case .weekDay(_): selectionOptions = .weekDay(selection: CalendarWeekDay.allValues[row] as? CalendarWeekDay)
        case .lessonBlock(_): selectionOptions = .lessonBlock(selection: LessonBlock.allValues[row] as? LessonBlock)
        default: break
        }
        
        self.text = selectionOptions?.localizedDescription ?? ""
    }
}
