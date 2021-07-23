//
//  TimetableElectiveLessonCell.swift
//  HTWDD
//
//  Created by Chris Herlemann on 18.05.21.
//  Copyright © 2021 HTW Dresden. All rights reserved.
//

class TimetableElectiveLessonCell: UITableViewCell, FromNibLoadable {
    
    @IBOutlet weak var main: UIView!
    @IBOutlet weak var lblExamName: UILabel!
    @IBOutlet weak var lblExaminer: UILabel!
    @IBOutlet weak var lblExamType: BadgeLabel!
    @IBOutlet weak var lblExamDay: BadgeLabel!
    @IBOutlet weak var lblExamIntegrale: BadgeLabel!
    @IBOutlet weak var lblExamBegin: UILabel!
    @IBOutlet weak var lblExamEnd: UILabel!
    @IBOutlet weak var separator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        main.apply {
            $0.backgroundColor      = UIColor.htw.cellBackground
            $0.layer.cornerRadius   = 4
        }
        
        lblExamName.apply {
            $0.textColor = UIColor.htw.Label.primary
        }
        
        lblExaminer.apply {
            $0.textColor = UIColor.htw.Label.secondary
        }
        
        lblExamType.apply {
            $0.backgroundColor  = UIColor.htw.Badge.primary
            $0.textColor        = UIColor.htw.Label.primary
        }
        
        lblExamDay.apply {
            $0.textColor        = .white
            $0.backgroundColor  = UIColor.htw.Material.blue
        }
        
        lblExamIntegrale.apply {
            $0.backgroundColor  = UIColor.htw.Material.green
            $0.textColor        = .white
        }
        
        lblExamBegin.apply {
            $0.textColor = UIColor.htw.Label.primary
        }
        
        lblExamEnd.apply {
            $0.textColor = UIColor.htw.Label.primary
        }
    }
    
    func setup(lesson: Lesson) {
        separator.backgroundColor = lesson.type.timetableColor
        lblExamName.text    = lesson.name
        lblExamBegin.text   = String(lesson.beginTime.prefix(5))
        lblExamEnd.text     = String(lesson.endTime.prefix(5))
        lblExaminer.text    = lesson.professor?.nilWhenEmpty ?? R.string.localizable.roomOccupancyNoDozent()
        lblExamDay.text     = CalendarWeekDay(rawValue: lesson.day)?.localizedDescription
        lblExamType.text    = lesson.type.localizedDescription
        lblExamIntegrale.isHidden = lesson.isStudiesIntegrale != true
    }
}

