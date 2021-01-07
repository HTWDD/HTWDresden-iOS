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
    var lesson: CustomLesson!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        generalBox.apply {
            $0.layer.cornerRadius   = 4
        }
        
        timeLabel.text = R.string.localizable.time()
        
        calendarWeekSelectionView.placeholder = R.string.localizable.weekRotation()
        calendarWeekSelectionView.selectionOptions = .weekRotation(selection: .none)
        calendarWeekSelectionView.selectionDelegate = self
        
        calendarDaySelectionView.placeholder = R.string.localizable.weekday()
        calendarDaySelectionView.selectionOptions = .weekDay(selection: .none)
        calendarDaySelectionView.selectionDelegate = self
        
        lessonBlockSelectionView.placeholder = R.string.localizable.lessonBlock()
        lessonBlockSelectionView.selectionOptions = .lessonBlock(selection: .none)
        lessonBlockSelectionView.selectionDelegate = self
        
        calendarWeeksTextField.placeholder = R.string.localizable.onlyWeeks()
    }
}

extension TimetableLessonTimeCell: FromNibLoadable {

    func setup(with data: CustomLesson) {
        
        self.lesson = data
        
        if let day = data.day {
            calendarDaySelectionView.text = CalendarWeekDay.allValues[day].localizedDescription
        }
        
        if let week = data.week {
            calendarWeekSelectionView.text = CalendarWeekRotation.allValues[week].localizedDescription
        }
        
        if let lessonBlock = data.lessonBlock {
            lessonBlockSelectionView.text = lessonBlock.localizedDescription
        }
        
        if let weeksOnly = data.weeksOnly {
            
            calendarWeeksTextField.text = weeksOnly.map { String($0) }.joined(separator: ", ")
        }
    }
}

extension TimetableLessonTimeCell: LessonDetailsSelectionFieldDelegate {
    func done(_ selectionOptions: LessonDetailsOptions) {
        switch selectionOptions {
        case .weekRotation(let selection): lesson.week = selection?.rawValue
        case .weekDay(let selection): lesson.day = selection?.rawValue
        case .lessonBlock(let selection): lesson.lessonBlock = selection
        default: break
        }
        
        delegate?.changeDetails(lesson)
    }
    
}
