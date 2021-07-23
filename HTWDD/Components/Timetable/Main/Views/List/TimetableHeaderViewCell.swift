//
//  TimetableHeaderViewCell.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 01.10.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit

class TimetableHeaderViewCell: UITableViewCell {

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
extension TimetableHeaderViewCell: FromNibLoadable {
    
    func setup(with model: TimetableHeader) {
        lblHeader.text      = model.headerLocalized
        lblSubheader.text   = model.subheaderLocalized
    }
    
}
