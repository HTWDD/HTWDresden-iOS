//
//  CanteenService.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 10.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

class CanteenService {
    
    // MARK: - Properties
    private let apiService: ApiService
    
    // MARK: - Lifecycle
    init(apiService: ApiService) {
        self.apiService = apiService
    }
    
    /// Requesting all canteens Dresden 20 KM Radius
    func request() -> Observable<[Canteens]> {
        return apiService.requestCanteens().asObservable()
    }
}

extension CanteenService: HasCanteen {
    var canteenService: CanteenService { return self }
}
