//
//  DashboardTimeTableViewCell.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 19.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit

class DashboardTimeTableViewCell: UITableViewCell, FromNibLoadable {
    
    // MARK: - Outlets
    @IBOutlet weak var main: UIView!
    @IBOutlet weak var lblCurrentHeader: UILabel!
    @IBOutlet weak var lblCurrent: UILabel!
    @IBOutlet weak var lblCurrentProf: UILabel!
    @IBOutlet weak var lblLessonType: BadgeLabel!
    @IBOutlet weak var lblRoom: BadgeLabel!
    @IBOutlet weak var lblLessonBeginn: BadgeLabel!
    @IBOutlet weak var lblLessonEnd: BadgeLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        main.apply {
            $0.layer.cornerRadius = 4
        }
        
        lblCurrentHeader.apply {
            $0.textColor = UIColor.htw.darkGrey
            $0.font = UIFont.from(style: .description, isBold: true)
        }
        
        lblCurrent.apply {
            $0.numberOfLines    = 0
            $0.textColor        = UIColor.htw.darkGrey
            $0.font             = UIFont.from(style: .small, isBold: true)
        }
        
        lblCurrentProf.apply {
            $0.textColor        = UIColor.htw.darkGrey
            $0.numberOfLines    = 0
            $0.font             = UIFont.from(style: .small)
        }
        
        lblLessonType.apply {
            $0.numberOfLines    = 0
            $0.backgroundColor  = UIColor.htw.mediumOrange
            $0.textColor        = .white
            $0.font             = UIFont.from(style: .verySmall, isBold: true)
        }
        
        lblRoom.apply {
            $0.numberOfLines    = 0
            $0.backgroundColor  = UIColor(hex: 0x005c98)
            $0.textColor        = .white
            $0.font             = UIFont.from(style: .verySmall, isBold: true)
        }
        
        lblLessonBeginn.apply {
            $0.numberOfLines    = 0
            $0.backgroundColor  = UIColor(hex: 0xC9C9C9)
            $0.textColor        = UIColor.htw.darkGrey
            $0.font             = UIFont.from(style: .verySmall, isBold: true)
        }
        
        lblLessonEnd.apply {
            $0.numberOfLines    = 0
            $0.backgroundColor  = UIColor(hex: 0xC9C9C9)
            $0.textColor        = UIColor.htw.darkGrey
            $0.font             = UIFont.from(style: .verySmall, isBold: true)
        }
    }
    
    // MARK: - Setup
    func setup(with model: Lesson?, isCurrent: Bool = true) {
        if let model = model  {
            lblCurrentHeader.text   = isCurrent ? R.string.localizable.scheduleCurrentLesson() : R.string.localizable.scheduleNextLesson()
            lblCurrent.text         = model.name
            lblCurrentProf.text     = model.professor
            lblLessonType.text      = model.type.localizedDescription
            lblRoom.text            = model.rooms.joined(separator: ", ")
            lblLessonBeginn.text    = String(model.beginTime.prefix(5))
            lblLessonEnd.text       = String(model.endTime.prefix(5))
            
            lblCurrentProf.isHidden     = false
            lblLessonType.isHidden      = false
            lblRoom.isHidden            = false
            lblLessonBeginn.isHidden    = false
            lblLessonEnd.isHidden       = false
            
        } else {
            lblCurrentHeader.text       = R.string.localizable.scheduleFreeDay()
            lblCurrent.text             = R.string.localizable.scheduleNextLectureUnavailable()
            lblCurrentProf.isHidden     = true
            lblLessonType.isHidden      = true
            lblRoom.isHidden            = true
            lblLessonBeginn.isHidden    = true
            lblLessonEnd.isHidden       = true
        }
        
    }
    
}
