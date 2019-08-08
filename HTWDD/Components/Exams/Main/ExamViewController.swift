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

class ExamViewController: UITableViewController, HasSideBarItem {
    
    // MARK: - Properties
    var context: AppContext!
    private var items: [ExaminationRealm] = []
    private var notificationToken: NotificationToken? = nil
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        observeExams()
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
            $0.addTarget(self, action: #selector(load), for: .valueChanged)
            $0.tintColor = .white
        }
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .automatic
        }
        
        title = R.string.localizable.examsTitle()
        
        tableView.apply {
            $0.separatorStyle = .none
            $0.backgroundColor = UIColor.htw.veryLightGrey
            $0.register(ExamViewCell.self)
        }
        
    }
    
    @objc private func load() {
        
        let studyToken = KeychainService.shared.readStudyToken()
        if let year = studyToken.year, let major = studyToken.major, let group = studyToken.group, let grade = studyToken.graduation {
             context?.apiService
                .requestExams(year: year, major: major, group: group, grade: String(grade.prefix(1)))
                .asObservable()
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] exams in
                    guard (self != nil) else { return }
                    ExaminationRealm.save(from: exams)
                }, onError: { [weak self] in
                    guard let self = self else { return }
                    self.tableView.setEmptyMessage(R.string.localizable.examsNoResultsTitle(), message: R.string.localizable.examsNoResultsMessage(), icon: "🤯")
                    Log.error($0)
                }, onDisposed: { [weak self] in
                    guard let self = self else { return }
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                        self.refreshControl?.endRefreshing()
                    })
                })
                .disposed(by: rx_disposeBag)
        } else {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50), execute: { [weak self] in
                guard let self = self else { return }
                self.tableView.restore()
                self.tableView.setEmptyMessage(R.string.localizable.examsNoCredentialsTitle(), message: R.string.localizable.examsNoCredentialsMessage(), icon: "🤯", hint: R.string.localizable.add(), gestureRecognizer: UITapGestureRecognizer(target: self, action: #selector(self.onTap)))
                self.refreshControl?.endRefreshing()
            })
        }
    }
    
}

// MARK: - Table Datasource
extension ExamViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count == 0 ? tableView.setEmptyMessage(R.string.localizable.examsNoResultsTitle(), message: R.string.localizable.examsNoResultsHint(), icon: "💡") : tableView.restore()
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
            self.refreshControl?.beginRefreshing()
            self.load()
        }
        present(viewController, animated: true, completion: nil)
    }
}

// MARK: - Realm Data Obsering
extension ExamViewController {
    
    private func observeExams() {
        let realm = try! Realm()
        let results = realm.objects(ExaminationRealm.self).sorted(byKeyPath: "day")
        items = results.map { $0 }
        
        // Observe
        notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
            guard let self = self else { return }
            switch changes {
            case .initial:
                self.tableView.reloadData()
            case .update(let collectionResults, let deletions, let insertions, let modifications):
                guard let tableView = self.tableView else { return }
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
