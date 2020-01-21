//
//  DashboardGradeNoCredentialsViewCell.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 30.09.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit

class DashboardGradeNoCredentialsViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblNoLoginTitle: UILabel!
    @IBOutlet weak var lblNoLoginMessage: UILabel!
    @IBOutlet weak var chevron: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.apply {
            $0.backgroundColor      = UIColor.htw.cellBackground
            $0.layer.cornerRadius   = 4
        }
        
        lblNoLoginTitle.apply {
            $0.textColor    = UIColor.htw.Label.primary
            $0.text         = R.string.localizable.gradesNoCredentialsTitle()
        }
        
        lblNoLoginMessage.apply {
            $0.textColor    = UIColor.htw.Label.secondary
            $0.text         = R.string.localizable.gradesNoCredentialsMessage()
        }
        
        chevron.apply {
            $0.tintColor = UIColor.htw.Icon.primary
        }
    }

}

// MARK: - Loadable
extension DashboardGradeNoCredentialsViewCell: FromNibLoadable {}
