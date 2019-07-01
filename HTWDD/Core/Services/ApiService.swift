//
//  ApiService.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 01.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import Moya
import RxSwift

class ApiService {
    private lazy var provider: MoyaProvider<RestApi> = {
       return MoyaProvider<RestApi>()
    }()
    
    func getSemesterPlaning() -> Observable<[SemesterPlaning]> {
        return provider.rx.request(.semesterPlaning)
            .filter(statusCodes: 200...299)
            .asObservable()
            .map { try $0.map([SemesterPlaning].self) }
    }
}
