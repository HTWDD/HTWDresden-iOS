//
//  TimetableHeader.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 01.10.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation

struct TimetableHeader {
    let header: String
    let subheader: String
    
    var headerLocalized: String {
        return try! Date.from(string: header, format: "dd.MM.yyyy").string(format: "EEEE")
    }
    
    var subheaderLocalized: String {
        return try! Date.from(string: subheader, format: "dd.MM.yyy").string(format: "dd. MMMM")
    }
}

// MARK: - Equatable
extension TimetableHeader: Equatable {
    
    static func ==(lhs: TimetableHeader, rhs: TimetableHeader) -> Bool {
        return lhs.header == rhs.header
    }
}

// MARK: - Hashable
extension TimetableHeader: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(header.hashValue ^ subheader.hashValue)
    }
}
