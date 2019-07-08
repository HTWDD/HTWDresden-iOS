//
//  PrincipalExamOffice.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 01.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

// MARK: - Principal Exam Office
struct PrincipalExamOffice: Codable {
    let offeredServices: [String]
    let officeHours: [OfficeHour]
}
