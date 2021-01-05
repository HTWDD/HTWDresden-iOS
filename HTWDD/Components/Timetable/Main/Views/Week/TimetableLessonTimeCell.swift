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
    @IBOutlet weak var calenderWeeksTextField: HTWTextField!
    
    weak var lesson: LessonEvent!
    
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
        
        calenderWeeksTextField.placeholder = R.string.localizable.onlyWeeks()
    }
}

extension TimetableLessonTimeCell: FromNibLoadable {

    func setup(with data: LessonEvent?) {
        
//        calendarDaySelectionView.text = data?.lesson.day
//        lessonBlockSelectionView.text = data?.lesson.
        calenderWeeksTextField.text = data?.lesson.weeksOnly.description
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
        case .lessonBlock(_): return LessonBlocks.allValues[row].localizedDescription
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch selectionOptions {
        case .lectureType(_): selectionOptions = .lectureType(selection: LessonType.allValues[row] as? LessonType)
        case .weekRotation(_): selectionOptions = .weekRotation(selection: CalendarWeekRotation.allValues[row] as? CalendarWeekRotation)
        case .weekDay(_): selectionOptions = .weekDay(selection: CalendarWeekDay.allValues[row] as? CalendarWeekDay)
        case .lessonBlock(_): selectionOptions = .lessonBlock(selection: LessonBlocks.allValues[row] as? LessonBlocks)
        case .none: break
        }
        
        self.text = selectionOptions?.localizedDescription ?? ""
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
    case everyWeek
    case evenWeeks
    case unevenWeeks
    
    static var allValues: [LessonDetailsPickerSelection] { return [everyWeek, evenWeeks, unevenWeeks] }
    static var caseCount: Int { return allValues.count }
    
    var localizedDescription: String {
    
        switch self {
        case .everyWeek: return R.string.localizable.calendarWeekEvery()
        case .evenWeeks: return R.string.localizable.calendarWeekEven()
        case .unevenWeeks: return R.string.localizable.calendarWeekUneven()
        }
    }
}

enum CalendarWeekDay: LessonDetailsPickerSelection {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    
    static var allValues: [LessonDetailsPickerSelection] { return [monday, tuesday, wednesday, thursday, friday] }
    static var caseCount: Int { return allValues.count }
    
    var localizedDescription: String {
        
        switch self {
        case .monday: return R.string.localizable.monday()
        case .tuesday: return R.string.localizable.tuesday()
        case .wednesday: return R.string.localizable.wednesday()
        case .thursday: return R.string.localizable.thursday()
        case .friday: return R.string.localizable.friday()
        }
    }
}

enum LessonBlocks: LessonDetailsPickerSelection {
    static var allValues: [LessonDetailsPickerSelection] { return [firstBlock, secondBlock, thirdBlock, fourthBlock, fifthBlock, sixthBlock, seventhBlock, eighthBlock] }
    static var caseCount: Int { return allValues.count }
    
    case firstBlock
    case secondBlock
    case thirdBlock
    case fourthBlock
    case fifthBlock
    case sixthBlock
    case seventhBlock
    case eighthBlock
    
    var localizedDescription: String {
    
        switch self {
        case .firstBlock: return R.string.localizable.lessonBlockOne()
        case .secondBlock: return R.string.localizable.lessonBlockTwo()
        case .thirdBlock: return R.string.localizable.lessonBlockThree()
        case .fourthBlock: return R.string.localizable.lessonBlockFour()
        case .fifthBlock: return R.string.localizable.lessonBlockFive()
        case .sixthBlock: return R.string.localizable.lessonBlockSix()
        case .seventhBlock: return R.string.localizable.lessonBlockSeven()
        case .eighthBlock: return R.string.localizable.lessonBlockEight()
        }
    }
}
