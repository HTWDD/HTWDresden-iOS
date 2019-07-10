//
//  CanteensViewController.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 10.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

class CanteenViewController: UITableViewController, HasSideBarItem {
    
    // MARK: - Properties
    var context: HasCanteen!
    
    private var items = [Canteens]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.apply {
            $0.estimatedRowHeight   = 200
            $0.rowHeight            = UITableView.automaticDimension
        }
        
        request()
    }
    
    // MARK: - Data Request
    fileprivate func request() {
        context.canteenService.request()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] canteens in
                guard let self = self else { return }
                self.items = canteens
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                    self.refreshControl?.endRefreshing()
                })
            }, onError: { error in
                Log.error(error)
            }).disposed(by: rx_disposeBag)
    }
}


// MARK: - Setup
extension CanteenViewController {
    
    private func setup() {
        refreshControl = UIRefreshControl().also {
            $0.addTarget(self, action: #selector(reload), for: .valueChanged)
            $0.tintColor = .white
        }
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .automatic
        }

        title = R.string.localizable.canteenPluralTitle()
        
        tableView.apply {
            $0.separatorStyle   = .none
            $0.backgroundColor  = UIColor.htw.veryLightGrey
            $0.register(CanteenViewCell.self)
        }
    }
    
    @objc func reload() {
        request()
    }
}

// MARK: - TableView
extension CanteenViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(CanteenViewCell.self, for: indexPath)!
        cell.model(for: items[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
}
