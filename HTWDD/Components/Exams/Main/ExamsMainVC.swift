//
//  ExamsMainVC.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift
import SideMenu

class ExamsMainVC: CollectionViewController, HasSideBarItem {
    
    enum Const {
        static let margin: CGFloat = 15
    }
    
    var auth: ScheduleService.Auth? {
        didSet {
            self.dataSource.auth = self.auth
        }
    }
    
    private let dataSource: ExamsDataSource
    
    private let context: HasApiService & HasExams
    
	// MARK: - Init
	
    init(context: HasExams & HasApiService) {
        self.dataSource = ExamsDataSource(context: context)
        self.context = context
        super.init()
        self.dataSource.collectionView = self.collectionView
        self.collectionView.contentInset = UIEdgeInsets(top: Const.margin, left: Const.margin, bottom: Const.margin, right: Const.margin)
        
        self.dataSource.register(type: ExamsCell.self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initialSetup() {
        super.initialSetup()
        self.title = Loca.Exams.title
    }
	
	// MARK: - ViewController lifecycle
	
    private let refreshControl = UIRefreshControl()
    
	override func viewDidLoad() {
		super.viewDidLoad()
        
        self.refreshControl.addTarget(self, action: #selector(reload), for: .valueChanged)
        self.refreshControl.tintColor = .white
		
		if #available(iOS 11.0, *) {
			self.navigationController?.navigationBar.prefersLargeTitles = true
			self.navigationItem.largeTitleDisplayMode = .automatic
			
             self.collectionView.refreshControl = self.refreshControl
		} else {
             self.collectionView.add(self.refreshControl)
		}
        
        let loading = self.dataSource.loading.filter { $0 == true }
        let notLoading = self.dataSource.loading.filter { $0 != true }
        
        loading
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.setLoading(true)
            })
            .disposed(by: self.rx_disposeBag)
        
        notLoading
            .delay(DispatchTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.refreshControl.endRefreshing()
                self?.setLoading(false)
            })
            .disposed(by: self.rx_disposeBag)
        
        
        let studyToken = KeychainService.shared.readStudyToken()
        if let year = studyToken.year, let major = studyToken.major, let group = studyToken.group, let grade = studyToken.graduation {
            context.apiService.requestExams(year: year, major: major, group: group, grade: String(grade.prefix(1)))
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                Log.debug("Data \($0)")
            }, onError: { Log.error($0) })
            .disposed(by: rx_disposeBag)
        }
        
        self.reload()
	}
    
    override func noResultsViewConfiguration() -> NoResultsView.Configuration? {
        return .init(title: Loca.Exams.noResults.title, message: Loca.Exams.noResults.message, image: nil)
    }
    
    @objc
    func reload() {
        self.dataSource.load()
    }
    
	
}

extension ExamsMainVC {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.itemWidth(collectionView: collectionView)
        return CGSize(width: width, height: 130)
    }
}

extension ExamsMainVC: TabbarChildViewController {
    func tabbarControllerDidSelectAlreadyActiveChild() {
        self.collectionView.setContentOffset(CGPoint(x: self.collectionView.contentOffset.x, y: -self.view.htw.safeAreaInsets.top), animated: true)
    }
}
