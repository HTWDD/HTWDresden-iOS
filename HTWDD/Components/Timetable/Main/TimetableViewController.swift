//
//  TimetableViewController.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 01.10.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift
import Action

class TimetableViewController: UITableViewController, HasSideBarItem {

    // MARK: - Properties
    var viewModel: TimetableViewModel!
    var context: AppContext!
    
    private var items: [Timetables] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy var action: Action<Void, [Timetables]> = Action { [weak self] (_) -> Observable<[Timetables]> in
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
            $0.estimatedRowHeight   = 200
            $0.rowHeight            = UITableView.automaticDimension
        }
        
        load()
    }
  
}

// MARK: - Setup
extension TimetableViewController {
    
    private func setup() {
        
        refreshControl = UIRefreshControl().also {
            $0.tintColor = .white
            $0.rx.bind(to: action, input: ())
        }
        
        title = R.string.localizable.scheduleTitle()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: R.string.localizable.canteenToday(), style: .plain, target: self, action: #selector(scrolToToday))
        
        tableView.apply {
            $0.separatorStyle   = .none
            $0.backgroundColor  = UIColor.htw.veryLightGrey
            $0.backgroundView   = stateView
            $0.register(TimetableHeaderViewCell.self)
            $0.register(TimetableLessonViewCell.self)
            $0.register(TimetableFreedayViewCell.self)
        }
    }
    
    private func load() {
        
        action.elements.subscribe(onNext: { [weak self] items in
            guard let self = self else { return }
            self.items = items
            self.stateView.isHidden = true
            
            if items.isEmpty {
                self.stateView.setup(with: EmptyResultsView.Configuration(icon: "🥺", title: R.string.localizable.scheduleNoResultsTitle(), message: R.string.localizable.scheduleNoResultsMessage(), hint: nil, action: nil))
                self.items = []
            } else {
                self.scrolToToday(notAnimated: true)
            }
            
        }).disposed(by: rx_disposeBag)
        
        action.errors.subscribe(onNext: { [weak self] error in
            guard let self = self else { return }
            self.items = []
                
            self.stateView.setup(with: EmptyResultsView.Configuration(icon: "🤯", title: R.string.localizable.examsNoCredentialsTitle(), message: R.string.localizable.examsNoCredentialsMessage(), hint: R.string.localizable.add(), action: UITapGestureRecognizer(target: self, action: #selector(self.onTap))))
            
        }).disposed(by: rx_disposeBag)
        
        action.execute()
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
    
    @objc private func scrolToToday(notAnimated: Bool = true) {
        if !items.isEmpty {
            var indexOfHeader: Int = 0
            indexer: for (index, element) in items.enumerated() {
                switch element {
                case .header(let model):
                    if model.header == Date().string(format: "dd.MM.yyyy") {
                        indexOfHeader = index
                        break indexer
                    }
                default: break
                }
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.tableView.scrollToRow(at: IndexPath(row: indexOfHeader, section: 0), at: .top, animated: !notAnimated)
            }
        }
    }
}

// MARK: - Timetable Datasource
extension TimetableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (items[indexPath.row]) {
        case .header(let model):
            return tableView.dequeueReusableCell(TimetableHeaderViewCell.self, for: indexPath)!.also {
                $0.setup(with: model)
            }
        case .lesson(let model):
            return tableView.dequeueReusableCell(TimetableLessonViewCell.self, for: indexPath)!.also {
                $0.setup(with: model)
            }
        case .freeday(let model):
            return tableView.dequeueReusableCell(TimetableFreedayViewCell.self, for: indexPath)!.also {
                $0.setup(with: model)
            }
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = tableView.contentOffset.y
        if let cell = tableView.visibleCells.compactMap( { $0 as? TimetableFreedayViewCell } ).first {
            let x = cell.imageViewFreeday.frame.origin.x
            let w = cell.imageViewFreeday.bounds.width
            let h = cell.imageViewFreeday.bounds.height
            let y = (((offsetY + cell.frame.height * 2.5 ) - cell.frame.origin.y) / h) * 1.5
            cell.imageViewFreeday.frame = CGRect(x: x, y: y, width: w, height: h)
        }
    }
    
}
