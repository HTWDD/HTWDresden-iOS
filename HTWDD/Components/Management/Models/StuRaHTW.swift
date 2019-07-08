//
//  StuRa.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 01.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

// MARK: - StuRaHTW
struct StuRaHTW: Codable {
    let offeredServices: [String]
    let officeHours: [OfficeHour]
}
