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
import RealmSwift
import RxRealm


class ManagementViewController: UITableViewController, HasSideBarItem {
    
    // MARK: - Properties
    var context: HasManagement!
    private var notificationToken: NotificationToken? = nil
    
    private var items = [Item]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl().also {
            $0.addTarget(self, action: #selector(reload), for: .valueChanged)
            $0.tintColor = .white
        }
fatalError()
        title = R.string.localizable.managementTitle()
        tableView.apply {
            $0.separatorStyle = .none
            $0.register(SemesterplaningViewCell.self)
            $0.register(StudenAdministrationViewCell.self)
            $0.register(PrincipalExamOfficeViewCell.self)
            $0.register(StuRaHTWViewCell.self)
            $0.backgroundColor = UIColor.htw.veryLightGrey
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.apply {
            $0.estimatedRowHeight    = 100
            $0.rowHeight             = UITableView.automaticDimension
        }
        observeSemesterPlaning()
        load()
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    fileprivate func load(_ refreshControl: UIRefreshControl? = nil) {
        context.managementService.load(parameters: ())
            .observeOn(MainScheduler.instance)
            .delay(DispatchTimeInterval.milliseconds(refreshControl == nil ? 5 : 500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] items in
                guard let self = self else { return }
                self.items = items
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: {
                   refreshControl?.endRefreshing()
                })
            }, onError: { (error) in
                Log.error(error)
            }).disposed(by: self.rx_disposeBag)
    }
    
    @objc func reload() {
        load(refreshControl)
    }
}

// MARK: - TableView
extension ManagementViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch items[indexPath.row] {
        case .semesterPlan(let model):
            let cell = tableView.dequeueReusableCell(SemesterplaningViewCell.self, for: indexPath)!
            cell.setup(with: model)
            return cell
            
        case .studenAdministation(let model):
            let cell = tableView.dequeueReusableCell(StudenAdministrationViewCell.self, for: indexPath)!
            cell.setup(with: model)
            return cell
            
        case .principalExamOffice(let model):
            let cell = tableView.dequeueReusableCell(PrincipalExamOfficeViewCell.self, for: indexPath)!
            cell.setup(with: model)
            return cell
            
        case .stuRaHTW(let model):
            let cell = tableView.dequeueReusableCell(StuRaHTWViewCell.self, for: indexPath)!
            cell.setup(with: model)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
}

extension ManagementViewController {
    
    private func observeSemesterPlaning() {
        let realm = try! Realm()
        let results = realm.objects(SemesterPlaningRealm.self)

        notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
            guard let self = self else { return }
            switch changes {
            case .initial:
                self.tableView.reloadData()
            case .update(_, _, let insertions, _):
                guard let tableView = self.tableView else { return }
                insertions.forEach { _ in
                    self.load()
                }
                tableView.reloadData()
            case .error(let error):
                Log.error(error)
            }
        }
    }
    
}
