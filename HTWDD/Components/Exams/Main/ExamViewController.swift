//
//  ExamViewController.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 07.08.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift
import Action

class ExamViewController: UITableViewController, HasSideBarItem {
    
    // MARK: - Properties
    var context: ExamsCoordinator.Services!
    private var items: [ExamRealm] = []
    private var notificationToken: NotificationToken? = nil
    
    lazy var action: Action<Void, [Exam]> = Action { [weak self] (_) -> Observable<[Exam]> in
        guard let self = self else { return Observable.empty() }
        return self.context.examService.loadExams().observeOn(MainScheduler.instance).debug()
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
        observeExams()
        tableView.backgroundView = stateView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        load()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.apply {
            $0.estimatedRowHeight   = 200
            $0.rowHeight            = UITableView.automaticDimension
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
    }
    
    deinit {
        notificationToken?.invalidate()
    }
}

// MARK: - Setup
extension ExamViewController {
    
    private func setup() {

        refreshControl = UIRefreshControl().also {
            $0.tintColor = .white
            $0.rx.bind(to: action, input: ())
        }
        
        title = R.string.localizable.examsTitle()
        
        tableView.apply {
            $0.separatorStyle = .none
            $0.backgroundColor = UIColor.htw.veryLightGrey
            $0.register(ExamViewCell.self)
        }
    }
    
    @objc private func load() {
        
        action.elements.subscribe { [weak self] event in
            guard let self = self else { return }
            if let exams = event.element {
                ExamRealm.save(from: exams)
                self.stateView.isHidden = true
                
                if exams.isEmpty {
                    self.stateView.setup(with: EmptyResultsView.Configuration(icon: "🥺", title: R.string.localizable.examsNoResultsTitle(), message: R.string.localizable.examsNoResultsHint(), hint: nil, action: nil))
                }
            }
        }.disposed(by: rx_disposeBag)
        
        action.errors.subscribe { [weak self] error in
            guard let self = self else { return }
            self.stateView.setup(with: EmptyResultsView.Configuration(icon: "🤯", title: R.string.localizable.examsNoCredentialsTitle(), message: R.string.localizable.examsNoCredentialsMessage(), hint: R.string.localizable.add(), action: UITapGestureRecognizer(target: self, action: #selector(self.onTap))))
        }.disposed(by: rx_disposeBag)
        
        action.execute()
    }
    
}

// MARK: - Table Datasource
extension ExamViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(ExamViewCell.self, for: indexPath)!.also {
            $0.setup(with: items[indexPath.row])
        }
    }
    
    @objc private func onTap() {
        let viewController = R.storyboard.onboarding.studyGroupViewController()!
        viewController.context = self.context
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        viewController.delegateClosure = { [weak self] in
            guard let self = self else { return }
            self.load()
        }
        present(viewController, animated: true, completion: nil)
    }
}

// MARK: - Realm Data Obsering
extension ExamViewController {
    
    private func observeExams() {
        let realm = try! Realm()
        let results = realm.objects(ExamRealm.self).sorted(byKeyPath: "day")
        items = results.map { $0 }
        
        // Observe
        notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
            guard let self = self else { return }
            switch changes {
            case .initial:
                self.tableView.reloadData()
            case .update(let collectionResults, let deletions, let insertions, let modifications):
                guard let tableView = self.tableView else { return }
                if self.items == collectionResults.sorted(byKeyPath: "day").map { $0 } {
                    return
                }
                self.items = collectionResults.sorted(byKeyPath: "day").map { $0 }
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .none)
                tableView.endUpdates()
            case .error(let error):
                Log.error(error)
            }
        }
    }
}
