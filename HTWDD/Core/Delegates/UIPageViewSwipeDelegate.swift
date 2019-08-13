//
//  UIPageViewSwipeDelegate.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 01.08.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation

protocol UIPageViewSwipeDelegate: class {
    func next(animated: Bool)
    func previous(animated: Bool)
}
