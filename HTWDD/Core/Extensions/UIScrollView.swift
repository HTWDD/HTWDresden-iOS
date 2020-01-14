//
//  UIScrollView.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 14.01.20.
//  Copyright © 2020 HTW Dresden. All rights reserved.
//

import Foundation

extension UIScrollView {
    
    func scrollToBottom(animated: Bool = false) {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        setContentOffset(bottomOffset, animated: animated)
    }
    
}
