//
//  UIFonts.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 30.06.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation

extension UIFont {
    
    static func small(_ size: CGFloat = 13.5, isBold: Bool = false) -> UIFont {
        if (!isBold) {
            return UIFont.systemFont(ofSize: size)
        } else {
            return UIFont.boldSystemFont(ofSize: size)
        }
    }
    
    static func description(_ size: CGFloat = 16.0, _ isBold: Bool = false) -> UIFont {
        if (!isBold) {
            return UIFont.systemFont(ofSize: size)
        } else {
            return UIFont.boldSystemFont(ofSize: size)
        }
    }
    
}
