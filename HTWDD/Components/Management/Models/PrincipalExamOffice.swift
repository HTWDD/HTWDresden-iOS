//
//  PrincipalExamOffice.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 01.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

// MARK: JSON
fileprivate var principalExamOfficeData: Data {
    return try! Data(contentsOf: R.file.principalExamOfficeJson()!)
}

// MARK: - Principal Exam Office
struct PrincipalExamOffice: Codable {
    let offeredServices: [String]
    let officeHours: [OfficeHour]
    
    static func get() -> Observable<PrincipalExamOffice> {
        return Observable.create { observer in
            do {
                let data = try JSONDecoder().decode(PrincipalExamOffice.self, from: principalExamOfficeData)
                observer.onNext(data)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}
