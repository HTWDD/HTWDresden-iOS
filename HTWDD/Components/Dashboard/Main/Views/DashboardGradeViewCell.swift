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
    @IBOutlet weak var lblGrades: BadgeLabel!
    @IBOutlet weak var lblCredits: BadgeLabel!
    @IBOutlet weak var chevron: UIImageView!
    @IBOutlet weak var lblExamName: UILabel!
    @IBOutlet weak var lblGrade: UILabel!
    @IBOutlet weak var lblState: BadgeLabel!
    @IBOutlet weak var separator: UIView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        main.apply {
            $0.layer.cornerRadius   = 4
            $0.backgroundColor      = UIColor.htw.cellBackground
        }
        
        chevron.apply {
            $0.tintColor = UIColor.htw.Icon.primary
        }
        
        lblGrades.apply {
            $0.textColor        = UIColor.htw.Label.secondary
            $0.backgroundColor  = UIColor.htw.Badge.secondary
        }
        
        lblCredits.apply {
            $0.textColor        = UIColor.htw.Label.secondary
            $0.backgroundColor  = UIColor.htw.Badge.secondary
        }
        
        lblExamName.apply {
            $0.textColor = UIColor.htw.Label.primary
        }
        
        lblGrade.apply {
            $0.textColor = UIColor.htw.Label.secondary
        }
        
        lblState.apply {
            $0.backgroundColor  = UIColor.htw.Badge.primary
            $0.textColor        = UIColor.htw.Badge.primary
        }
    }
    
    // MARK: - Setup
    func setup(with model: DashboardGrade) {
        lblGrades.text  = model.gradesLocalized
        lblCredits.text = model.creditsLocalized
        
        if let grade = model.lastGrade {
            lblExamName.text = grade.examination
            lblGrade.text = Double(grade.grade ?? 0) > 0 ? "\(Double(grade.grade ?? 0) / 100)" : "-/-"
            lblState.apply {
                $0.text      = grade.state.localizedDescription
                $0.textColor = .white
                switch grade.state {
                case .enrolled:
                    $0.backgroundColor          = UIColor.htw.Material.blue
                    separator.backgroundColor   = UIColor.htw.Material.blue
                case .passed:
                    $0.backgroundColor          = UIColor.htw.Material.green
                    separator.backgroundColor   = UIColor.htw.Material.green
                case .failed:
                    $0.backgroundColor          = UIColor.htw.Material.red
                    separator.backgroundColor   = UIColor.htw.Material.red
                case .finalFailed:
                    $0.backgroundColor          = .black
                    separator.backgroundColor   = .black
                case .unkown:
                    $0.backgroundColor          = UIColor.htw.Material.orange
                    separator.backgroundColor   = UIColor.htw.Material.orange
                }
            }
        } else {
            lblExamName.text = R.string.localizable.gradesNoResultsTitle()
            lblGrade.text = "-/-"
            lblState.text = R.string.localizable.gradesRemarkUnkown()
        }
    }

}
