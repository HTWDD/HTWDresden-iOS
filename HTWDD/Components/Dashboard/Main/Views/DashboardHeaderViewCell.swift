//
//  DashboardHeaderViewCell.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 30.09.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit

class DashboardHeaderViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblSubheader: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        lblHeader.apply {
            $0.textColor = UIColor.htw.Label.primary
        }
        
        lblSubheader.apply {
            $0.textColor = UIColor.htw.Label.secondary
        }
    }
    
}

// MARK: - Loadable
extension DashboardHeaderViewCell: FromNibLoadable {
    
    func setup(with model: DashboardHeader) {
        lblHeader.text      = model.header
        lblSubheader.text   = model.subheader
    }
    
}
