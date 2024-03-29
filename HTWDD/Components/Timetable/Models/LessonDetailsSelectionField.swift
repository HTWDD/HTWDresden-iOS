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

class LessonDetailsSelectionField: UITextField, UITextFieldDelegate {
    
    var selectionOptions: LessonDetailsOptions!
    var selectionDelegate: LessonDetailsSelectionFieldDelegate?
    
    let pickerView = UIPickerView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.delegate = self
        createPickerView()
        dismissPickerView()
    }
    
    func setup(isEditable: Bool) {
        guard isEditable else {
            self.isEnabled = false
            return
        }
        
        createDropDownIcon()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        guard textField.text == "" else {
            return
        }
        
        switch selectionOptions {
        case .lectureType(_): selectionOptions = .lectureType(selection: LessonType.allCasesWithoutDuplicates.first)
        case .weekRotation(_): selectionOptions = .weekRotation(selection: .once)
        case .weekDay(_): selectionOptions = .weekDay(selection: CalendarWeekDay.allCases.first)
        default: break
        }
        
        self.text = selectionOptions?.localizedDescription ?? ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        selectionDelegate?.done(selectionOptions)
    }
    
    func createDropDownIcon() {
        let dropDownIcon = UIImage(named: "Down")
        
        let button = UIButton(frame: CGRect(x: 20, y: 0, width: 30, height: 30))
        button.addTarget(self, action: #selector(iconTapped), for: .touchUpInside)
                                                
        button.setImage(dropDownIcon, for: .normal)
        button.tintColor = UIColor.htw.Icon.primary
        
        rightView = button
        rightViewMode = .always
    }
    
    @objc private func iconTapped() {
        self.becomeFirstResponder()
    }
}

extension LessonDetailsSelectionField: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func createPickerView() {
        
        pickerView.delegate = self
        self.inputView = pickerView
    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: R.string.localizable.done(), style: .plain, target: self, action: #selector(saveSelection))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        self.inputAccessoryView = toolBar
    }
    
    @objc func saveSelection() {
        self.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return selectionOptions?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch selectionOptions {
        case .lectureType(_): return LessonType.allCasesWithoutDuplicates[row].localizedDescription
        case .weekRotation(_): return CalendarWeekRotation.allCases[row].localizedDescription
        case .weekDay(_): return CalendarWeekDay.allCases[row].localizedDescription
        default: return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch selectionOptions {
        case .lectureType(_): selectionOptions = .lectureType(selection: LessonType.allCasesWithoutDuplicates[row])
        case .weekRotation(_): selectionOptions = .weekRotation(selection: CalendarWeekRotation.allCases[row])
        case .weekDay(_): selectionOptions = .weekDay(selection: CalendarWeekDay.allCases[row])
        default: break
        }
        
        self.text = selectionOptions?.localizedDescription ?? ""
    }
    
    @objc func cancelDatePicker(){
        self.endEditing(true)
    }
}
