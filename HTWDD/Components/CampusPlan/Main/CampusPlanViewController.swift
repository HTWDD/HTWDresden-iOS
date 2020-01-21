//
//  CampusPlanViewControllerTableViewController.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 25.09.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift

class CampusPlanViewController: UITableViewController, HasSideBarItem {
    
    // MARK: - Properties
    var context: HasCampusPlan!
    var viewModel: CampusPlanViewModel!
    private var items = [CampusPlan]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.campusPlanTitle()
        tableView.apply {
            $0.separatorStyle   = .none
            $0.backgroundColor  = UIColor.htw.veryLightGrey
            $0.register(CampusPlanViewCell.self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.apply {
            $0.estimatedRowHeight   = 200
            $0.rowHeight            = UITableView.automaticDimension
        }
        load()
    }
    
    private func load() {
        viewModel
            .load()
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] items in
                guard let self = self else { return }
                self.items = items
            }, onError: { error in
                Log.error(error)
            })
            .disposed(by: rx_disposeBag)
    }
    
    func animateUIImageView(_ campusPlanImageView: UIImageView?) {
        guard let campusPlanImageView = campusPlanImageView else { return }
        
        let viewController = R.storyboard.campusPlan.campusPlanModalViewController()!.also {
            $0.image                    = campusPlanImageView.image
            $0.modalPresentationStyle   = .overCurrentContext
            $0.modalTransitionStyle     = .crossDissolve
        }
        present(viewController, animated: true, completion: nil)
    }
}

// MARK: - TableView Datasource
extension CampusPlanViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(CampusPlanViewCell.self, for: indexPath)!.also {
            $0.setup(with: items[indexPath.row])
            $0.campusPlanViewController = self
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
}
