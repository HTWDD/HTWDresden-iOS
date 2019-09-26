//
//  Colors.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 19.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit.UIColor

extension UIColor {

    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
            blue: CGFloat(hex & 0x0000FF)        / 255.0,
            alpha: alpha
        )
    }

	func hex() -> UInt {
		var r: CGFloat = 0
		var g: CGFloat = 0
		var b: CGFloat = 0
		
		self.getRed(&r, green: &g, blue: &b, alpha: nil)
		
		let rh: UInt = UInt(r * 255)
		let gh: UInt = UInt(g * 255)
		let bh: UInt = UInt(b * 255)
		
		return (rh << 16) + (gh << 8) + bh
	}
}

// MARK: - HTW Colors
extension HTWNamespace where Base: UIColor {

    struct Label {
        static var primary: UIColor {
            if #available(iOS 11.0, *) {
                return UIColor(named: "LabelPrimary")!
            }
            return UIColor(hex: 0x2c2c2e)
        }
        
        static var secondary: UIColor {
            if #available(iOS 11.0, *) {
                return UIColor(named: "LabelSecondary")!
            }
            return UIColor(hex: 0x2c2c2e)
        }
    }
    
    struct Badge {
        static var primary: UIColor {
            if #available(iOS 11.0, *) {
                return UIColor(named: "BadgePrimary")!
            }
            return UIColor(hex: 0xE7E7E7)
        }
        
        static var secondary: UIColor {
            if #available(iOS 11.0, *) {
                return UIColor(named: "BadgeSecondary")!
            }
            return UIColor(hex: 0xE7E7E7)
        }
        
        static var date: UIColor {
            if #available(iOS 11.0, *) {
                return UIColor(named: "BadgeDate")!
            }
            return UIColor(hex: 0x0288D1)
        }
        
        static var city: UIColor {
            if #available(iOS 11.0, *) {
                return UIColor(named: "BadgeCity")!
            }
            return UIColor(hex: 0xFF9D14)
        }
    }
    
    struct Icon {
        static var primary: UIColor {
            if #available(iOS 11.0, *) {
               return UIColor(named: "IconPrimary")!
            }
            return UIColor(hex: 0x444444)
        }
    }
    
    struct Material {
        static var green: UIColor {
            if #available(iOS 11.0, *) {
               return UIColor(named: "GreenMaterial")!
            }
            return UIColor(hex: 0x4CAF50)
        }
        
        static var red: UIColor {
            if #available(iOS 11.0, *) {
               return UIColor(named: "RedMaterial")!
            }
            return UIColor(hex: 0xF44336)
        }
        
        static var blue: UIColor {
            if #available(iOS 11.0, *) {
               return UIColor(named: "BlueMaterial")!
            }
            return UIColor(hex: 0x2196F3)
        }
        
        static var orange: UIColor {
            if #available(iOS 11.0, *) {
               return UIColor(named: "OrangeMaterial")!
            }
            return UIColor(hex: 0xFF9800)
        }
    }
    
    static var cellBackground: UIColor {
        if #available(iOS 11.0, *) {
            return UIColor(named: "CellBackground")!
        }
        return UIColor(hex: 0xFFFFFF)
    }
    
    static var shadow: UIColor {
        if #available(iOS 11.0, *) {
            return UIColor(named: "Shadow")!
        }
        return UIColor(hex: 0x000000)
    }
    
    static var blue: UIColor {
        if #available(iOS 11.0, *) {
            return UIColor(named: "Blue")!
        }
        return UIColor(hex: 0x003DA2)
    }
    
    static var lightBlueMaterial: UIColor {
        return UIColor(hex: 0x0288D1)
    }
    
    static var orange: UIColor {
        return UIColor(hex: 0xF1A13D)
    }
    
    static var mediumOrange: UIColor {
        return UIColor(hex: 0xff9d14)
    }
    
    static var green: UIColor {
        return UIColor(hex: 0x2ECC5D)
    }
    
    static var greenMaterial: UIColor {
        return UIColor(hex: 0x43A047)
    }
	
	static var red: UIColor {
		return UIColor(hex: 0xC21717)
	}
    
    static var redMaterial: UIColor {
        return UIColor(hex: 0xF44336)
    }
	
	static var yellow: UIColor {
		return UIColor(hex: 0xf1c40f)
	}

    static var textBody: UIColor {
        return UIColor(hex: 0x7F7F7F)
    }

    static var textHeadline: UIColor {
        return UIColor(hex: 0x000000)
    }

    static var lightBlue: UIColor {
        return UIColor(hex: 0x5060F5)
    }

    static var martianRed: UIColor {
        return UIColor(hex: 0xE35D50)
    }
    
	static var veryLightGrey: UIColor {
        if #available(iOS 11.0, *) {
            return UIColor(named: "Background")!
        }
        return UIColor(hex: 0xf2f1f6)
	}

	static var lightGrey: UIColor {
		return UIColor(hex: 0xE7E7E7)
	}
	
    static var grey: UIColor {
        return UIColor(hex: 0x8F8F8F)
    }
    
    static var grey300: UIColor {
        return UIColor(hex: 0xE0E0E0)
    }
    
    static var grey400: UIColor {
        return UIColor(hex: 0xBDBDBD)
    }
    
    static var grey600: UIColor {
        return UIColor(hex: 0x757575)
    }

    static var mediumGrey: UIColor {
        return UIColor(hex: 0x5A5A5A)
    }

    static var darkGrey: UIColor {
        return UIColor(hex: 0x474747)
    }
    
    static var white: UIColor {
        return UIColor.white
    }
    
    static var pink: UIColor {
        return UIColor(hex: 0xE91E63)
    }
    
    static var purple: UIColor {
        return UIColor(hex: 0x9C27B0)
    }
	
	static var scheduleColors: [UIColor] {
		let colors = [
			UIColor(hex: 0xC21717),
			UIColor(hex: 0xf39c12),
			UIColor(hex: 0x8e44ad),
			UIColor(hex: 0x27ae60),
			UIColor(hex: 0xe74c3c),
			UIColor(hex: 0xF0C987),
			UIColor(hex: 0x3498db),
			UIColor(hex: 0x2ecc71),
			UIColor(hex: 0x9097C0),
			UIColor(hex: 0xf1c40f),
			UIColor(hex: 0x2c3e50),
			UIColor(hex: 0xc0392b)
		]
		return colors
	}
    
    static var materialColors: [UIColor] {
        return [
            UIColor(hex: 0xF44336),
            UIColor(hex: 0xFF1744),
            UIColor(hex: 0xE91E63),
            UIColor(hex: 0x9C27B0),
            UIColor(hex: 0x673AB7),
            UIColor(hex: 0x4A148C),
            UIColor(hex: 0x3F51B5),
            UIColor(hex: 0x1E88E5),
            UIColor(hex: 0x03A9F4),
            UIColor(hex: 0x00BCD4),
            UIColor(hex: 0x009688),
            UIColor(hex: 0x43A047),
            UIColor(hex: 0x7CB342),
            UIColor(hex: 0xDCE775),
            UIColor(hex: 0xC0CA33),
            UIColor(hex: 0xF9A825),
            UIColor(hex: 0xFF6F00),
            UIColor(hex: 0xFF5722),
            UIColor(hex: 0x000000),
            UIColor(hex: 0x607D8B)
        ]
    }
}
