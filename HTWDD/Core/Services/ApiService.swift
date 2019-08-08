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
import Alamofire

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

// MARK: Caching
protocol CachePolicyGettable {
    var cachePolicy: URLRequest.CachePolicy { get }
}

final class CachePolicyPlugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        if let cachePolicyGettable = target as? CachePolicyGettable {
            var mutableRequest = request
            mutableRequest.cachePolicy = cachePolicyGettable.cachePolicy
            return mutableRequest
        }
        
        return request
    }
}

class CustomServerTrustPolicyManager: ServerTrustPolicyManager {
    override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
        return .disableEvaluation
    }
    
    public init() {
        super.init(policies: [:])
    }
}


// MARK: - API Service
class ApiService {

    // MARK: - Properties
    private let plugins: [PluginType] = [NetworkLoggerPlugin(verbose: true, cURL: false), CachePolicyPlugin()]
    
    private let manager = Manager(configuration: URLSessionConfiguration.default, serverTrustPolicyManager: CustomServerTrustPolicyManager())
    
    private let provider: MoyaProvider<MultiTarget>
    
    private static var sharedApiService: ApiService = {
        return ApiService()
    }()
    
    // MARK: - Lifecycle
    private init() {
        provider = MoyaProvider<MultiTarget>(manager: manager, plugins: plugins)
    }
    
    // MARK: - Shared Instance
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
    
    func requestLessons(for year: String, major: String, group: String) -> Single<[Lesson]> {
        return provider.rx.request(MultiTarget(HTWRestApi.timeTable(year: year, major: major, group: group)))
            .filter(statusCodes: 200...299)
            .map { try $0.map([Lesson].self) }
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
            }
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .asSingle()
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
            }
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .asSingle()
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
            }
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .asSingle()
    }
    
    // MARK: - Room Occupancy
    func requestRoom(room: String) -> Single<[Lesson]> {
        return provider.rx.request(MultiTarget(HTWRestApi.rooms(room: room)))
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .filter(statusCodes: 200...299)
            .map { try $0.map([Lesson].self) }
    }
    
    // MARK: - Studygroups
    func requestStudyGroups() -> Single<[StudyYear]> {
        return provider.rx.request(MultiTarget(HTWRestApi.studyGroups))
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .filter(statusCodes: 200...299)
            .map { try $0.map([StudyYear].self) }
    }
    
    // MARK: - Courses
    func requestCourses(auth: String) -> Single<[Course]> {
        return provider.rx.request(MultiTarget(HTWRestApi.courses(auth: auth)))
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .filter(statusCodes: 200...299)
            .map { try $0.map([Course].self) }
    }
    
    func requestExams(year: String, major: String, group: String, grade: String) -> Single<[Examination]> {
        return provider.rx.request(MultiTarget(HTWRestApi.exams(year: year, major: major, group: group, grade: grade)))
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .filter(statusCodes: 200...299)
            .map { try $0.map([Examination].self) }
    }
}


// MARK: - OpenMensa - Rest
extension ApiService {
    
    func requestCanteens(latitude: Double = 51.058583, longitude: Double = 13.738208, distance: Int = 20) -> Single<[Canteen]> {
        return provider.rx.request(MultiTarget(OpenMensaRestApi.canteens(latitude: latitude, longitude: longitude, distance: distance)))
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .filter(statusCodes: 200...299)
            .map { try $0.map([Canteen].self) }
    }
    
    func requestMeals(for canteenId: Int, and forDate: String) -> Single<[Meal]> {
        return provider.rx.request(MultiTarget(OpenMensaRestApi.meals(canteenId: canteenId, forDate: forDate)))
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .filter(statusCodes: 200...299)
            .map { try $0.map([Meal].self) }
    }
}
