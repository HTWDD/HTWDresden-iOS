//
//  DashboardMealsViewCell.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 30.09.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit

class DashboardMealsViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainStack: UIStackView!
    @IBOutlet weak var chevron: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.apply {
            $0.backgroundColor      = UIColor.htw.cellBackground
            $0.layer.cornerRadius   = 4
        }
        
        chevron.apply {
            $0.tintColor = UIColor.htw.Icon.primary
        }
    }

}

// MARK: - Loadable
extension DashboardMealsViewCell: FromNibLoadable {
    
    func setup(with models: [Meal]) {
        mainStack.subviews.forEach { $0.removeFromSuperview() }
        
        models.forEach { meal in
            
            let cell = R.nib.dashboardMealViewCell.firstView(owner: self)!
            cell.setup(with: meal)
            mainStack.addArrangedSubview(cell.contentView)
        }
            
        mainStack.htw.addHorizontalSeparators()
    }
}
