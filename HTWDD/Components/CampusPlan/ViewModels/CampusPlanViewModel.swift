//
//  CampusPlanViewModel.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 26.09.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

class CampusPlanViewModel {
 
    // MARK: - Properties
    private let context: HasApiService
    
    // MARK: - Lifecycle
    init(context: HasApiService) {
        self.context = context
    }
    
    func load() -> Single<[CampusPlan]> {
        return context.apiService.requestCampusPlan()
    }
}
