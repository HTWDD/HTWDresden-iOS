//
//  TimetableBaseViewController.swift
//  HTWDD
//
//  Created by Chris Herlemann on 03.12.20.
//  Copyright © 2020 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift
import Action

class TimetableBaseViewController: UIViewController {
    
    // MARK: - Properties
    // MARK: - Properties
    var viewModel: TimetableViewModel!
    var context: AppContext!
    var refreshControl: UIRefreshControl?
    
    var items: [Timetables] = [] {
        didSet {
            //MARK: IMPORTANT TODO
            reloadData()
        }
    }
    
    lazy var action: Action<Void, [Timetables]> = Action { [weak self] (_) -> Observable<[Timetables]> in
        guard let self = self else { return Observable.empty() }
        return self.viewModel.load().observeOn(MainScheduler.instance)
    }
    
    let stateView: EmptyResultsView = {
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
        
        load()
    }
    
    func setup() {
        
        refreshControl = UIRefreshControl().also {
            $0.tintColor = .white
            $0.rx.bind(to: action, input: ())
        }
    }
    
    func reloadData() {
        fatalError("pls implement")
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
                self.scrollToToday(notAnimated: true)
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
    
    func scrollToToday(notAnimated: Bool = true) {
        guard !items.isEmpty else { return }
        
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
            self?.scrollViewTo(index: indexOfHeader)
        }
    }
    
    func scrollViewTo(index: Int, notAnimated: Bool = true) {
        fatalError("pls implement")
    }
}
