//
//  DashboardGradeViewCell.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 22.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit

class DashboardGradeViewCell: UITableViewCell, FromNibLoadable {
    
    // MAKR: - Outlets
    @IBOutlet weak var main: UIView!
    @IBOutlet weak var lblNumberOfGrades: UILabel!
    @IBOutlet weak var lblNumberOfCredits: UILabel!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var lblLastGradeHeader: UILabel!
    @IBOutlet weak var lblLastGrade: BadgeLabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        main.apply {
            $0.layer.cornerRadius = 4
        }
        
        lblNumberOfGrades.apply {
            $0.textColor        = .white
            $0.backgroundColor  = UIColor(hex: 0x1E88E5)
            $0.font             = UIFont.from(style: .small, isBold: true)
        }
        
        lblNumberOfCredits.apply {
            $0.textColor        = .white
            $0.backgroundColor  = UIColor(hex: 0x0097A7)
            $0.font             = UIFont.from(style: .small, isBold: true)
        }
        
        lblLastGradeHeader.apply {
            $0.textColor    = UIColor.htw.darkGrey
            $0.font         = UIFont.from(style: .description, isBold: true)
        }
        
        lblLastGrade.apply {
            $0.textColor    = .white
            $0.font         = UIFont.from(style: .small, isBold: true)
        }
    }
    
    // MARK: - Setup
    func setup(with models: [GradeService.Information]) {
        
        let grades = models.flatMap { Array($0.grades) }.filter { $0.mark != nil }
        let credits = grades.map { $0.credits }.reduce(0.0, +)
        
        lblNumberOfGrades.text = grades.count != 1 ? R.string.localizable.gradesNumbersPlural(grades.count) : R.string.localizable.gradesNumbersSingular(grades.count)
        
        lblNumberOfCredits.text = credits != 1.0 ? R.string.localizable.gradesCreditsNumberPlural(credits) : R.string.localizable.gradesCreditsNumberSingular(credits)
        
        if let lastGrade = grades.first {
            separator.isHidden          = false
            lblLastGradeHeader.isHidden = false
            lblLastGrade.isHidden       = false
            
            lblLastGradeHeader.text = R.string.localizable.gradesLastGrade(lastGrade.state.localizedDescription)
            lblLastGrade.apply {
                $0.text = lastGrade.text
                switch lastGrade.state {
                case .passed: $0.backgroundColor = UIColor.htw.green
                case .failed: $0.backgroundColor = UIColor.htw.redMaterial
                case .signedUp: $0.backgroundColor = UIColor.htw.mediumOrange
                case .ultimatelyFailed: $0.backgroundColor = UIColor.htw.red
                }
            }
        } else {
            separator.isHidden          = true
            lblLastGradeHeader.isHidden = true
            lblLastGrade.isHidden       = true
        }
    }

}
