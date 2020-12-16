//
//  LessonCell.swift
//  HTWDD
//
//  Created by Chris Herlemann on 15.12.20.
//  Copyright © 2020 HTW Dresden. All rights reserved.
//

import UIKit
import JZCalendarWeekView

class LessonCell: UICollectionViewCell {

    @IBOutlet weak var lessonName: UILabel!
    @IBOutlet weak var lessonType: UILabel!
    
    var event: LessonEvent?

    override func awakeFromNib() {
        super.awakeFromNib()

        setupBasic()
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
        lessonName.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        lessonName.textColor = .white
        
    }

    func configureCell(event: LessonEvent) {
        self.event = event
        lessonType.text = "Vorlesung"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.hyphenationFactor = 1.0
        paragraphStyle.alignment = .center

        let hyphenAttribute = [
            NSAttributedString.Key.paragraphStyle : paragraphStyle,
        ] as [NSAttributedString.Key : Any]

        let attributedString = NSMutableAttributedString(string: "DBS II", attributes: hyphenAttribute)
        lessonName.attributedText = attributedString
        
        
        self.backgroundColor = " \(event.title) \(event.location)".materialColor //"\(model.name) \(String(model.professor ?? "")) \(model.type)".materialColor
    }

}
