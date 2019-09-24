//
//  ExamViewCell.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 07.08.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit

class ExamViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var main: UIView!
    @IBOutlet weak var lblExamName: UILabel!
    @IBOutlet weak var lblExamDate: BadgeLabel!
    @IBOutlet weak var lblExaminer: UILabel!
    @IBOutlet weak var lblExamType: BadgeLabel!
    @IBOutlet weak var lblExamRooms: BadgeLabel!
    @IBOutlet weak var lblExamBegin: UILabel!
    @IBOutlet weak var lblExamEnd: UILabel!
    @IBOutlet weak var separator: UIView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        main.apply {
            $0.backgroundColor      = UIColor.htw.cellBackground
            $0.layer.cornerRadius   = 4
        }
        
        lblExamName.apply {
            $0.textColor = UIColor.htw.Label.primary
        }
        
        lblExamDate.apply {
            $0.backgroundColor  = UIColor.htw.Badge.date
            $0.textColor        = .white
        }
        
        lblExaminer.apply {
            $0.textColor = UIColor.htw.Label.secondary
        }
        
        lblExamType.apply {
            $0.backgroundColor  = UIColor.htw.Badge.primary
            $0.textColor        = UIColor.htw.Label.primary
        }
        
        lblExamRooms.apply {
            $0.backgroundColor  = UIColor.htw.Badge.primary
            $0.textColor        = UIColor.htw.Label.primary
        }
        
        lblExamBegin.apply {
            $0.textColor = UIColor.htw.Label.primary
        }
        
        lblExamEnd.apply {
            $0.textColor = UIColor.htw.Label.primary
        }
    }
}

// MARK: From Nibloadable
extension ExamViewCell: FromNibLoadable {
    func setup(with model: ExamRealm) {
        separator.backgroundColor = model.id.materialColor
        lblExamName.text    = model.title
        lblExamDate.text    = model.day
        lblExamBegin.text   = model.startTime.toTime()?.string(format: "HH:mm") ?? (model.startTime.nilWhenEmpty ?? "-")
        lblExamEnd.text     = model.endTime.toTime()?.string(format: "HH:mm") ?? (model.endTime.nilWhenEmpty ?? "-")
        lblExaminer.text    = R.string.localizable.examsExaminer(model.examiner.nilWhenEmpty ?? "-")
        lblExamType.apply {
            var examType = model.examType.replacingOccurrences(of: "SP", with: R.string.localizable.examsExamTypeWritten())
            examType = examType.replacingOccurrences(of: "MP", with: R.string.localizable.examsExamTypeOral())
            $0.text = examType as String
        }
        lblExamRooms.text   = String(model.rooms.dropFirst().dropLast()).replacingOccurrences(of: "\"", with: "")
    }
}
