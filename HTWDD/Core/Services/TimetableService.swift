//
//  TimetableService.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 01.10.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

class TimetableService: Service {
    
    // MARK: - Properties
    private var apiService: ApiService
    
     // MARK: - Lifecycle
    init(apiService: ApiService) {
        self.apiService = apiService
    }
    
    func load(parameters: ()) -> Observable<()> {
        return Observable.empty()
    }
    
    func requestTimetable() -> Observable<[Lesson]> {
        let (year, major, group, _) = KeychainService.shared.readStudyToken()
        if let year = year, let major = major, let group = group {
            return apiService
                .requestLessons(for: year, major: major, group: group)
                .observeOn(SerialDispatchQueueScheduler(qos: .background))
                .asObservable()
        } else {
            return Observable.error(AuthError.noStudyToken)
        }
    }
    
}

// MARK: - HasTimetable
extension TimetableService: HasTimetable {
    var timetableService: TimetableService { return self }
}
