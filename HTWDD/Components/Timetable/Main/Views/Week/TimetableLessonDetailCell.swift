//
//  TimetableLessonDetailCell.swift
//  HTWDD
//
//  Created by Chris Herlemann on 07.01.21.
//  Copyright © 2021 HTW Dresden. All rights reserved.
//

class TimetableLessonDetailCell: UITableViewCell, FromNibLoadable {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var lessonDetailTextField: HTWTextField!
    
    weak var delegate: TimetableLessonDetailsDelegateCellDelegate?
    
    var lessonElement: LessonDetailElements! {
        didSet{
            iconView.image = lessonElement.iconImage
            iconView.tintColor = .black
            lessonDetailTextField.placeholder = lessonElement.placeholder
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    
    func setup(model: CustomLesson, isEditable: Bool) {
        
        lessonDetailTextField.isEnabled = isEditable
        
        switch lessonElement {
        
        case .lessonName:
            lessonDetailTextField.text = model.name
        case .abbrevation:
            lessonDetailTextField.text = model.lessonTag
        case .professor:
            lessonDetailTextField.text = model.professor
        case .room: lessonDetailTextField.text = model.rooms
        default: break
        }
    }
    
    @IBAction func detailValueChanged(_ sender: HTWTextField) {
        delegate?.changeValue(forElement: lessonElement, sender.text)
    }
}
