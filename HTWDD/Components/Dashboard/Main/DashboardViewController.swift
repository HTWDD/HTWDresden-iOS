//
//  DashboardViewController.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 18.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift
import Action

class DashboardViewController: UITableViewController, HasSideBarItem {
    
    // MARK: - Properties
    var context: (HasDashboard & AppContext)!
    var viewModel: DashboardViewModel!
    weak var appCoordinator: AppCoordinator?
    private var mItems: [Dashboards] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private lazy var action: Action<Void, [Dashboards]> = Action { [weak self] (_) -> Observable<[Dashboards]> in
        guard let self = self else { return Observable.empty() }
        return self.viewModel.load().observeOn(MainScheduler.instance)
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
            $0.estimatedRowHeight   = 100
            $0.rowHeight            = UITableView.automaticDimension
        }
        
        load()
        askForCrashlyticsPermission()
    }
    
    private func load() {
        action
            .elements
            .subscribe(onNext: { [weak self] items in
                guard let self = self else { return }
                self.mItems = items
            })
            .disposed(by: rx_disposeBag)
        
        action
            .errors
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.stateView.setup(with: EmptyResultsView.Configuration(icon: "🤯", title: R.string.localizable.networkErrorTitle(), message: R.string.localizable.networkErrorMessage(), hint: nil, action: nil))
            })
            .disposed(by: rx_disposeBag)
        
        action.execute()
    }
    
}

// MARK: - Setup
extension DashboardViewController {
    
    private func setup() {
        
        refreshControl = UIRefreshControl().also {
            $0.tintColor = .white
            $0.rx.bind(to: action, input: ())
        }
        
        title = R.string.localizable.dashboardTitle()
        
        tableView.apply {
            $0.separatorStyle   = .none
            $0.backgroundColor  = UIColor.htw.veryLightGrey
            $0.backgroundView   = stateView
            $0.register(DashboardHeaderViewCell.self)
            $0.register(DasboardLessonViewCell.self)
            $0.register(DashboardTimeTableFreeTableViewCell.self)
            $0.register(DashboardTimeTableNoStudyTokenViewCell.self)
            $0.register(DashboardMealsViewCell.self)
            $0.register(DashboardMealViewCell.self)
            $0.register(DashboardTimeTableViewCell.self)
            $0.register(DashboardGradeViewCell.self)
            $0.register(DashboardGradeNoCredentialsViewCell.self)
            $0.register(DashboardGradeEmptyViewCell.self)
        }
        
    }
    
    private func askForCrashlyticsPermission() {
        
        guard !UserDefaults.standard.crashlytics,
        !UserDefaults.standard.crashlyticsAsked,
              let firstLaunch = UserDefaults.standard.firstLaunchDate,
              Int(Date().timeIntervalSince(firstLaunch) / 86400) > 3 else {
            return
        }
        
        UserDefaults.standard.crashlyticsAsked = true
        
        let alert = UIAlertController(title: R.string.localizable.onboardingCrashlyticsHelpQuestion(), message: "\(R.string.localizable.onboardingCrashlyticsDescription()) \(R.string.localizable.onboardingCrashlyticsRevokeDescription())", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: R.string.localizable.cancel(), style: .default, handler: { _ in
            UserDefaults.standard.crashlytics = true
        }))
        
        alert.addAction(UIAlertAction(title: R.string.localizable.yes(), style: .cancel, handler: { _ in
            UserDefaults.standard.crashlytics = false
        }))
        
        self.present(alert, animated: true)
    }
}

// MARK: - TableView Datasource
extension DashboardViewController {
    
    // MARK: - Fixed Reichenbach Canteen
    private var reichenbachCanteen: Canteen {
        return Canteen(id: 80, name: "Mensa Reichenbachstraße", address: "Reichenbachstr. 1, 01069 Dresden, Deutschland", coordinates: [51.0340605791208, 13.7340366840363])
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch mItems[indexPath.row] {
        case .header(let model):
            let cell = tableView.dequeueReusableCell(DashboardHeaderViewCell.self, for: indexPath)!
            cell.setup(with: model)
            return cell
        case .lesson(let model):
            let cell = tableView.dequeueReusableCell(DasboardLessonViewCell.self, for: indexPath)!
            cell.setup(with: model)
            return cell
        case .freeDay:
            return tableView.dequeueReusableCell(DashboardTimeTableFreeTableViewCell.self, for: indexPath)!
        case .grade(let model):
            let cell = tableView.dequeueReusableCell(DashboardGradeViewCell.self, for: indexPath)!
            cell.setup(with: model)
            return cell
        case .noAuthToken:
           let cell = tableView.dequeueReusableCell(DashboardGradeNoCredentialsViewCell.self, for: indexPath)!
           return cell
        case .noStudyToken: return tableView.dequeueReusableCell(DashboardTimeTableNoStudyTokenViewCell.self, for: indexPath)!
        case .emptyGrade:
            let cell = tableView.dequeueReusableCell(DashboardGradeEmptyViewCell.self, for: indexPath)!
            return cell
        case .meals(let models):
            let cell = tableView.dequeueReusableCell(DashboardMealsViewCell.self, for: indexPath)!
            cell.setup(with: models)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch mItems[indexPath.row] {
        case .freeDay,
             .lesson(_): appCoordinator?.goTo(controller: .schedule)
        case .grade(_),
             .emptyGrade: appCoordinator?.goTo(controller: .grades)
        case .noAuthToken:
            let viewController = R.storyboard.onboarding.loginViewController()!.also {
                $0.context                  = self.context
                $0.modalPresentationStyle   = .overCurrentContext
                $0.modalTransitionStyle     = .crossDissolve
                $0.delegateClosure = { [weak self] in
                    guard let self = self else { return }
                    self.load()
                }
            }
            present(viewController, animated: true, completion: nil)
        case .noStudyToken:
            let viewController = R.storyboard.onboarding.studyGroupViewController()!
            viewController.context                  = self.context
            viewController.modalPresentationStyle   = .overCurrentContext
            viewController.modalTransitionStyle     = .crossDissolve
            viewController.delegateClosure = { [weak self] in
                guard let self = self else { return }
                self.load()
            }
            present(viewController, animated: true, completion: nil)
        case .meals(let meals):
            let canteenDetails = CanteenDetail(canteen: reichenbachCanteen, meals: meals)
            appCoordinator?.goTo(controller: .meal(canteenDetail: canteenDetails), animated: true)
        default:
            break
        }
    }
    
}
