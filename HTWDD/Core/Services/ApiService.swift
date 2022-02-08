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
    
    func requestElectiveLessons() -> Observable<[Lesson]> {
        return provider.rx.request(MultiTarget(HTWRestApi.electiveLessons))
            .filter(statusCodes: 200...299)
            .asObservable()
            .map { try $0.map([Lesson].self) }
    }
    
    // MARK: - Management
    func requestSemesterPlaning() -> Observable<[SemesterPlaning]> {
        return provider.rx.request(MultiTarget(HTWRestApi.administrativeDocs(doc: .semesterPlanning)))
            .filter(statusCodes: 200...299)
            .asObservable()
            .map { try $0.map([SemesterPlaning].self) }
    }
    
    func requestStudentAdministration() -> Single<StudentAdministration> {
        return provider.rx.request(MultiTarget(HTWRestApi.administrativeDocs(doc: .studentAdministration)))
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .filter(statusCodes: 200...299)
            .map { try $0.map(StudentAdministration.self) }
    }
    
    func requestPrincipalExamOffice() -> Single<PrincipalExamOffice> {
        return provider.rx.request(MultiTarget(HTWRestApi.administrativeDocs(doc: .principalExamOffice)))
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .filter(statusCodes: 200...299)
            .map { try $0.map(PrincipalExamOffice.self) }
    }
    
    func requestStuRaHTW() -> Single<StuRaHTW> {
        return provider.rx.request(MultiTarget(HTWRestApi.administrativeDocs(doc: .stuRaHTW)))
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .filter(statusCodes: 200...299)
            .map { try $0.map(StuRaHTW.self) }
    }
    
    func requestCampusPlan() -> Single<[CampusPlan]> {
        return provider.rx.request(MultiTarget(HTWRestApi.administrativeDocs(doc: .campusPlan)))
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .filter(statusCodes: 200...299)
            .map { try $0.map([CampusPlan].self) }
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
    
    // MARK: - Grades
    func requestGrades(auth: String, course: Course) -> Single<[Grade]> {
        return provider.rx.request(MultiTarget(HTWRestApi.grades(auth: auth, examinationRegulations: course.examinationRegulations, majorNumber: course.majorNumber, graduationNumber: course.graduationNumber)))
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .filter(statusCodes: 200...299)
            .map { try $0.map([Grade].self) }
    }
    
    // MARK: - Exams
    func requestExams(year: String, major: String, group: String, grade: String) -> Single<[Exam]> {
        return provider.rx.request(MultiTarget(HTWRestApi.exams(year: year, major: major, group: group, grade: grade)))
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .filter(statusCodes: 200...299)
            .map { try $0.map([Exam].self) }
    }
    
    func requestLegalNotes() -> Single<Notes> {
        return provider.rx.request(MultiTarget(HTWRestApi.administrativeDocs(doc: .legalNotes)))
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .filter(statusCodes: 200...299)
            .map { try $0.map(Notes.self) }
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
