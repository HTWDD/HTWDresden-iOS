//
//  TimetableDetailsSectionHeader.swift
//  HTWDD
//
//  Created by Chris Herlemann on 29.01.21.
//  Copyright © 2021 HTW Dresden. All rights reserved.
//

import Foundation
class TimetableDetailsSectionHeader: UITableViewHeaderFooterView {
    
    let title = UILabel()
    let background = UIView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    func configureContents() {
        
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle == .light {
                contentView.backgroundColor = UIColor.htw.veryLightGrey
            }
        } else {
            contentView.backgroundColor = UIColor.htw.veryLightGrey
        }
        
        background.backgroundColor = UIColor.htw.cellBackground
        
        if #available(iOS 11.0, *) {
            background.layer.cornerRadius = 6
            background.layer.masksToBounds = true
            background.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        background.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(background)
        contentView.addSubview(title)
        
        NSLayoutConstraint.activate([
            background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            background.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            title.heightAnchor.constraint(equalToConstant: 20),
            title.leadingAnchor.constraint(equalTo: background.leadingAnchor,
                                           constant: 16),
            title.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -14),
            title.centerYAnchor.constraint(equalTo: background.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
