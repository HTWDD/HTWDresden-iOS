//
//  CampusPlanViewCell.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 25.09.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit

class CampusPlanViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var main: UIView!
    @IBOutlet weak var lblBuilding: UILabel!
    @IBOutlet weak var lblBuildingsCount: UILabel!
    @IBOutlet weak var mainStack: UIStackView!
    var campusPlanViewController: CampusPlanViewController?
    private var campusPlanImageView: UIImageView?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        main.apply {
            $0.layer.cornerRadius   = 4
            $0.backgroundColor      = UIColor.htw.cellBackground
            $0.dropShadow()
        }
        
        lblBuilding.apply {
            $0.textColor = UIColor.htw.Label.primary
        }
        
        lblBuildingsCount.apply {
            $0.textColor = UIColor.htw.Label.secondary
        }
    }
    
}

// MARK: - Loadable
extension CampusPlanViewCell: FromNibLoadable {
    
    func setup(with model: CampusPlan) {
        mainStack.subviews.forEach { $0.removeFromSuperview() }
        
        lblBuilding.apply {
            $0.text = model.building
        }
        
        lblBuildingsCount.apply {
            $0.text = R.string.localizable.campusPlanBuildings(model.buildings.count)
        }
        
        let image: UIImage
        switch model.image {
        case 1: image   = #imageLiteral(resourceName: "Friedrich-List-Platz")
        default: image  = #imageLiteral(resourceName: "Pillnitz")
        }
        
        //let zImage = ZoomableImageView(frame: CGRect(x: 0, y: 0, width: mainStack.frame.width, height: 250), image: image)
        campusPlanImageView = UIImageView(image: image).also {
            $0.contentMode              = .scaleAspectFill
            $0.clipsToBounds            = true
            $0.layer.cornerRadius       = 6
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animate)))
        }

        mainStack.addArrangedSubview(campusPlanImageView!)
        
        model.buildings.forEach { building in
            
            let chunks = building.components(separatedBy: ":")
            
            let legend = BadgeLabel().also {
                $0.text             = chunks.first?.nilWhenEmpty ?? ""
                $0.textColor        = UIColor.htw.Label.primary
                $0.font             = UIFont.htw.Badges.primary
                $0.backgroundColor  = UIColor.htw.Badge.primary
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.widthAnchor.constraint(equalToConstant: 30).isActive = true
            }
            
            let description = UILabel().also {
                $0.text             = chunks.last?.nilWhenEmpty ?? ""
                $0.textColor        = UIColor.htw.Label.secondary
                $0.font             = UIFont.htw.Labels.secondary
            }
            
            mainStack.addArrangedSubview(UIStackView(arrangedSubviews: [legend, description]).also {
                $0.axis         = .horizontal
                $0.alignment    = .fill
                $0.distribution = .fill
                $0.spacing      = 10
            })
            
        }
        
        NSLayoutConstraint.activate([
            campusPlanImageView!.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor, constant: 0),
            campusPlanImageView!.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: 0),
            campusPlanImageView!.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    @objc private func animate() {
        campusPlanViewController?.animateUIImageView(campusPlanImageView)
    }
    
}
