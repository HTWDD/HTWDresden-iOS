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
    
    func load(parameters: ()) -> Observable<()> {
        return Observable.empty()
    }

}

extension ManagementService: HasManagement {
    var managementService: ManagementService { return self }
}
