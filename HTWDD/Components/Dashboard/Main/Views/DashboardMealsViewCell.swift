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
            let hStack = UIStackView().also {
                $0.axis     = .horizontal
                $0.spacing  = 8
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
            
            
            hStack.addArrangedSubview(UIImageView(image: #imageLiteral(resourceName: "CanteenSmall")).also {
                $0.image        = $0.image?.withRenderingMode(.alwaysTemplate)
                $0.tintColor    = UIColor.htw.Icon.primary
                $0.alpha        = 0.5
                $0.contentMode  = .top
                $0.frame = CGRect(x: 0, y: 8, width: 12, height: 12)
            })
            
            let vStack = UIStackView().also {
                $0.axis         = .vertical
                $0.spacing      = 8
                $0.distribution = .fill
                $0.alignment    = .fill
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
            
            vStack.addArrangedSubview(UILabel().also {
                $0.text             = meal.name
                $0.font             = UIFont.systemFont(ofSize: 13)
                $0.contentMode      = .scaleAspectFill
                $0.numberOfLines    = 0
            })
            
            let badgeHStack = UIStackView().also {
                $0.axis = .horizontal
                $0.spacing = 4
                $0.distribution = .fillEqually
            }
            
            badgeHStack.addArrangedSubview(BadgeLabel().also {
                $0.text             = meal.category
                $0.font             = UIFont.htw.Badges.primary
                $0.backgroundColor  = UIColor.htw.Badge.primary
                $0.textColor        = UIColor.htw.Label.primary
            })
            
            badgeHStack.addArrangedSubview(BadgeLabel().also {
                $0.text             = meal.prices.studentsPrice
                $0.font             = UIFont.htw.Badges.primary
                $0.backgroundColor  = UIColor.htw.Material.orange
                $0.textColor        = .white
            })
            
            badgeHStack.addArrangedSubview(BadgeLabel().also {
                $0.text             = meal.prices.employeesPrice
                $0.font             = UIFont.htw.Badges.primary
                $0.backgroundColor  = UIColor.htw.Material.blue
                $0.textColor        = .white
            })
            
            vStack.addArrangedSubview(badgeHStack)
            
            hStack.addArrangedSubview(vStack)
            
            mainStack.addArrangedSubview(hStack)
            
            
            
        }
    }
}
