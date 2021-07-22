//
//  BottomBorderTextField.swift
//  HTWDD
//
//  Created by Chris Herlemann on 29.01.21.
//  Copyright © 2021 HTW Dresden. All rights reserved.
//

class BottomBorderTextField: UITextField {
    
    var showBottomBorder: Bool = true
    
    override func draw(_ rect: CGRect) {
        guard showBottomBorder else {
            return
        }
        
        let border = CALayer()
        
        border.backgroundColor = UIColor.htw.lightGrey.cgColor
        border.frame = CGRect(x: 0, y: frame.size.height * 1.2, width: frame.width, height: 1)
        
        layer.addSublayer(border)
    }
}
