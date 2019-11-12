//
//  DashboardTimeTableFreeTableViewCell.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 30.09.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit

class DashboardTimeTableFreeTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var chevron: UIImageView!
    @IBOutlet weak var lblMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.apply {
            $0.backgroundColor      = UIColor.htw.cellBackground
            $0.layer.cornerRadius   = 4
        }
        
        chevron.apply {
            $0.tintColor = UIColor.htw.Icon.primary
        }
        
        lblMessage.apply {
            $0.textColor = UIColor.htw.Label.primary
            $0.text = R.string.localizable.scheduleFreeDay()
        }
    }

}

// MARK: - Loadable
extension DashboardTimeTableFreeTableViewCell: FromNibLoadable {}
