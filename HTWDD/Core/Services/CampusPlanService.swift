//
//  CampusPlanService.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 25.09.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift


// MARK: - File
fileprivate var campusPlanData: Data {
    do {
        guard let json = R.file.campusPlanJson() else { return Data() }
        return try Data(contentsOf: json)
    } catch {
        return Data()
    }
}

// MARK: - Service
class CampusPlanService: Service {

    // MARK: - Properties
    
    // MARK: - Loading
    func load(parameters: ()) -> Observable<()> {
        return Observable.empty()
    }
    
    func loadCampusPlan() -> Single<[CampusPlan]> {
        return Observable.create { observer in
            do {
                observer.onNext(try JSONDecoder().decode([CampusPlan].self, from: campusPlanData))
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
        .observeOn(SerialDispatchQueueScheduler(qos: .background))
        .asSingle()
    }
    
}
