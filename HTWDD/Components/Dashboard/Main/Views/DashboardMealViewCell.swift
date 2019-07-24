//
//  DashboardMealViewCell.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 18.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit

class DashboardMealViewCell: UITableViewCell, FromNibLoadable {
    
    // MARK: - Outlets
    @IBOutlet weak var main: UIView!
    @IBOutlet weak var lblMealName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        main.apply {
            $0.layer.cornerRadius   = 4
        }
        
        lblMealName.apply {
            $0.numberOfLines    = 0
            $0.contentMode      = .scaleToFill
            $0.textColor        = UIColor.htw.darkGrey
        }
    }
    
    // MARK: - Setup
    func setup(with model: Meal) {
        lblMealName.text = model.name
    }
}
