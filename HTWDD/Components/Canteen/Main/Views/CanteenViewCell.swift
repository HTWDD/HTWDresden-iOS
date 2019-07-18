//
//  CanteenViewCell.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 10.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit

class CanteenViewCell: UITableViewCell, FromNibLoadable {

    // MARK: - Outlets
    @IBOutlet weak var main: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAdress: UILabel!
    @IBOutlet weak var lblCity: BadgeLabel!
    @IBOutlet weak var lblMealCount: BadgeLabel!
    @IBOutlet weak var iconMeal: UIImageView!
    @IBOutlet weak var iconStar: UIImageView!
    @IBOutlet weak var lblNameConstraint: NSLayoutConstraint!
    
    // MARK: - View setup
    func model(for model: CanteenDetails) {
        let canteen     = model.canteen
        let hasMeals    = model.meals.count > 0
        
        // Main View
        main.apply {
            $0.layer.cornerRadius   = 4
            $0.layer.borderWidth    = 1
            $0.layer.borderColor    = UIColor.htw.lightGrey.cgColor
        }
        
        // Name
        lblName.apply {
            let canteenName     = canteen.name.components(separatedBy: ",").last ?? canteen.name
            iconStar.isHidden   = !canteenName.contains("Reichenbachstraße")
            $0.textColor        = hasMeals ? UIColor.htw.darkGrey : UIColor.htw.grey
            $0.text             = canteenName.replacingOccurrences(of: "Johannesstadt", with: "Johannstadt")
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        if iconStar.isHidden {
            lblNameConstraint.constant = 8
            main.layoutIfNeeded()
        } else {
            lblNameConstraint.constant = 36
            main.layoutIfNeeded()
        }
        
        // REGION Adress
        let adressComponents = canteen.address.components(separatedBy: ",")
        let street = adressComponents.first ?? canteen.address
        let city = adressComponents[1].components(separatedBy: " ").last
        
        lblAdress.apply {
            $0.textColor        = UIColor.htw.grey
            $0.text             = street
            $0.numberOfLines    = 0
            $0.contentMode      = .scaleToFill
        }
        
        // City
        lblCity.apply {
            $0.text             = city
            $0.backgroundColor  = UIColor.htw.mediumOrange
            $0.textColor        = UIColor.white
            $0.font             = UIFont.from(style: .small, isBold: true)
        }
        // ENDREGINO Adress
        
        // Meal Count
        lblMealCount.apply {
            $0.text             = "\(model.meals.count)"
            $0.textColor        = hasMeals ? UIColor.htw.darkGrey  : .white
            $0.backgroundColor  = hasMeals ? UIColor.htw.lightGrey : UIColor.htw.redMaterial
            $0.font             = UIFont.from(style: .verySmall, isBold: true)
        }
        
        // Meal Icon
        iconMeal.apply {
            $0.image        = $0.image?.withRenderingMode(.alwaysTemplate)
            $0.tintColor    = UIColor.htw.darkGrey
        }
    }
    
}
