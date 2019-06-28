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
}
