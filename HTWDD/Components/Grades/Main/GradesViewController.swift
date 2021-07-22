//
//  GradesViewController.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 27.09.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift
import Action
import Moya

class GradesViewController: UITableViewController, HasSideBarItem {
    
    // MARK: - Properties
    var context: AppContext!
    var viewModel: GradesViewModel!
    private var items: [Grades] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private let stateView: EmptyResultsView = {
        return EmptyResultsView().also {
            $0.isHidden = true
        }
    }()
    
    private lazy var action: Action<Void, [Grades]> = Action { [weak self] (_) -> Observable<[Grades]> in
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
            $0.estimatedRowHeight = 100
            $0.rowHeight = UITableView.automaticDimension
        }
        load()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
    }
}

// MARK: - Setup
extension GradesViewController {
    
    private func setup() {
        
        refreshControl = UIRefreshControl().also {
            $0.tintColor = .white
            $0.rx.bind(to: action, input: ())
        }
        
        title = R.string.localizable.gradesTitle()
        
        tableView.apply {
            $0.separatorStyle   = .none
            $0.backgroundColor  = UIColor.htw.veryLightGrey
            $0.backgroundView   = stateView
            $0.register(GradeAverageViewCell.self)
            $0.register(GradeHeaderViewCell.self)
            $0.register(GradeViewCell.self)
            $0.register(GradeLegalInfoCell.self)
        }
        
    }
    
    // MARK: - Data Request
    private func load() {
        action
            .elements
            .subscribe { [weak self] event in
                guard let self = self else { return }
                if let items = event.element {
                    self.items = items
                    self.items.append(.legalInfo)
                    self.stateView.isHidden = true
                    
                    self.hideAverageCell()
                    
                    if items.isEmpty {
                        self.stateView.setup(with: EmptyResultsView.Configuration(icon: "🤯", title: R.string.localizable.gradesNoResultsTitle(), message: R.string.localizable.gradesNoResultsMessage(), hint: nil, action: nil))
                    }
                }
            }.disposed(by: rx_disposeBag)
        
        action
            .errors
            .subscribe(onNext: { [weak self] error in
                guard let self = self else { return }
                self.items = []
                switch error {
                case .underlyingError(MoyaError.statusCode(_)):
                    self.stateView.setup(with: EmptyResultsView.Configuration(icon: "🤯", title: R.string.localizable.networkErrorTitle(), message: R.string.localizable.networkErrorMessage(), hint: nil, action: nil))
                default:
                    self.stateView.setup(with: EmptyResultsView.Configuration(icon: "😖", title: R.string.localizable.gradesNoCredentialsTitle(), message: R.string.localizable.gradesNoCredentialsMessage(), hint: R.string.localizable.add(), action: UITapGestureRecognizer(target: self, action: #selector(self.onTap))))
                }
                
            }).disposed(by: rx_disposeBag)
        
        action.execute()
    }
    
    private func hideAverageCell() {
        self.items.removeAll(where: {
            if case .average = $0 {
                return true
            }
            
            return false
        })
    }
    
    @objc private func onTap() {
        let viewController = R.storyboard.onboarding.loginViewController()!.also {
            $0.context = self.context
            $0.modalPresentationStyle = .overCurrentContext
            $0.modalTransitionStyle = .crossDissolve
            $0.delegateClosure = { [weak self] in
                guard let self = self else { return }
                self.load()
            }
        }
        present(viewController, animated: true, completion: nil)
    }
}

// MARK: - TableView Datasource
extension GradesViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch items[indexPath.row] {
        case .grade(let model):
            let cell = tableView.dequeueReusableCell(GradeViewCell.self, for: indexPath)!
            cell.setup(with: model)
            return cell
        case .header(let model):
            let cell = tableView.dequeueReusableCell(GradeHeaderViewCell.self, for: indexPath)!
            cell.setup(with: model)
            return cell
        case .average(let model):
            
            let cell = tableView.dequeueReusableCell(GradeAverageViewCell.self, for: indexPath)!
            cell.setup(with: model)
            return cell
        case .legalInfo:
            let cell = tableView.dequeueReusableCell(GradeLegalInfoCell.self, for: indexPath)!
            return cell
        }
    }
    
}
