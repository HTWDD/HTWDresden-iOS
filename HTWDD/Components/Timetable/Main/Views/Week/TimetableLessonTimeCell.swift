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
    @IBOutlet weak var calendarWeekSelectionView: LessonDetailsSelectionField!
    @IBOutlet weak var calendarDaySelectionView: LessonDetailsSelectionField!
    @IBOutlet weak var lessonBlockSelectionView: LessonDetailsSelectionField!
    @IBOutlet weak var calenderWeeksTextField: HTWTextField!
    
    weak var lesson: LessonEvent!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        generalBox.apply {
            $0.layer.cornerRadius   = 4
        }
        
        calendarWeekSelectionView.selectionOptions = .weekRotation(selection: .none)
        calendarDaySelectionView.selectionOptions = .weekDay(selection: .none)
        lessonBlockSelectionView.selectionOptions = .lessonBlock(selection: .none)
    }
}

extension TimetableLessonTimeCell: FromNibLoadable {

    func setup(with data: LessonEvent?) {
        
    }
}

extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }

        return self
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
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(selectLessonType))
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
        case .lessonBlock(_): return LessonBlocks.allValues[row].localizedDescription
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.text = selectionOptions?.localizedDescription ?? ""
        
        switch selectionOptions {
        case .lectureType(_): selectionOptions = .lectureType(selection: LessonType.allValues[row] as? LessonType)
        case .weekRotation(_): selectionOptions = .weekRotation(selection: CalendarWeekRotation.allValues[row] as? CalendarWeekRotation)
        case .weekDay(_): selectionOptions = .weekDay(selection: CalendarWeekDay.allValues[row] as? CalendarWeekDay)
        case .lessonBlock(_): selectionOptions = .lessonBlock(selection: LessonBlocks.allValues[row] as? LessonBlocks)
        case .none: break
        }
    }
}

enum LessonDetailsOptions {
    case lectureType(selection: LessonType?)
    case weekRotation(selection: CalendarWeekRotation?)
    case weekDay(selection: CalendarWeekDay?)
    case lessonBlock(selection: LessonBlocks?)
    
    var count: Int {
        switch self {
        case .lectureType(_): return LessonType.caseCount
        case .weekRotation(_): return CalendarWeekRotation.caseCount
        case .weekDay(_): return CalendarWeekDay.caseCount
        case .lessonBlock(_): return LessonBlocks.caseCount
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .lectureType(let selection): return selection?.localizedDescription ?? ""
        case .weekRotation(let selection): return selection?.localizedDescription ?? ""
        case .weekDay(let selection): return selection?.localizedDescription ?? ""
        case .lessonBlock(let selection): return selection?.localizedDescription ?? ""
        }
    }
    
}

enum CalendarWeekRotation: LessonDetailsPickerSelection {
    case every
    case everTwo
    
    static var allValues: [LessonDetailsPickerSelection] { return [every, everTwo] }
    static var caseCount: Int { return allValues.count }
    
    var localizedDescription: String {return "CalendarWeekRotation"}
}

enum CalendarWeekDay: LessonDetailsPickerSelection {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    
    static var allValues: [LessonDetailsPickerSelection] { return [monday, tuesday, wednesday, thursday, friday] }
    static var caseCount: Int { return allValues.count }
    
    var localizedDescription: String {return "CalendarWeekDay"}
}

enum LessonBlocks: LessonDetailsPickerSelection {
    static var allValues: [LessonDetailsPickerSelection] { return [first, second] }
    static var caseCount: Int { return allValues.count }
    
    case first
    case second
    
    var localizedDescription: String {return "LessonBlocks"}
}
