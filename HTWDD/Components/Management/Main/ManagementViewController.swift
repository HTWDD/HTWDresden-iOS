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


class ManagementViewController: UITableViewController, HasSideBarItem {
    
    // MARK: - Properties
    var context: HasManagement?
    
    
//    private let refreshControl = UIRefreshControl()
    
    private var items = [Item]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(self.reload), for: .valueChanged)
        self.refreshControl?.tintColor = .white

        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .automatic
        }
        
        self.title = R.string.localizable.managementTitle()
        self.tableView.separatorStyle = .none
        self.tableView.register(SemesterplaningViewCell.self)
        self.tableView.register(StudenAdministrationViewCell.self)
        self.tableView.register(PrincipalExamOfficeViewCell.self)
        self.tableView.register(StuRaHTWViewCell.self)
        self.tableView.backgroundColor = UIColor.htw.veryLightGrey
        
        context?.managementService.load(parameters: ())
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] items in
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
    
    @objc func reload() {
        Log.debug("reload")
        self.refreshControl?.endRefreshing()
    }
}
