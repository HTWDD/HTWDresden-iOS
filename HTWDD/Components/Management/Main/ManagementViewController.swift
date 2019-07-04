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
    
    private var items = [Item]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(reload), for: .valueChanged)
        refreshControl?.tintColor = .white

        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .automatic
        }
        
        title = R.string.localizable.managementTitle()
        tableView.separatorStyle = .none
        tableView.register(SemesterplaningViewCell.self)
        tableView.register(StudenAdministrationViewCell.self)
        tableView.register(PrincipalExamOfficeViewCell.self)
        tableView.register(StuRaHTWViewCell.self)
        tableView.backgroundColor = UIColor.htw.veryLightGrey
        
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.estimatedRowHeight    = 100
        tableView.rowHeight             = UITableView.automaticDimension
        load()
    }
    
    fileprivate func load(_ refreshControl: UIRefreshControl? = nil) {
        context?.managementService.load(parameters: ())
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
        Log.debug("reload")
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
