//
//  ManagementVC.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 21.06.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ManagementViewController: UITableViewController {
    enum Item {
        case semesterPlan(model: SemesterPlaning)
        case studenAdministation(model: StudentAdministration)
        case principalExamOffice(model: PrincipalExamOffice)
        case stuRaHTW(model: StuRaHTW)
    }
    
    // MARK: - Properties
    var context: HasManagement?
    
    private var items = [Item]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        self.title = R.string.localizable.managementTitle()
        self.tableView.separatorStyle = .none
        //self.tableView.allowsSelection = false
        self.tableView.register(SemesterplaningViewCell.self)
        self.tableView.register(StudenAdministrationViewCell.self)
        self.tableView.register(PrincipalExamOfficeViewCell.self)
        self.tableView.register(StuRaHTWViewCell.self)
        self.tableView.backgroundColor = UIColor.htw.veryLightGrey
        
        let semesterPlaningItems: Observable<[Item]> = context!.managementService.load(parameters: ())
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
        
        let studentAdministrationItems: Observable<[Item]> =  StudentAdministration.get()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .map { [Item.studenAdministation(model: $0)] }
        
        let principalExamOffice: Observable<[Item]> = PrincipalExamOffice.get()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .map { [Item.principalExamOffice(model: $0)] }
        
        let stuRaHTW: Observable<[Item]> = StuRaHTW.get()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .map { [Item.stuRaHTW(model: $0)] }
        
        Observable.combineLatest(semesterPlaningItems, studentAdministrationItems, principalExamOffice, stuRaHTW) { $0 + $1 + $2 + $3 }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] items in
//                self.semesterPlanings.append(contentsOf: $0)
                self?.items = items
            }, onError: { (error) in
            Log.error(error)
        }).disposed(by: self.rx_disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch items[indexPath.row] {
        case .semesterPlan(let model):
            let cell = tableView.dequeueReusableCell(SemesterplaningViewCell.self, for: indexPath)!
            cell.model(for: model)
            return cell
            
        case .studenAdministation(let model):
            let cell = tableView.dequeueReusableCell(StudenAdministrationViewCell.self, for: indexPath)!
            cell.model(for: model)
            return cell
            
        case .principalExamOffice(let model):
            let cell = tableView.dequeueReusableCell(PrincipalExamOfficeViewCell.self, for: indexPath)!
            cell.model(for: model)
            return cell
            
        case .stuRaHTW(let model):
            let cell = tableView.dequeueReusableCell(StuRaHTWViewCell.self, for: indexPath)!
            cell.model(for: model)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch items[indexPath.row] {
        case .semesterPlan(_): break
        
        case .studenAdministation(_):
            if let url = context?.managementService.studentAdministration {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
        case .principalExamOffice(_):
            if let url = context?.managementService.principalExamOffice {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
        case .stuRaHTW(_):
            if let url = context?.managementService.stuRaHTW {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
