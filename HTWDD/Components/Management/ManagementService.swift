//
//  ManagementService.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 21.06.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

class ManagementService: Service {
    
    // MARK: - Properties
    private let network = Network()
    
    func load(parameters: ()) -> Observable<[SemesterPlaning]> {
        return SemesterPlaning.get(network: self.network)
    }
}


//// MARK: - Dependency management
//extension ManagementService: HasManagement {
//    var mangementService: ManagementService { return self }
//}
