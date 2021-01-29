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
        createDropDownIcon()
        createPickerView()
        dismissPickerView()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        guard textField.text == "" else { return }
        
        textField.text = pickerView(pickerView, titleForRow: 0, forComponent: 0)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        selectionDelegate?.done(selectionOptions)
    }
    
    func createDropDownIcon() {
        let iconView = UIImageView(frame:
                                    CGRect(x: 10, y: 5, width: 20, height: 20))
        iconView.image = UIImage(named: "Down")
        iconView.tintColor = UIColor.htw.Icon.primary
        
        let iconContainerView: UIView = UIView(frame:
                                                CGRect(x: 20, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        
        
        rightView = iconContainerView
        rightViewMode = .always
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
        case .lectureType(_): return LessonType.allCases[row].localizedDescription
        case .weekRotation(_): return CalendarWeekRotation.allCases[row].localizedDescription
        case .weekDay(_): return CalendarWeekDay.allCases[row].localizedDescription
        default: return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch selectionOptions {
        case .lectureType(_): selectionOptions = .lectureType(selection: LessonType.allCases[row])
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
