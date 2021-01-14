//
//  LessonCell.swift
//  HTWDD
//
//  Created by Chris Herlemann on 15.12.20.
//  Copyright © 2020 HTW Dresden. All rights reserved.
//

import UIKit
import JZCalendarWeekView

protocol LessonCellExportDelegate: class {
    func export(_ lessonEvent: LessonEvent)
}

class LessonCell: UICollectionViewCell {

    @IBOutlet weak var lessonName: UILabel!
    @IBOutlet weak var lessonType: UILabel!
    
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
    }

    func configureCell(event: LessonEvent) {
        self.event = event
        lessonType.text = event.lesson.type.localizedDescription
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.hyphenationFactor = 1.0
        paragraphStyle.alignment = .center

        let hyphenAttribute = [
            NSAttributedString.Key.paragraphStyle : paragraphStyle,
        ] as [NSAttributedString.Key : Any]

        let attributedString = NSMutableAttributedString(string: event.lesson.lessonTag ?? event.lesson.name, attributes: hyphenAttribute)
        lessonName.attributedText = attributedString
        
        
        self.backgroundColor = event.lesson.type.timetableColor
    }
    
    @objc func exportLesson() {
        guard let lessonEvent = event else { return }
        
        exportDelegate?.export(lessonEvent)
    }

}
