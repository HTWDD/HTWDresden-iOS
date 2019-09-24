//
//  StudyGroupSelectionViewCell.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 05.08.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit

class StudyGroupSelectionViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var main: UIView!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblSubContent: UILabel!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        main.apply {
            $0.backgroundColor      = UIColor.htw.cellBackground
            $0.layer.cornerRadius   = 4
        }
        
        lblContent.textColor    = UIColor.htw.Label.primary
        lblSubContent.textColor = UIColor.htw.Label.secondary
    }
}

// MARK: - From Nibloadable
extension StudyGroupSelectionViewCell: FromNibLoadable {
    
    func setup(with data: Identifiable) {
        switch data {
        case is StudyYear:
            let year                    = (data as! StudyYear).studyYear + 2000
            lblContent.text             = "\(year)"
            lblSubContent.isHidden      = true
            leadingConstraint.constant  = 24
            bottomConstraint.constant   = 0
        
        case is StudyCourse:
            let course = (data as! StudyCourse)
            lblContent.text         = "\(course.name.nilWhenEmpty ?? String("---"))"
            lblSubContent.text      = "\(course.studyCourse)"
            lblSubContent.isHidden  = false
            
        case is StudyGroup:
            let group = (data as! StudyGroup)
            lblContent.text     = "\(group.name.nilWhenEmpty ?? String("---"))"
            lblSubContent.apply {
                $0.text     = group.studyGroup
                $0.isHidden = false
            }
            
        default:
            break
        }
    }
    
}

