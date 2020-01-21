//
//  DashboardMealViewCell.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 18.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit

class DashboardMealViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var lblPrice: BadgeLabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var icForkAndKnife: UIImageView!
    @IBOutlet weak var lblCategorie: BadgeLabel!
    
       
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView.apply {
            $0.backgroundColor      = UIColor.htw.cellBackground
            $0.layer.cornerRadius   = 4
        }
        
        lblPrice.apply {
            $0.textColor        = .white
            $0.backgroundColor  = UIColor.htw.Material.orange
        }
        
        lblName.apply {
            $0.textColor = UIColor.htw.Label.primary
        }
        
        icForkAndKnife.apply {
            $0.tintColor    = UIColor.htw.Icon.primary
            $0.image        = $0.image?.withRenderingMode(.alwaysTemplate)
        }
        
        lblCategorie.apply {
            $0.textColor        = UIColor.htw.Label.primary
            $0.backgroundColor  = UIColor.htw.Badge.primary
        }
    }
}


extension DashboardMealViewCell: FromNibLoadable {
    
    func setup(with model: Meal) {
        lblPrice.text               = model.prices.studentsPrice
        lblName.text                = model.name
        separator.backgroundColor   = model.category.materialColor
        lblCategorie.text           = model.category
    }
    
}

