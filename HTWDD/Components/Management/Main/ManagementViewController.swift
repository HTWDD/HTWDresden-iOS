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
//        case sekInfo(model: Any)
    }
    
    // MARK: - Properties
    var context: HasManagement?
    
    private var items = [Item]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        self.title = Loca.Management.title
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        self.tableView.register(SemesterplaningViewCell.self)
        self.tableView.backgroundColor = UIColor.htw.veryLightGrey
        
        SemesterPlaning.get(network: Network())
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .map { result in
                result.filter {
                    do {
                        let dateFormat = "yyyy-MM-dd"
                        let startPeriod = try Date.from(string: $0.period.beginDay, format: dateFormat)
                        let endPeriod   = try Date.from(string: $0.period.endDay, format: dateFormat)
//                        return Date().isBetween(startPeriod, and: endPeriod)
                        return true
                    } catch {
                        return false
                    }
                }.map { Item.semesterPlan(model: $0) }
            }
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
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    // MARK: - Lifecycle
//    init(context: HasManagement) {
//        self.context = context
//        super.init()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented.")
//    }
//
//    // MARK: - Initialize Setup
//    override func initialSetup() {
//        super.initialSetup()
//        self.title = Loca.Management.title
//    }
}
