//
//  UIBarButtonItem.swift
//  HTWDD
//
//  Created by Chris Herlemann on 03.01.21.
//  Copyright © 2021 HTW Dresden. All rights reserved.
//

extension UIBarButtonItem {

    static func menuButton(_ target: Any?, action: Selector, imageName: String) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        button.addTarget(target, action: action, for: .touchUpInside)

        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true

        return menuBarItem
    }
}
