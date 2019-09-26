//
//  CampusPlan.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 25.09.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation

struct CampusPlan: Codable {
    let building: String
    let image: Int
    let buildings: [String]
}
