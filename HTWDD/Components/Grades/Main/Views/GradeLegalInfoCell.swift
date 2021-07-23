//
//  GradeLegalInfoCell.swift
//  HTWDD
//
//  Created by Chris Herlemann on 21.07.21.
//  Copyright © 2021 HTW Dresden. All rights reserved.
//

import UIKit

class GradeLegalInfoCell: UITableViewCell, FromNibLoadable {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblLegalInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = .clear
        
        mainView.apply {
            $0.layer.cornerRadius   = 4
            $0.backgroundColor      = UIColor.htw.cellBackground
        }
        
        lblLegalInfo.text = R.string.localizable.gradesLegalInfo()
    }

}
