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
    private let context: HasCampusPlan
    
    // MARK: - Lifecycle
    init(context: HasCampusPlan) {
        self.context = context
    }
    
    func load() -> Single<[CampusPlan]> {
        return context.campusPlanService.loadCampusPlan()
    }
}
