//
//  ManagementService.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 24.06.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

// MARK: - Item Types
enum Item {
    case semesterPlan(model: SemesterPlaning)
    case studenAdministation(model: StudentAdministration)
    case principalExamOffice(model: PrincipalExamOffice)
    case stuRaHTW(model: StuRaHTW)
}

class ManagementService: Service {
    // MARK: - Properties
    private var bag = DisposeBag()
    
    private let apiService: ApiService
    
    // MARK: - Lifecycle
    init(apiService: ApiService) {
        self.apiService = apiService
    }
    
    // MARK: - Loading
    func load(parameters: ()) -> Observable<[Item]> {
        requestSemesterPlaning()
        return Observable.combineLatest(loadSemesterPlaning(),
                                        loadStudentAdminstration(),
                                        loadPrincipalOffice(),
                                        loadStuRaHTW()) { (sPlaning: [Item], sAdmin: [Item], pOffice: [Item], stuRa: [Item]) in
                                            sPlaning + sAdmin + pOffice + stuRa
                                        }
    }
    
    // MARK: - Loading Stuff
    fileprivate func loadSemesterPlaning() -> Observable<[Item]> {
        let realm = try! Realm()
        
        if let rModel = realm.objects(SemesterPlaningRealm.self).last {
            
            return Observable.from(optional: rModel)
                .map {
                    if let semesterPlaning = SemesterPlaning.map(from: $0), semesterPlaning.isCurrentSemester() {
                        return [Item.semesterPlan(model: semesterPlaning)]
                    } else {
                        return []
                    }
                    
                }.catchErrorJustReturn([])
        }
        return Observable.just([])
    }
    
    fileprivate func requestSemesterPlaning() {
        apiService.requestSemesterPlaning()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .map { result in
                result.filter {
                    return  $0.period.isInPeriod(date: Date())
                }.first
            }.subscribe { plan in
                guard let sPlan = plan.element else { return }
                SemesterPlaningRealm.save(from: sPlan)
            }.disposed(by: bag)
    }
    
    fileprivate func loadStudentAdminstration() -> Observable<[Item]> {
        return apiService.requestStudentAdministration()
            .asObservable()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .map { [Item.studenAdministation(model: $0)] }
    }
    
    fileprivate func loadPrincipalOffice() -> Observable<[Item]> {
        return apiService.requestPrincipalExamOffice()
            .asObservable()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .map { [Item.principalExamOffice(model: $0)] }
    }
    
    fileprivate func loadStuRaHTW() -> Observable<[Item]> {
        return apiService.requestStuRaHTW()
            .asObservable()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .map { [Item.stuRaHTW(model: $0)] }
    }

}
