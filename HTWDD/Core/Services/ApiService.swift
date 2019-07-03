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

// MARK: - JSON
fileprivate var studentAdministrationData: Data {
    // Loading data from file /Supporting Files/Assets/StudenAdministration.json
    do {
        guard let json = R.file.studentAdministrationJson() else { return Data() }
        return try Data(contentsOf: json)
    } catch {
        return Data()
    }
}

fileprivate var principalExamOfficeData: Data {
    // Loading data from file /Supporting Files/Assets/PrincipalExamOffice.json
    do {
        guard let json = R.file.principalExamOfficeJson() else { return Data() }
        return try Data(contentsOf: json)
    } catch {
        return Data()
    }
}

fileprivate var stuRaHTWData: Data {
    // Loading data from file /Supporting Files/Assets/StuRaHTW.json
    do {
        guard let json = R.file.stuRaHTWJson() else { return Data() }
        return try Data(contentsOf: json)
    } catch {
        return Data()
    }
}


// MARK: - API Service
class ApiService {
    private lazy var provider: MoyaProvider<RestApi> = {
       return MoyaProvider<RestApi>()
    }()
    
    // MARK: - Management
    func getSemesterPlaning() -> Observable<[SemesterPlaning]> {
        return provider.rx.request(.semesterPlaning)
            .filter(statusCodes: 200...299)
            .asObservable()
            .map { try $0.map([SemesterPlaning].self) }
    }
    
    func getStudentAdministration() -> Single<StudentAdministration> {
        return Observable.create { observer in
            do {
                observer.onNext(try JSONDecoder().decode(StudentAdministration.self, from: studentAdministrationData))
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }.asSingle()
    }
    
    func getPrincipalExamOffice() -> Single<PrincipalExamOffice> {
        return Observable.create { observer in
            do {
                observer.onNext(try JSONDecoder().decode(PrincipalExamOffice.self, from: principalExamOfficeData))
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }.asSingle()
    }
    
    func getStuRaHTW() -> Single<StuRaHTW> {
        return Observable.create  { observer in
            do {
                observer.onNext(try JSONDecoder().decode(StuRaHTW.self, from: stuRaHTWData))
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }.asSingle()
    }
}
