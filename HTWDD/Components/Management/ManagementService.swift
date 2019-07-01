//
//  ManagementService.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 24.06.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

class ManagementService: Service {
    
    private let apiService = ApiService()
    
    func load(parameters: ()) -> Observable<[SemesterPlaning]> {
        return apiService.getSemesterPlaning()
    }

}

extension ManagementService: HasManagement {
    var managementService: ManagementService { return self }
}
