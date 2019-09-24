//
//  StuRaHTWViewCell.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 01.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit

class StuRaHTWViewCell: UITableViewCell, FromNibLoadable {
    
    // MARK: - Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var main: UIView!
    @IBOutlet weak var stackContent: UIStackView!
    
    // MARK: - Properties
    private var link: URL? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Main View (Background)
        main.apply {
            $0.layer.cornerRadius   = 4
            $0.backgroundColor      = UIColor.htw.cellBackground
        }
        
        // Title
        lblTitle.apply {
            $0.textColor    = UIColor.htw.Label.primary
        }
        
        // Subtitle
        lblSubtitle.apply {
            $0.textColor = UIColor.htw.Label.secondary
        }
    }
    
    // MARK: - Setup
    func setup(with data: StuRaHTW?) {
        guard let data = data else { return }
        link = URL(string: data.link)
        stackContent.subviews.forEach { $0.removeFromSuperview() }
        
        // Offered Services
        stackContent.addArrangedSubview(UILabel().also {
            $0.text         = R.string.localizable.managementStudentAdministrationOfferedServices()
            $0.textColor    = UIColor.htw.Label.primary
            $0.font         = UIFont.htw.Labels.primary
        })
        
        // REGION - Offered Services
        data.offeredServices.forEach { service in
            stackContent.addArrangedSubview(BadgeLabel().also {
                $0.text             = service
                $0.backgroundColor  = UIColor.htw.Badge.primary
                $0.textColor        = UIColor.htw.Label.primary
                $0.font             = UIFont.htw.Badges.primary
                $0.contentMode      = .scaleToFill
                $0.numberOfLines    = 0
            })
        }
        // ENDREGION - Offered Services
        
        // SPACER
        stackContent.addArrangedSubview(UIView())
        
        // Opening Hours
        stackContent.addArrangedSubview(UILabel().also {
            $0.text         = R.string.localizable.managementStudentAdministrationOpeningHours()
            $0.textColor    = UIColor.htw.Label.primary
            $0.font         = UIFont.htw.Labels.primary
        })
        
        // REGION - Opening Hours
        data.officeHours.forEach { time in
            let hStack = UIStackView().also {
                $0.axis         = .horizontal
                $0.alignment    = .top
                $0.distribution = .fillEqually
            }
            
            hStack.addArrangedSubview(UILabel().also {
                $0.text         = time.day.localizedDescription
                $0.textColor    = UIColor.htw.Label.secondary
                $0.font         = UIFont.htw.Labels.secondary
            })
            
            let vStack = UIStackView().also {
                $0.axis         = .vertical
                $0.alignment    = .fill
                $0.distribution = .fill
                $0.spacing      = 8
                $0.setContentHuggingPriority(.required, for: .horizontal)
            }
            
            // REGION - Times
            time.times.forEach { openingTime in
                vStack.addArrangedSubview(BadgeLabel().also { label in
                    label.text              = R.string.localizable.managementStudentAdministrationOpeningTimes(openingTime.begin, openingTime.end)
                    label.font              = UIFont.htw.Badges.primary
                    label.backgroundColor   = UIColor.htw.Badge.secondary
                    label.textColor         = UIColor.htw.Label.secondary
                    label.contentMode       = .scaleToFill
                })
            }
            // ENDREGION - Times
            
            hStack.addArrangedSubview(vStack)
            
            stackContent.addArrangedSubview(hStack)
        }
        // ENDREGION - Opening Hours
        
        stackContent.addArrangedSubview(UIView())
        
        stackContent.addArrangedSubview(UIButton().also {
            $0.titleLabel?.font     = UIFont.from(style: .small, isBold: true)
            $0.layer.cornerRadius   = 4
            $0.backgroundColor      = UIColor.htw.lightBlueMaterial
            $0.contentEdgeInsets    = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            $0.makeDropShadow()
            $0.setTitleColor(.white, for: .normal)
            $0.setTitle(R.string.localizable.visit_website(), for: .normal)
            $0.addTarget(self, action: #selector(visitLink), for: .touchUpInside)
        })
        
        // SPACER
        stackContent.addArrangedSubview(UIView())
    }
    
    @objc private func visitLink() {
        UIApplication.shared.open(link!, options: [:], completionHandler: nil)
    }
}
