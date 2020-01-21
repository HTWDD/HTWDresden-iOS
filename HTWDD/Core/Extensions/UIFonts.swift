//
//  UIFonts.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 30.06.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation

extension UIFont {
    
    enum Styles: Float {
        case big            = 23.0
        case small          = 13.5
        case verySmall      = 10.0
        case description    = 16.0
    }
    
    static func from(style: Styles, isBold: Bool = false) -> UIFont {
        return isBold ? UIFont.boldSystemFont(ofSize: CGFloat(style.rawValue)) : UIFont.systemFont(ofSize: CGFloat(style.rawValue))
    }
    
    static var primary: UIFont {
        return UIFont.systemFont(ofSize: 17.0, weight: .semibold)
    }
    
}


extension HTWNamespace where Base: UIFont {
    
    struct Labels {
        static var primary: UIFont {
            return UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        }
            
        static var medium: UIFont {
            return UIFont.systemFont(ofSize: 13)
        }
        
        static var secondary: UIFont {
            return UIFont.systemFont(ofSize: 11.0, weight: .semibold)
        }
    }
    
    struct Badges {
        static var primary: UIFont {
            return UIFont.systemFont(ofSize: 11.0, weight: .semibold)
        }
    }
    
}
