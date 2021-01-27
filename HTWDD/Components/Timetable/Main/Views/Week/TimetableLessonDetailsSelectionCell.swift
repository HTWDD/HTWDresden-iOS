//
//  TimetableLessonDetailsSelectionCell.swift
//  HTWDD
//
//  Created by Chris Herlemann on 08.01.21.
//  Copyright © 2021 HTW Dresden. All rights reserved.
//

class TimetableLessonDetailsSelectionCell: UITableViewCell, FromNibLoadable {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var lessonDetailsSelectionField: LessonDetailsSelectionField!
    @IBOutlet weak var main: UIView!
    
    weak var delegate: TimetableLessonDetailsCellDelegate?
    
    var lessonElement: LessonDetailElements! {
        didSet{
            iconView.image = lessonElement.iconImage
            iconView.tintColor = UIColor.htw.Icon.primary
            lessonDetailsSelectionField.placeholder = lessonElement.placeholder
            lessonDetailsSelectionField.selectionOptions = lessonElement.selectionOption
            lessonDetailsSelectionField.selectionDelegate = self
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        main.backgroundColor = UIColor.htw.cellBackground
        self.selectionStyle = .none
    }
    
    func setup(model: CustomLesson, isEditable: Bool) {
        
        lessonDetailsSelectionField.isEnabled = isEditable
        
        switch lessonElement! {
        
        case .lessonType:
            lessonDetailsSelectionField.text = model.type?.localizedDescription
        case .weekrotation:
            guard let week = model.week else { return }
            lessonDetailsSelectionField.text = CalendarWeekRotation(rawValue: week)?.localizedDescription
        case .day:
            guard let day = model.day else { return }
            lessonDetailsSelectionField.text = CalendarWeekDay(rawValue: day)?.localizedDescription
        default: break
        }
    }
}

extension TimetableLessonDetailsSelectionCell: LessonDetailsSelectionFieldDelegate {
    func done(_ selectionOptions: LessonDetailsOptions) {
        
        switch selectionOptions {
        
        case .lectureType(let selection): delegate?.changeValue(selection)
        case .weekRotation(let selection): delegate?.changeValue(forElement: lessonElement, selection?.rawValue)
        case .weekDay(let selection): delegate?.changeValue(forElement: lessonElement, selection?.rawValue)
        }
        
    }
}
