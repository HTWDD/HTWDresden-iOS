//
//  CanteensViewController.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 10.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift
import Action

class CanteenViewController: UITableViewController, HasSideBarItem {
    
    // MARK: - Properties
    var context: (HasApiService & HasCanteen)!
    var viewModel: CanteenViewModel!
    weak var appCoordinator: AppCoordinator?
    var canteenCoordinator: CanteenCoordinator?
    
    private var items = [CanteenDetail]() {
        didSet {
            if oldValue != items {
                tableView.reloadData()
            }
        }
    }
    
    private let stateView: EmptyResultsView = {
        return EmptyResultsView().also {
            $0.isHidden = true
        }
    }()
    
    private lazy var action: Action<Void, [CanteenDetail]> = Action { [weak self] (_) -> Observable<[CanteenDetail]> in
        guard let self = self else { return Observable.empty() }
        return self.viewModel.load().observeOn(MainScheduler.instance)
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
        load()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
    }
    
    // MARK: - Data Request
    private func load() {
        action
            .elements
            .subscribe { [weak self] event in
                guard let self = self else { return }
                if let details = event.element {
                    self.items = details
                    self.stateView.isHidden = true
                    
                    if details.isEmpty {
                        self.stateView.setup(with: EmptyResultsView.Configuration(icon: "🍽", title: R.string.localizable.canteenNoResultsTitle(), message: R.string.localizable.canteenNoResultsMessage(), hint: nil, action: nil))
                    }
            }
        }.disposed(by: rx_disposeBag)
        
        action
            .errors
            .subscribe { [weak self] error in
                guard let self = self else { return }
                self.stateView.setup(with: EmptyResultsView.Configuration(icon: "😖", title: R.string.localizable.canteenNoResultsErrorTitle(), message: R.string.localizable.canteenNoResultsErrorMessage(), hint: nil, action: nil))
            }
            .disposed(by: rx_disposeBag)
        
        action.execute()
    }
}


// MARK: - Setup
extension CanteenViewController {
    
    private func setup() {
        refreshControl = UIRefreshControl().also {
            $0.tintColor = .white
            $0.rx.bind(to: action, input: ())
        }
        
        title = R.string.localizable.canteenPluralTitle()
        
        tableView.apply {
            $0.separatorStyle   = .none
            $0.backgroundColor  = UIColor.htw.veryLightGrey
            $0.backgroundView   = stateView
            $0.register(CanteenViewCell.self)
        }
        
        registerForPreviewing(with: self, sourceView: tableView)
    }
}

// MARK: - TableView Datasource
extension CanteenViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(CanteenViewCell.self, for: indexPath)!
        cell.setup(with: items[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appCoordinator?.goTo(controller: .meal(canteenDetail: items[indexPath.row]), animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
}

// MARK: 3D Touch Peek
extension CanteenViewController: UIViewControllerPreviewingDelegate {
    
    private func createDetailController(indexPath: IndexPath) -> MealsTabViewController {
        
        return R.storyboard.canteen.mealsTabViewController()!.also {
            $0.context              = self.context
            $0.canteenDetail        = items[indexPath.row]
            $0.canteenCoordinator   = self.canteenCoordinator
        }
        
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location) else { return nil }
        return createDetailController(indexPath: indexPath)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}
