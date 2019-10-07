//
//  MealsViewCell.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 02.10.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit

class MealViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var lblPrice: BadgeLabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var icForkAndKnife: UIImageView!
    @IBOutlet weak var mealStackView: UIStackView!
    
    
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
    }

}

// MARK: - Loadable
extension MealViewCell: FromNibLoadable {
    
    func setup(with model: Meal) {
        mealStackView.subviews.forEach { $0.removeFromSuperview() }
        
        lblPrice.text               = model.prices.studentsPrice
        lblName.text                = model.name
        separator.backgroundColor   = model.category.materialColor
        
        model.notes.forEach { note in
            if let image = getImage(for: note) {
                mealStackView.addArrangedSubview(image)
            }
        }
        
    }
    
    
    private func getImage(for containing: String) -> UIView? {
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
        
        return BadgeLabel().also { badge in
            badge.attributedText   = NSMutableAttributedString(string: localizedDescribingFor(note: containing), attributes: [.font: UIFont.htw.Badges.primary]).also { attributed in
                attributed.insert(NSAttributedString(attachment: NSTextAttachment().also { attachment in
                    attachment.image    = image
                    attachment.bounds   = CGRect(x: -5, y: -6, width: 20, height: 20)
                }), at: 0)
            }
            badge.backgroundColor  = UIColor.htw.Badge.primary
            badge.cornerRadius     = 8
            badge.textColor        = UIColor.htw.Label.secondary
            badge.setContentHuggingPriority(.required, for: .horizontal)
        }
    
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
