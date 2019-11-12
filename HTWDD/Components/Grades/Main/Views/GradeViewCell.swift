//
//  GradeViewCell.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 29.09.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit

class GradeViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblGrade: UILabel!
    @IBOutlet weak var lblExamination: UILabel!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var lblTryCount: UILabel!
    @IBOutlet weak var lblExamDate: UILabel!
    @IBOutlet weak var lblCredits: BadgeLabel!
    @IBOutlet weak var lblRemark: BadgeLabel!
    @IBOutlet weak var lblType: BadgeLabel!
    @IBOutlet weak var lblState: BadgeLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView.apply {
            $0.layer.cornerRadius   = 4
            $0.backgroundColor      = UIColor.htw.cellBackground
        }
        
        lblGrade.apply {
            $0.textColor = UIColor.htw.Label.primary
        }
        
        lblExamination.apply {
            $0.textColor = UIColor.htw.Label.primary
        }
        
        lblTryCount.apply {
            $0.textColor = UIColor.htw.Label.secondary
        }
        
        lblExamDate.apply {
            $0.textColor = UIColor.htw.Label.secondary
        }
        
        lblCredits.apply {
            $0.textColor        = UIColor.htw.Label.primary
            $0.backgroundColor  = UIColor.htw.Badge.primary
        }
        
        lblRemark.apply {
            $0.textColor        = UIColor.htw.Label.secondary
            $0.backgroundColor  = UIColor.htw.Badge.secondary
        }
        
        lblType.apply {
            $0.textColor        = UIColor.htw.Label.secondary
            $0.backgroundColor  = UIColor.htw.Badge.secondary
        }
        
        lblState.apply {
            $0.textColor = .white
        }
        
    }
    
}

// MARK: - Loadable
extension GradeViewCell: FromNibLoadable {
    func setup(with model: Grade) {
        let grade = Double(model.grade ?? 0) > 0 ? Double(model.grade ?? 0) / 100.0 : 0
        
        lblGrade.apply {
            $0.text = grade > 0 ? "\(grade)" : "-/-"
            $0.alpha = grade > 0 ? 1 : 0.15
        }
        
        switch model.state {
        case .enrolled:
            separator.backgroundColor   = UIColor.htw.Material.blue
            lblState.backgroundColor    = UIColor.htw.Material.blue
        case .passed:
            separator.backgroundColor   = UIColor.htw.Material.green
            lblState.backgroundColor    = UIColor.htw.Material.green
        case .failed:
            separator.backgroundColor   = UIColor.htw.Material.red
            lblState.backgroundColor    = UIColor.htw.Material.red
        case .finalFailed:
            separator.backgroundColor   = .black
            lblState.backgroundColor    = .black
        case .unkown:
            separator.backgroundColor   = UIColor.htw.Material.orange
            lblState.backgroundColor    = UIColor.htw.Material.orange
        }
        
        lblExamination.text = model.examination
        lblTryCount.text    = R.string.localizable.gradesDetailTries(model.tries)
        
        let dateString: String
        if let date = model.examDate {
            do {
                dateString = try Date.from(string: date, format: "yyyy-MM-dd'T'HH:mmZ").string(format: "dd.MM.yyyy")
            } catch {
                dateString = R.string.localizable.gradesDetailNoDate()
            }
        } else {
            dateString = R.string.localizable.gradesDetailNoDate()
        }
        
        lblExamDate.text    = dateString
        lblCredits.text     = R.string.localizable.gradesDetailCredits(model.credits)
        lblRemark.text      = model.remark?.localizedDescription ?? R.string.localizable.gradesDetailNoNote()
        lblType.text        = model.typeOfExamination
        lblState.text       = model.state.localizedDescription
    }
}
