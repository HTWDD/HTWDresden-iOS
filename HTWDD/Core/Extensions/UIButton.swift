//
//  UIButton.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 02.08.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation

extension UIButton {
    
    enum ActiveState {
        case active
        case inactive
    }
    
    func makeDropShadow() {
        layer.apply {
            $0.shadowColor      = UIColor(red: 0, green: 0, blue: 0, alpha: 0.30).cgColor
            $0.shadowOffset     = CGSize(width: 0, height: 3)
            $0.shadowOpacity    = 1.0
            $0.shadowRadius     = 8.0
            $0.masksToBounds    = false
        }
    }
    
    func setState(with activeState: ActiveState) {
        switch activeState {
        case .active:
            isEnabled = true
            backgroundColor = UIColor(hex: 0x1976D2)
        case .inactive:
            isEnabled = false
            backgroundColor = UIColor.htw.grey
        }
    }
    
}
