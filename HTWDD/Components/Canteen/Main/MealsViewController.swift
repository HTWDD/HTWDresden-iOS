//
//  MealsViewController.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 11.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift

class MealsViewController: UITableViewController {

    // MARK: - Properties
    var viewModel: MealsViewModel!
    private var items: [Meals] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private let stateView: EmptyResultsView = {
        return EmptyResultsView().also {
            $0.isHidden = true
        }
    }()
    
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
    }
}

// MARK: - Setup
extension MealsViewController {
    
    private func setup() {
        
        tableView.apply {
            $0.separatorStyle   = .none
            $0.backgroundColor  = UIColor.htw.veryLightGrey
            $0.backgroundView   = stateView
            $0.register(MealHeaderViewCell.self)
            $0.register(MealViewCell.self)
        }
        
        viewModel
            .load()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] items in
                guard let self = self else { return }
                self.items = items
                
                if items.isEmpty {
                    self.stateView.setup(with: EmptyResultsView.Configuration(icon: "😦", title: R.string.localizable.canteenNoResultsTitle(), message: R.string.localizable.canteenNoResultsMessage(), hint: nil, action: nil))
                }
                
            }, onError: { error in
                Log.error(error)
            })
            .disposed(by: rx_disposeBag)
    }
}


// MARK: - TableView Datasource
extension MealsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch items[indexPath.row] {
        case .header(let model):
            let cell = tableView.dequeueReusableCell(MealHeaderViewCell.self, for: indexPath)!
            cell.setup(with: model)
            return cell
        case .meal(let model):
            let cell = tableView.dequeueReusableCell(MealViewCell.self, for: indexPath)!
            cell.setup(with: model)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
}
