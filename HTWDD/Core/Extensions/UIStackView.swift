//
//  UIStackView.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 02.10.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation

extension HTWNamespace where Base: UIStackView {
        
    func addHorizontalSeparators(color: UIColor = UIColor.htw.Badge.secondary) {
        var i = base.arrangedSubviews.count
        while i > 1 {
            let separator = createSeparator(color: color)
            base.insertArrangedSubview(separator, at: i - 1)
            separator.widthAnchor.constraint(equalTo: base.widthAnchor, multiplier: 1).isActive = true
            i = i - 1
        }
    }
    
    private func createSeparator(color: UIColor) -> UIView {
        return UIView().also {
            $0.heightAnchor.constraint(equalToConstant: 1).isActive = true
            $0.backgroundColor  = color
            $0.alpha            = 0.5
        }
    }
}
