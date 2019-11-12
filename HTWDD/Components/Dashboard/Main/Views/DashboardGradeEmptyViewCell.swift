//
//  DashboardGradeEmptyViewCell.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 30.09.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit

class DashboardGradeEmptyViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var chevron: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.apply {
            $0.backgroundColor      = UIColor.htw.cellBackground
            $0.layer.cornerRadius   = 4
        }
        
        lblTitle.apply {
            $0.textColor    = UIColor.htw.Label.primary
            $0.text         = R.string.localizable.gradesNoResultsTitle()
        }
        
        lblMessage.apply {
            $0.textColor    = UIColor.htw.Label.secondary
            $0.text         = R.string.localizable.gradesNoResultsMessage()
        }
        
        chevron.apply {
            $0.tintColor = UIColor.htw.Icon.primary
        }
    }
    
}

// MARK: - Loadable
extension DashboardGradeEmptyViewCell: FromNibLoadable {}
