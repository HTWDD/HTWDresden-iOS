//
//  UITableViews.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 27.06.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation

extension UITableView {
    func register<T: FromNibLoadable>(_ type: T.Type) {
        self.register(type.nib, forCellReuseIdentifier: type.identifier)
    }
    
    func dequeueReusableCell<T: FromNibLoadable>(_ type: T.Type, for indexPath: IndexPath) -> T? {
        return self.dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as? T
    }
    
    func setEmptyMessage(_ title: String, message: String, icon: String? = nil, hint: String? = nil, gestureRecognizer: UIGestureRecognizer? = nil) {
        
        // Vertical Stack View
        let vStack = UIStackView().also {
            $0.axis         = .vertical
            $0.alignment    = .center
            $0.distribution = .fill
            $0.spacing      = 10
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        if let icon = icon {
            // Meal Icon
            vStack.addArrangedSubview(UILabel().also {
                $0.text             = icon
                $0.font             = UIFont.from(style: .big)
                $0.textColor        = UIColor.htw.darkGrey
                $0.textAlignment    = .center
                $0.sizeToFit()
            })
        }
        
        // No Meal Header
        vStack.addArrangedSubview(UILabel().also {
            $0.text             = title
            $0.textColor        = UIColor.htw.darkGrey
            $0.numberOfLines    = 0
            $0.contentMode      = .scaleToFill
            $0.textAlignment    = .center
            $0.font             = UIFont.from(style: .big)
            $0.sizeToFit()
        })
        
        vStack.addArrangedSubview(UILabel().also {
            $0.text             = message
            $0.textColor        = UIColor.htw.grey
            $0.numberOfLines    = 0
            $0.contentMode      = .scaleToFill
            $0.textAlignment    = .center
            $0.font             = UIFont.from(style: .description)
            $0.sizeToFit()
        })
        
        if let hint = hint {
            vStack.addArrangedSubview(BadgeLabel().also {
                $0.text             = hint
                $0.textColor        = .white
                $0.font             = UIFont.from(style: .small, isBold: true)
                $0.backgroundColor  = UIColor.htw.lightBlueMaterial
            })
        }
        
        if let gestureRecognizer = gestureRecognizer {
            vStack.addGestureRecognizer(gestureRecognizer)
        }
        
        backgroundView = vStack
        
        NSLayoutConstraint.activate([
            vStack.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -100),
            vStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 16),
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
            ])
    }
    
    func restore() {
        backgroundView = nil
    }
}
