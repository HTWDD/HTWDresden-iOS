//
//  SemesterplaningViewCell.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 26.06.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit
import Moya
import RxSwift

class SemesterplaningViewCell: UITableViewCell, FromNibLoadable {
    
    // MARK: - Outlets
    @IBOutlet weak var lblSemster: UILabel!
    @IBOutlet weak var lblSemsterYear: UILabel!
    @IBOutlet weak var main: UIView!
    @IBOutlet weak var stackContent: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        main.layer.cornerRadius    = 4
        
        // Semestertype ( Sommer or Winter )
        lblSemster.apply {
            $0.textColor    = UIColor.htw.darkGrey
        }
        
        // Semester year
        lblSemsterYear.apply {
            $0.textColor    = UIColor.htw.grey
        }
    }
    
    // MARK: - View setup
    func setup(with data: SemesterPlaning?) {
        guard let data = data else { return }
        stackContent.subviews.forEach { $0.removeFromSuperview() }
        
        // Semestertype ( Sommer or Winter )
        lblSemster.text = data.type.localizedDescription
        
        // Semester year
        lblSemsterYear.text = "\(data.year)"
        
        // Semesterperiod ( Header )
        stackContent.addArrangedSubview(UILabel().also {
            $0.text         = R.string.localizable.managementSemesterPeriodsLectures()
            $0.textColor    = UIColor.htw.darkGrey
            $0.font         = UIFont.from(style: .description, isBold: true)
        })
        
        // Semesterperiod ( From - To )
        stackContent.addArrangedSubview(BadgeLabel().also {
            $0.text             = "\(data.period.beginDayFormated) - \(data.period.endDayFormated)"
            $0.backgroundColor  = UIColor(hex: 0x1976D2)
            $0.textColor        = .white
            $0.font             = UIFont.from(style: .small, isBold: true)
        })
        
        // SPACER
        stackContent.addArrangedSubview(UIView())
        
        // Semester Freedays (Header)
        stackContent.addArrangedSubview(UILabel().also {
            $0.contentMode      = .scaleToFill
            $0.numberOfLines    = 0
            $0.text             = R.string.localizable.managementSemesterPeriodsFreedays()
            $0.textColor        = UIColor.htw.darkGrey
            $0.font             = UIFont.from(style: .description, isBold: true)
        })
        
        // REGION - Freedays
        data.freeDays.forEach { freeDay in
            let hStack          = UIStackView()
            hStack.axis         = .horizontal
            hStack.alignment    = .top
            hStack.distribution = .fillEqually
            
            hStack.addArrangedSubview(UILabel().also { label in
                label.text          = freeDay.name
                label.font          = UIFont.from(style: .small)
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
                label.font              = UIFont.from(style: .small)
                label.backgroundColor   = UIColor.htw.lightGrey
                label.textColor         = UIColor.htw.darkGrey
                label.contentMode       = .scaleToFill
                label.numberOfLines     = 0
                label.setContentHuggingPriority(.required, for: .horizontal)
            })
            stackContent.addArrangedSubview(hStack)
        }
        // ENDREGION - Freedays
        
        // SPACER
        stackContent.addArrangedSubview(UIView())
        
        // Exams Period ( Header )
        stackContent.addArrangedSubview(UILabel().also {
            $0.text         = R.string.localizable.managementSemesterPeriodsExams()
            $0.font         = UIFont.from(style: .description, isBold: true)
            $0.textColor    = UIColor.htw.darkGrey
        })
        
        // Exams Period ( From - To )
        stackContent.addArrangedSubview(BadgeLabel().also {
            $0.text             = "\(data.examsPeriod.beginDayFormated) - \(data.examsPeriod.endDayFormated)"
            $0.textColor        = .white
            $0.font             = UIFont.from(style: .small, isBold: true)
            $0.backgroundColor  = UIColor.htw.mediumOrange
        })
        
        // SPACER
        stackContent.addArrangedSubview(UIView())
        
        // Re-Registration ( Header )
        stackContent.addArrangedSubview(UILabel().also {
            $0.text         = R.string.localizable.managementSemesterPeriodsReregistration()
            $0.textColor    = UIColor.htw.darkGrey
            $0.font         = UIFont.from(style: .description, isBold: true)
        })
        
        // Re-Registration ( From - To )
        stackContent.addArrangedSubview(BadgeLabel().also {
            $0.text             = "\(data.reregistration.beginDayFormated) - \(data.reregistration.endDayFormated)"
            $0.textColor        = .white
            $0.backgroundColor  = UIColor(hex: 0xF57F17, alpha: 0.8)
            $0.font             = UIFont.from(style: .small, isBold: true)
        })
    }
}
