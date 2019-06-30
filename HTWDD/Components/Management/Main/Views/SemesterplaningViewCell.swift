//
//  SemesterplaningViewCell.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 26.06.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit

class SemesterplaningViewCell: UITableViewCell, FromNibLoadable {
    
    // MARK: - Outlets
    @IBOutlet weak var lblSemster: UILabel!
    @IBOutlet weak var lblSemsterYear: UILabel!
    @IBOutlet weak var main: UIView!
    @IBOutlet weak var stackContent: UIStackView!
    
    // MARK: - Properties
    private lazy var descriptionFont: UIFont = {
        return UIFont.boldSystemFont(ofSize: 16)
    }()
    
    private lazy var smallFont: UIFont = {
        return UIFont.systemFont(ofSize: 13.5)
    }()
    
    
    // MARK: - View setup
    func model(for data: SemesterPlaning?) {
        guard let data = data else { return }
        self.stackContent.subviews.forEach { $0.removeFromSuperview() }
        
        self.main.layer.cornerRadius    = 4
        self.main.layer.borderWidth     = 1
        self.main.layer.borderColor     = UIColor.htw.lightGrey.cgColor
        
        // Semestertype ( Sommer or Winter )
        self.lblSemster.apply {
            $0.text         = data.type.localizedDescription
            $0.textColor    = UIColor.htw.darkGrey
        }
        
        // Semester year
        self.lblSemsterYear.apply {
            $0.text         = "\(data.year)"
            $0.textColor    = UIColor.htw.grey
        }
        
        // Semesterperiod ( Header )
        self.stackContent.addArrangedSubview(UILabel().also {
            $0.text         = Loca.Management.Semester.Periods.lectures
            $0.textColor    = UIColor.htw.darkGrey
            $0.font         = self.descriptionFont
        })
        
        // Semesterperiod ( From - To )
        self.stackContent.addArrangedSubview(BadgeLabel().also {
            $0.text             = "\(data.period.beginDayFormated) - \(data.period.endDayFormated)"
            $0.backgroundColor  = UIColor(hex: 0x1976D2)
            $0.textColor        = .white
            $0.font             = self.smallFont
        })
        
        // SPACER
        self.stackContent.addArrangedSubview(UIView())
        
        // Semester Freedays (Header)
        self.stackContent.addArrangedSubview(UILabel().also {
            $0.contentMode      = .scaleToFill
            $0.numberOfLines    = 0
            $0.text             = Loca.Management.Semester.Periods.freedays
            $0.textColor        = UIColor.htw.darkGrey
            $0.font             = self.descriptionFont
        })
        
        // REGION - Freedays
        data.freeDays.forEach { freeDay in
            let hStack          = UIStackView()
            hStack.axis         = .horizontal
            hStack.alignment    = .top
            hStack.distribution = .fillEqually
            
            hStack.addArrangedSubview(UILabel().also { label in
                label.text          = freeDay.name
                label.font          = self.smallFont
                label.textColor     = UIColor.htw.darkGrey
                label.contentMode   = .scaleToFill
                label.numberOfLines = 0
            })
            
            hStack.addArrangedSubview(BadgeLabel().also { label in
                if freeDay.beginDay == freeDay.endDay {
                    label.text = "\(freeDay.beginDayFormated)"
                } else {
                    label.text = "\(freeDay.beginDayFormated) - \(freeDay.endDayFormated)"
                }
                label.font              = self.smallFont
                label.backgroundColor   = UIColor.htw.lightGrey
                label.textColor         = UIColor.htw.darkGrey
                label.contentMode       = .scaleToFill
                label.numberOfLines     = 0
                label.setContentHuggingPriority(.required, for: .horizontal)
            })
            self.stackContent.addArrangedSubview(hStack)
        }
        // ENDREGION - Freedays
        
        // SPACER
        self.stackContent.addArrangedSubview(UIView())
        
        // Exams Period ( Header )
        self.stackContent.addArrangedSubview(UILabel().also {
            $0.text         = Loca.Management.Semester.Periods.exams
            $0.font         = self.descriptionFont
            $0.textColor    = UIColor.htw.darkGrey
        })
        
        // Exams Period ( From - To )
        self.stackContent.addArrangedSubview(BadgeLabel().also {
            $0.text             = "\(data.examsPeriod.beginDayFormated) - \(data.examsPeriod.endDayFormated)"
            $0.textColor        = .white
            $0.font             = self.smallFont
            $0.backgroundColor  = UIColor(hex: 0xE65100, alpha: 0.8)
        })
        
        // SPACER
        self.stackContent.addArrangedSubview(UIView())
        
        // Re-Registration ( Header )
        self.stackContent.addArrangedSubview(UILabel().also {
            $0.text         = Loca.Management.Semester.Periods.reRegistration
            $0.textColor    = UIColor.htw.darkGrey
            $0.font         = descriptionFont
        })
        
        self.stackContent.addArrangedSubview(BadgeLabel().also {
            $0.text             = "\(data.reregistration.beginDayFormated) - \(data.reregistration.endDayFormated)"
            $0.textColor        = .white
            $0.backgroundColor  = UIColor(hex: 0xF44336, alpha: 0.8)
            $0.font             = self.smallFont
        })
    }
}
