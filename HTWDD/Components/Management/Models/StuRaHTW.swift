//
//  StuRa.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 01.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

// MARK: JSON
fileprivate var stuRaHTWData: Data {
    return try! Data(contentsOf: R.file.stuRaHTWJson()!)
}

// MARK: - StuRaHTW
struct StuRaHTW: Codable {
    let offeredServices: [String]
    let officeHours: [OfficeHour]
    
    static func get() -> Observable<StuRaHTW> {
        return Observable.create { observer in
            do {
                let data = try JSONDecoder().decode(StuRaHTW.self, from: stuRaHTWData)
                observer.onNext(data)
                observer.onCompleted()
            } catch {
                 observer.onError(error)
            }
            return Disposables.create()
        }
    }
}
