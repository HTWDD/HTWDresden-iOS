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
    
    // MARK: - Management URLs
    var studentAdministration: URL? {
        return URL(string: "https://www.htw-dresden.de/de/hochschule/hochschulstruktur/zentrale-verwaltung-dezernate/dezernat-studienangelegenheiten/studentensekretariat.html")
    }
    
    var principalExamOffice: URL? {
        return URL(string: "https://www.htw-dresden.de/de/hochschule/hochschulstruktur/zentrale-verwaltung-dezernate/dezernat-studienangelegenheiten/pruefungsamt.html")
    }
    
    var stuRaHTW: URL? {
        return URL(string: "https://www.stura.htw-dresden.de")
    }
    
    private let apiService = ApiService()
    
    func load(parameters: ()) -> Observable<[SemesterPlaning]> {
        return apiService.getSemesterPlaning()
    }

}

extension ManagementService: HasManagement {
    var managementService: ManagementService { return self }
}
