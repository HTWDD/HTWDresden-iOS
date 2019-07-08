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
    
    let studentAdministration = URL(string: "https://www.htw-dresden.de/de/hochschule/hochschulstruktur/zentrale-verwaltung-dezernate/dezernat-studienangelegenheiten/studentensekretariat.html")!
    
    let principalExamOffice = URL(string: "https://www.htw-dresden.de/de/hochschule/hochschulstruktur/zentrale-verwaltung-dezernate/dezernat-studienangelegenheiten/pruefungsamt.html")!
    
    let stuRaHTW = URL(string: "https://www.stura.htw-dresden.de")!
    
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
                                        loadStuRaHTW()) { $0 + $1 + $2 + $3 }
    }
    
    // MARK: - Loading Stuff
    fileprivate func loadSemesterPlaning() -> Observable<[Item]> {
        let realm = try! Realm()
        
        if let rModel = realm.objects(SemesterPlaningRealm.self).first {
            return Observable.from(optional: rModel)
                .map {
                    [Item.semesterPlan(model: SemesterPlaning.map(from: $0)!)]
                }.catchErrorJustReturn([])
        }
        return Observable.empty()
    }
    
    fileprivate func requestSemesterPlaning() {
        apiService.getSemesterPlaning()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .map { result in
                result.filter {
                    do {
                        let dateFormat = "yyyy-MM-dd"
                        let startPeriod = try Date.from(string: $0.period.beginDay, format: dateFormat)
                        let endPeriod   = try Date.from(string: $0.period.endDay, format: dateFormat)
                        return Date().isBetween(startPeriod, and: endPeriod)
                    } catch {
                        return false
                    }
                }.first
            }.subscribe { plan in
                guard let sPlan = plan.element else { return }
                SemesterPlaningRealm.save(from: sPlan)
            }.disposed(by: bag)
    }
    
    fileprivate func loadStudentAdminstration() -> Observable<[Item]> {
        return apiService.getStudentAdministration()
            .asObservable()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .map { [Item.studenAdministation(model: $0)] }
    }
    
    fileprivate func loadPrincipalOffice() -> Observable<[Item]> {
        return apiService.getPrincipalExamOffice()
            .asObservable()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .map { [Item.principalExamOffice(model: $0)] }
    }
    
    fileprivate func loadStuRaHTW() -> Observable<[Item]> {
        return apiService.getStuRaHTW()
            .asObservable()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .map { [Item.stuRaHTW(model: $0)] }
    }

}
