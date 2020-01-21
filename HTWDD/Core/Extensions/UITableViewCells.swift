//
//  File.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 27.06.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation

protocol FromNibLoadable {
    static var identifier: String { get }
    static var nib: UINib { get }
}

extension FromNibLoadable where Self: UITableViewCell {
    static var identifier: String { return "\(Self.self)" }
    static var nib: UINib { return UINib(nibName: identifier, bundle: Bundle(for: Self.self)) }
}
