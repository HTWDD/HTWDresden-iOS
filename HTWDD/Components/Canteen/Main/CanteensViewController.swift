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
    var context: (HasApiService & HasCanteen)!
    let bag = DisposeBag()
    weak var appCoordinator: AppCoordinator?
    var canteenCoordinator: CanteenCoordinator?
    
    private var items = [CanteenDetail]() {
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
        refreshControl?.beginRefreshing()
        request()
    }
    
    // MARK: - Data Request
    fileprivate func request() {
        // Short Info: Request for each canteen the meals on the current day
        let currentDay = Date().string(format: "yyyy-MM-dd")
        context.canteenService.request()
            .observeOn(SerialDispatchQueueScheduler(qos: .background))                          // run in background
            .flatMap { canteens -> Observable<[CanteenDetail]> in
                let requests = canteens.map { [unowned self] canteen in
                    self.context.canteenService
                        .requestMeals(for: canteen.id, and: currentDay)
                        .map { meals in
                            return CanteenDetail(canteen: canteen, meals: meals)
                        }
                        .catchErrorJustReturn(CanteenDetail(canteen: canteen, meals: []))
                }
                return Observable.combineLatest(requests)
//                    .map { $0.filter({!$0.meals.isEmpty }) }
            }
            .observeOn(MainScheduler.instance)                                                  // run in ui thread
            .subscribe(onNext: { [weak self] canteenDetails in
                guard let self = self else { return }
                self.items = canteenDetails
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                    self.refreshControl?.endRefreshing()
                })
            }, onError: { [weak self] error in
                guard let self = self else { return }
                Log.error(error)
                self.tableView.setEmptyMessage(R.string.localizable.canteenNoResultsErrorTitle(), message: R.string.localizable.canteenNoResultsErrorMessage(), icon: "😖")
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(150), execute: {
                    self.refreshControl?.endRefreshing()
                })
            }).disposed(by: bag)
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
        
        registerForPreviewing(with: self, sourceView: tableView)
    }
    
    @objc func reload() {
        request()
    }
}

// MARK: - TableView Datasource
extension CanteenViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items.count == 0 {
            tableView.setEmptyMessage(R.string.localizable.canteenNoResultsTitle(), message: R.string.localizable.canteenNoResultsMessage(), icon: "🍽")
        } else {
            tableView.restore()
        }
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(CanteenViewCell.self, for: indexPath)!
        cell.setup(with: items[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Log.verbose("didSelectRowAt: \(indexPath.row)")
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
