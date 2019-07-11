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
    
    // MARK: - Properties
    private let provider = MoyaProvider<MultiTarget>(plugins: [NetworkLoggerPlugin(verbose: true /*, cURL: true */ )])
    
    private static var sharedApiService: ApiService = {
        return ApiService()
    }()
    
    // MARK: Shared Instance
    class func shared() -> ApiService {
        return sharedApiService
    }
}

// MARK: - HTW - Rest
extension ApiService {
    // MARK: - TimeTable
    func requestTimeTable(for year: String, major: String, group: String) -> Observable<[Lecture]> {
        return provider.rx.request(MultiTarget(HTWRestApi.timeTable(year: year, major: major, group: group)))
            .filter(statusCodes: 200...299)
            .asObservable()
            .map { try $0.map([Lecture].self) }
    }
    
    // MARK: - Management
    func getSemesterPlaning() -> Observable<[SemesterPlaning]> {
        return provider.rx.request(MultiTarget(HTWRestApi.semesterPlaning))
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


// MARK: - OpenMensa - Rest
extension ApiService {
    
    func requestCanteens(latitude: Double = 51.058583, longitude: Double = 13.738208, distance: Int = 20) -> Single<[Canteens]> {
        return provider.rx.request(MultiTarget(OpenMensaRestApi.canteens(latitude: latitude, longitude: longitude, distance: distance)))
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .filter(statusCodes: 200...299)
            .map { try $0.map([Canteens].self) }
    }
    
    func requestMeals(for canteenId: Int, and forDate: String) -> Single<[Meals]> {
        return provider.rx.request(MultiTarget(OpenMensaRestApi.meals(canteenId: canteenId, forDate: forDate)))
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .filter(statusCodes: 200...299)
            .map { try $0.map([Meals].self) }
    }
    
//    func requestCanteenDetails(id: Int) -> Single<[Meal]> {
//        return provider.rx.request(MultiTarget(OpenMensaRestApi.canteens(latitude: latitude, longitude: longitude, distance: distance)))
//            .filter(statusCodes: 200...299)
//            .map { try $0.map([Canteens].self) }
//    }
//
//    func blub() {
//        return requestCanteens().asObservable()
//            .flatMap { canteens -> Observable<[Meal]> in
//                let requests = canteens.map { [unowned self] canteen in self.requestCanteenDetails(id: canteen.id).asObservable() }
//
//                return Observable
//                    .combineLatest(requests).take(1)
//        }
//    }
    
}
