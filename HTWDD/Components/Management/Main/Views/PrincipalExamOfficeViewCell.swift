//
//  PrincipalExamOfficeViewCell.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 01.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit

class PrincipalExamOfficeViewCell: UITableViewCell, FromNibLoadable {
    
    // MARK: - Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var main: UIView!
    @IBOutlet weak var stackContent: UIStackView!
    
    
    func model(for data: PrincipalExamOffice?) {
        guard let data = data else { return }
        self.stackContent.subviews.forEach { $0.removeFromSuperview() }
        
        // Main View (Background)
        self.main.apply {
            $0.layer.cornerRadius   = 4
            $0.layer.borderWidth    = 1
            $0.layer.borderColor    = UIColor.htw.lightGrey.cgColor
        }
        
        // Title
        self.lblTitle.apply {
            $0.text         = R.string.localizable.managementStudentAdministrationPrincipalExamOffice()
            $0.textColor    = UIColor.htw.darkGrey
        }
        
        // Subtitle
        self.lblSubtitle.apply {
            $0.textColor = UIColor.htw.grey
        }
        
        // Offered Services
        self.stackContent.addArrangedSubview(UILabel().also {
            $0.text         = R.string.localizable.managementStudentAdministrationOfferedServices()
            $0.textColor    = UIColor.htw.darkGrey
            $0.font         = UIFont.from(style: .description, isBold: true)
        })
        
        // REGION - Offered Services
        data.offeredServices.forEach { service in
            self.stackContent.addArrangedSubview(BadgeLabel().also {
                $0.text             = service
                $0.backgroundColor  = UIColor(hex: 0xE0E0E0)
                $0.textColor        = UIColor.htw.darkGrey
                $0.font             = UIFont.from(style: .small)
                $0.contentMode      = .scaleToFill
                $0.numberOfLines    = 0
            })
        }
        // ENDREGION - Offered Services
        
        // SPACER
        self.stackContent.addArrangedSubview(UIView())
        
        // Opening Hours
        self.stackContent.addArrangedSubview(UILabel().also {
            $0.text         = R.string.localizable.managementStudentAdministrationOpeningHours()
            $0.textColor    = UIColor.htw.darkGrey
            $0.font         = UIFont.from(style: .description, isBold: true)
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
                $0.textColor    = UIColor.htw.darkGrey
                $0.font         = UIFont.from(style: .small)
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
                    label.font              = UIFont.from(style: .small)
                    label.backgroundColor   = UIColor.htw.lightGrey
                    label.textColor         = UIColor.htw.darkGrey
                    label.contentMode       = .scaleToFill
                })
            }
            // ENDREGION - Times
            
            hStack.addArrangedSubview(vStack)
            
            self.stackContent.addArrangedSubview(hStack)
        }
        // ENDREGION - Opening Hours
        
        // SPACER
        self.stackContent.addArrangedSubview(UIView())
        self.stackContent.addArrangedSubview(UIView())
        self.stackContent.addArrangedSubview(UIView())
    }
}
