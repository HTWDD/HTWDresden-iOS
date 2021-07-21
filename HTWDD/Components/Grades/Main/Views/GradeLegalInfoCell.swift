//
//  GradeLegalInfoCell.swift
//  HTWDD
//
//  Created by Chris Herlemann on 21.07.21.
//  Copyright © 2021 HTW Dresden. All rights reserved.
//

import UIKit

class GradeLegalInfoCell: UITableViewCell, FromNibLoadable {

    @IBOutlet weak var lblLegalInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = .clear
        
        lblLegalInfo.text = R.string.localizable.gradesLegalInfo()
    }

}
