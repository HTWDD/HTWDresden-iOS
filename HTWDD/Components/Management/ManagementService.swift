//
//  ManagementService.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 24.06.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

// MARK: - Item Types
enum Item {
    case semesterPlan(model: SemesterPlaning)
    case studenAdministation(model: StudentAdministration)
    case principalExamOffice(model: PrincipalExamOffice)
    case stuRaHTW(model: StuRaHTW)
}

class ManagementService: Service {
    
    // MARK: - Properties
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
    
    // MARK: - Loading
    func load(parameters: ()) -> Observable<[Item]> {
        return Observable.combineLatest(loadSemesterPlaning(),
                                        loadStudentAdminstration(),
                                        loadPrincipalOffice(),
                                        loadStuRaHTW()) { $0 + $1 + $2 + $3 }
    }
    
    // MARK: - Loading Stuff
    fileprivate func loadSemesterPlaning() -> Observable<[Item]> {
        return apiService.getSemesterPlaning()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .map { result in
                result.filter {
                    do {
                        let dateFormat = "yyyy-MM-dd"
                        let startPeriod = try Date.from(string: $0.period.beginDay, format: dateFormat)
                        let endPeriod   = try Date.from(string: $0.period.endDay, format: dateFormat)
                        return Date().isBetween(startPeriod, and: endPeriod)
                        //                        return true
                    } catch {
                        return false
                    }
                }.map { Item.semesterPlan(model: $0) }
            }
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

extension ManagementService: HasManagement {
    var managementService: ManagementService { return self }
}
