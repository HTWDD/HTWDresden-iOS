//
//  TextField.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 19.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class TextField: UITextField {

	var insets: UIEdgeInsets = {
		return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
	}()
	
	// MARK: - Init
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		initialSetup()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initialSetup()
	}

	func initialSetup() {}

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 12
    }
    
	// MARK: - TextField
	
	override func textRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: self.insets)
	}
	
	override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: self.insets)
	}
	
	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: self.insets)
	}
}

class PasswordField: TextField {
	override func initialSetup() {
		self.isSecureTextEntry = true
	}
}
