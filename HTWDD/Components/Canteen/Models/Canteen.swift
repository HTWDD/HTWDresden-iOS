//
//  Canteens.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 10.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation

// MARK: - Canteens
struct Canteen: Codable {

    // MARK: - Properties
    let id: Int
    let name: String
    let address: String
    let coordinates: [Double]
}

// MARK: - Equatable
extension Canteen: Equatable {

    static func ==(lhs: Canteen, rhs: Canteen) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
    
}
