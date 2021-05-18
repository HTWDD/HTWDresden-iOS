//
//  TimetableElectiveLessonCell.swift
//  HTWDD
//
//  Created by Chris Herlemann on 18.05.21.
//  Copyright © 2021 HTW Dresden. All rights reserved.
//

class TimetableElectiveLessonCell: UITableViewCell, FromNibLoadable {
    
    @IBOutlet weak var lessonName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(lesson: Lesson) {
        lessonName.text = lesson.name
    }
}
