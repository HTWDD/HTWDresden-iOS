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
    @IBOutlet weak var imageViewChevron: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Main View
        main.apply {
            $0.backgroundColor = UIColor.htw.cellBackground
            $0.layer.cornerRadius   = 4
        }
        
        lblName.apply {
            $0.textColor = UIColor.htw.Label.primary
        }
        
        lblAdress.apply {
            $0.textColor        = UIColor.htw.Label.secondary
            $0.numberOfLines    = 0
            $0.contentMode      = .scaleToFill
        }
        
        lblCity.apply {
            $0.backgroundColor  = UIColor.htw.Badge.secondary
            $0.textColor        = UIColor.htw.Label.secondary
        }
        
        lblMealCount.apply {
            $0.font = UIFont.from(style: .verySmall, isBold: true)
        }
        
        // Meal Icon
        iconMeal.apply {
            $0.tintColor = UIColor.htw.Icon.primary
        }
        
        imageViewChevron.apply {
            $0.tintColor = UIColor.htw.Icon.primary
        }
    }
    
    // MARK: - View setup
    func setup(with model: CanteenDetail) {
        let canteen     = model.canteen
        let hasMeals    = model.meals.count > 0
        
        // Name
        lblName.apply {
            let canteenName     = canteen.name.components(separatedBy: ",").last ?? canteen.name
            iconStar.isHidden   = !canteenName.contains("Reichenbachstraße")
            $0.alpha            = hasMeals ? 1 : 0.5
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
        
        lblAdress.text  = street
        lblCity.text    = city
        // ENDREGINO Adress
        
        // Meal Count
        lblMealCount.apply {
            $0.text             = "\(model.meals.count)"
            $0.textColor        = hasMeals ? UIColor.htw.Label.primary  : .white
            $0.backgroundColor  = hasMeals ? UIColor.htw.Badge.primary : UIColor.htw.redMaterial
        }
        
        // Meal Icon
        iconMeal.apply {
            $0.image        = $0.image?.withRenderingMode(.alwaysTemplate)
        }
    }
    
}
