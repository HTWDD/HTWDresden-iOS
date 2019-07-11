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
    
    // MARK: - View setup
    func model(for model: CanteenDetails) {
        let canteen = model.canteen
        
        // Main View
        main.apply {
            $0.layer.cornerRadius   = 4
            $0.layer.borderWidth    = 1
            $0.layer.borderColor    = UIColor.htw.lightGrey.cgColor
        }
        
        // Name
        lblName.apply {
            $0.textColor    = UIColor.htw.darkGrey
            $0.text         = canteen.name.components(separatedBy: ",").last ?? canteen.name
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
            $0.font             = UIFont.small(isBold: true)
        }
        // ENDREGINO Adress
        
        // Meal Count
        lblMealCount.apply {
            $0.text             = "\(model.meals.count)"
            $0.textColor        = UIColor.htw.darkGrey
            $0.backgroundColor  = UIColor.htw.lightGrey
        }
        
        // Meal Icon
        iconMeal.apply {
            $0.image        = $0.image?.withRenderingMode(.alwaysTemplate)
            $0.tintColor    = UIColor.htw.darkGrey
        }
    }
    
}
