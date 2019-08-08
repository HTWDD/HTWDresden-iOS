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
    @IBOutlet weak var lblExamTime: BadgeLabel!
    @IBOutlet weak var lblBranch: BadgeLabel!
    @IBOutlet weak var lblExaminer: BadgeLabel!
    @IBOutlet weak var lblExamType: BadgeLabel!
    @IBOutlet weak var lblExamRooms: BadgeLabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        main.apply {
            $0.layer.cornerRadius = 4
        }
        
        lblExamDate.apply {
            $0.backgroundColor  = UIColor.htw.lightBlueMaterial
            $0.textColor        = .white
        }
        
        lblExamTime.apply {
            $0.backgroundColor  = UIColor.htw.mediumOrange
            $0.textColor        = .white
        }
        
        lblBranch.apply {
            $0.backgroundColor = UIColor.htw.lightGrey
        }
        
        lblExaminer.apply {
            $0.backgroundColor  = UIColor.htw.grey600
            $0.textColor        = .white
        }
        
        lblExamType.apply {
            $0.backgroundColor  = UIColor.htw.lightGrey
        }
        
        lblExamRooms.apply {
            $0.backgroundColor = UIColor.htw.lightGrey
        }
    }

}

// MARK: From Nibloadable
extension ExamViewCell: FromNibLoadable {
    
    func setup(with model: ExaminationRealm) {
        lblExamName.text    = model.title
        lblExamDate.text    = model.day
        lblExamTime.text    = "\(model.startTime) - \(model.endTime)"
        lblBranch.text      = R.string.localizable.examsBranch(model.studyBranch.nilWhenEmpty ?? "-")
        lblExaminer.text    = R.string.localizable.examsExaminer(model.examiner.nilWhenEmpty ?? "-")
        lblExamType.apply {
            var examType = model.examType.replacingOccurrences(of: "SP", with: R.string.localizable.examsExamTypeWritten())
            examType = examType.replacingOccurrences(of: "MP", with: R.string.localizable.examsExamTypeOral())
            $0.text = examType as String
        }
        lblExamRooms.text   = String(model.rooms.dropFirst().dropLast()).replacingOccurrences(of: "\"", with: "")
    }
    
}
