//
//  TimetableLessonDetailTimePickerCell.swift
//  HTWDD
//
//  Created by Chris Herlemann on 08.01.21.
//  Copyright © 2021 HTW Dresden. All rights reserved.
//

class TimetableLessonDetailTimePickerCell: UITableViewCell, FromNibLoadable {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var lessonDetailsSelectionField: TimePickerTextField!
    @IBOutlet weak var main: UIView!
    
    weak var delegate: TimetableLessonDetailsCellDelegate?
    
    var lessonElement: LessonDetailElements! {
        didSet{
            iconView.image = lessonElement.iconImage
            iconView.tintColor = UIColor.htw.Icon.primary
            lessonDetailsSelectionField.selectionDelegate = self
            lessonDetailsSelectionField.placeholder = lessonElement.placeholder
            lessonDetailsSelectionField.datePicker.datePickerMode = lessonElement == LessonDetailElements.day ? .date : .time
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        main.backgroundColor = UIColor.htw.cellBackground
        self.selectionStyle = .none
    }
    
    func setup(model: CustomLesson, isEditable: Bool) {
        
        lessonDetailsSelectionField.setup(isEditable: isEditable)
        
        switch lessonElement {
        case .day:
            if let day = model.day {
                lessonDetailsSelectionField.text = CalendarWeekDay.allCases[day - 1].localizedDescription
            }
        case .startTime: lessonDetailsSelectionField.text = String(model.beginTime?.dropLast(3) ?? "")
        case .endTime: lessonDetailsSelectionField.text = String(model.endTime?.dropLast(3) ?? "")
        default: break
        }
    }
}

extension TimetableLessonDetailTimePickerCell: TimePickerTextFieldDelegate {
    
    func valueChanged(_ newValue: Date) {
        print(newValue)
        delegate?.changeValue(forElement: lessonElement, newValue)
    }
}

protocol TimePickerTextFieldDelegate: AnyObject {
    func valueChanged(_ newValue: Date)
}

class TimePickerTextField: UITextField, UIPickerViewDelegate, UITextFieldDelegate {
    
    var datePicker = UIDatePicker()
    weak var selectionDelegate: TimePickerTextFieldDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.delegate = self
        createPickerView()
        setupToolbarForPickerView()
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
        
        self.valueChanged(datePicker)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        valueChanged(datePicker)
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
    
    func createPickerView() {
        self.inputView = datePicker
        datePicker.datePickerMode = .time
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        datePicker.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
    }
    
    func setupToolbarForPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: R.string.localizable.done(), style: .plain, target: self, action: #selector(done))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        self.inputAccessoryView = toolBar
    }
    
    @objc func valueChanged(_ datePicker: UIDatePicker) {
        
        if datePicker.datePickerMode == .date {
            self.text = datePicker.date.localized
        } else {
            
            let timeFormatter = DateFormatter()
            timeFormatter.timeStyle = .short
            self.text = timeFormatter.string(from: datePicker.date)
        }
        
        selectionDelegate?.valueChanged(datePicker.date)
    }
    
    @objc func done() {
        self.endEditing(true)
    }
}
