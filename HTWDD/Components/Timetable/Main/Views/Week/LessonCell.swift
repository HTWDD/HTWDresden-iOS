//
//  LessonCell.swift
//  HTWDD
//
//  Created by Chris Herlemann on 15.12.20.
//  Copyright © 2020 HTW Dresden. All rights reserved.
//

import UIKit
import JZCalendarWeekView

protocol LessonCellExportDelegate: AnyObject {
    func export(_ lessonEvent: LessonEvent)
}

class LessonCell: UICollectionViewCell {
    
    @IBOutlet weak var lessonName: UILabel!
    @IBOutlet weak var lessonType: UILabel!
    @IBOutlet weak var lessonRoom: UILabel!
    
    var event: LessonEvent?
    weak var exportDelegate: LessonCellExportDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupBasic()
        let exportGesture = UILongPressGestureRecognizer(target: self, action: #selector(exportLesson))
        self.addGestureRecognizer(exportGesture)
    }
    
    func setupBasic() {
        self.clipsToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0
        layer.cornerRadius = 4
        lessonType.font = UIFont.systemFont(ofSize: 10)
        lessonType.textColor = .white
        lessonName.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        lessonName.textColor = .white
        lessonRoom.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        lessonRoom.textColor = .white
    }
    
    func configureCell(event: LessonEvent) {
        self.event = event
        
        lessonType.text = event.lesson.type.localizedDescription
        lessonRoom.text = event.lesson.rooms.joined(separator: ", ")
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.hyphenationFactor = 1.0
        paragraphStyle.alignment = .center
        
        let hyphenAttribute = [
            NSAttributedString.Key.paragraphStyle : paragraphStyle,
        ] as [NSAttributedString.Key : Any]
        
        lessonName.attributedText = NSMutableAttributedString(string: event.lesson.lessonTag ?? event.lesson.name, attributes: hyphenAttribute)
        
        self.backgroundColor = event.lesson.type.timetableColor
    }
    
    @objc func exportLesson() {
        guard let lessonEvent = event else { return }
        
        exportDelegate?.export(lessonEvent)
    }
}
