//
//  MealHeaderViewCell.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 27.09.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit

class MealHeaderViewCell: UITableViewCell {

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
extension MealHeaderViewCell: FromNibLoadable {
    
    func setup(with model: MealHeader) {
        
        lblHeader.apply {
            $0.text = model.header
        }
        
        lblSubheader.apply {
            $0.text = model.subheader
        }
    }
    
}
