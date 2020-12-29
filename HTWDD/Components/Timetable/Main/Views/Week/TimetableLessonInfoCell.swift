//
//  TimetableWeekView.swift
//  HTWDD
//
//  Created by Chris Herlemann on 15.12.20.
//  Copyright © 2020 HTW Dresden. All rights reserved.
//

import UIKit

class TimetableLessonInfoCell: UITableViewCell {

    @IBOutlet weak var generalBox: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        generalBox.apply {
            $0.layer.cornerRadius   = 4
        }
    }
}

extension TimetableLessonInfoCell: FromNibLoadable {

    func setup(with data: LessonEvent?) {
        
    }
}
