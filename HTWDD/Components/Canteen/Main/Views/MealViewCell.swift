//
//  MealViewCell.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 11.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit

class MealViewCell: UITableViewCell, FromNibLoadable {
    
    // MARK: - Outlets
    @IBOutlet weak var main: UIView!
    @IBOutlet weak var lblMealName: UILabel!
    @IBOutlet weak var mealStackView: UIStackView!
    @IBOutlet weak var priceStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        // Main View (Background)
        main.apply  {
            $0.layer.cornerRadius   = 4
        }
        
        // Meal Name
        lblMealName.apply {
            $0.textColor        = UIColor.htw.darkGrey
            $0.numberOfLines    = 0
            $0.contentMode      = .scaleToFill
        }
    }
    
    // MARK: - Model Setup
    func setup(with model: Meal?) {
        guard let model = model else { return }
        mealStackView.subviews.forEach { $0.removeFromSuperview() }
        priceStackView.subviews.forEach { $0.removeFromSuperview() }

        // Meal Name
        lblMealName.text = model.name.replacingOccurrences(of: "\n", with: " ")
        
        // REGION Meals
        let hStack = UIStackView().also {
            $0.axis         = .horizontal
            $0.alignment    = .leading
            $0.spacing      = 10
            $0.distribution = .equalSpacing
        }
        
        model.notes.forEach { note in
            if let image = getImage(for: note) {
                hStack.addArrangedSubview(image)
            }
        }
        
        mealStackView.addArrangedSubview(hStack)
        // ENDREGION Meals
        
        
        // REGION Prices
        priceStackView.addArrangedSubview(BadgeLabel().also {
            $0.text             = model.prices.studentsPrice
            $0.font             = UIFont.from(style: .small, isBold: true)
            $0.textColor        = .white
            $0.backgroundColor  = UIColor.htw.mediumOrange
        })
        
        priceStackView.addArrangedSubview(BadgeLabel().also {
            $0.text             = model.prices.employeesPrice
            $0.font             = UIFont.from(style: .small, isBold: true)
            $0.textColor        = .white
            $0.backgroundColor  = UIColor(hex: 0x005c98)
        })
        // ENDREGION Prices
        
    }
    
    
    private func getImage(for containing: String) -> UIView? {
        let imageSize = CGSize(width: 25, height: 25)
        let image: UIImage
        
        switch containing.lowercased().description {
        case let str where str.contains(MealTypes.alc.rawValue.lowercased()): image = #imageLiteral(resourceName: "Alcohol")
        case let str where str.contains(MealTypes.cow.rawValue.lowercased()): image = #imageLiteral(resourceName: "Cow")
        case let str where str.contains(MealTypes.garlic.rawValue.lowercased()): image = #imageLiteral(resourceName: "Garlic")
        case let str where str.contains(MealTypes.pig.rawValue.lowercased()): image = #imageLiteral(resourceName: "Pig")
        case let str where str.contains(MealTypes.vegan.rawValue.lowercased()): image = #imageLiteral(resourceName: "Vegan")
        case let str where str.contains(MealTypes.vegie.rawValue.lowercased()): image = #imageLiteral(resourceName: "Vegan")
        default:
            return nil
        }
        
        let vStack = UIStackView().also {
            $0.axis         = .vertical
            $0.alignment    = .center
            $0.spacing      = 5
        }
        
        vStack.addArrangedSubview(UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20)).also {
            $0.image        = image
            $0.width        = imageSize.width
            $0.height       = imageSize.height
            $0.contentMode  = .left
            if #available(iOS 11.0, *) {
                $0.adjustsImageSizeForAccessibilityContentSizeCategory = true
            }
        })
        
        vStack.addArrangedSubview(BadgeLabel().also {
            $0.text             = localizedDescribingFor(note: containing)
            $0.textColor        = .white
            $0.backgroundColor  = UIColor.htw.darkGrey
            $0.font             = UIFont.from(style: .verySmall, isBold: true)
        })
        
        return vStack
    }
    
    private func localizedDescribingFor(note: String) -> String {
        let contains = note.components(separatedBy: " ").last ?? note
        switch contains.lowercased().description {
        case let str where str.contains(MealTypes.alc.rawValue.lowercased()): return R.string.localizable.canteenMealNoteAlkohol()
        case let str where str.contains(MealTypes.cow.rawValue.lowercased()): return R.string.localizable.canteenMealNoteBeef()
        case let str where str.contains(MealTypes.garlic.rawValue.lowercased()): return R.string.localizable.canteenMealNoteGarlic()
        case let str where str.contains(MealTypes.pig.rawValue.lowercased()): return R.string.localizable.canteenMealNotePork()
        case let str where str.contains(MealTypes.vegan.rawValue.lowercased()): return R.string.localizable.canteenMealNoteVegan()
        case let str where str.contains(MealTypes.vegie.rawValue.lowercased()): return R.string.localizable.canteenMealNoteVegatarian()
        default:
            return contains
        }
    }
    
    // MARK: MealTypes [Note]
    enum MealTypes: String {
        case alc    = "Alkohol"
        case cow    = "Rind"
        case pig    = "Schwein"
        case garlic = "Knoblauch"
        case vegan  = "Vegan"
        case vegie  = "Vegetarisch"
    }
}
