//
//  GradeMainVC.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 30/11/2016.
//  Copyright © 2016 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift

class GradeMainVC: CollectionViewController {

    enum Const {
        static let margin: CGFloat = 10
    }
    
    var auth: GradeService.Auth? {
        set { self.dataSource.auth = newValue }
        get { return nil }
    }

    private lazy var dataSource = GradeDataSource(context: self.context)

    private let refreshControl = UIRefreshControl()

    private var selectedIndexPath: IndexPath?

    private let layout = CollectionViewFlowLayout()
    
    let context: HasGrade
	
	// MARK: - Init
	
    init(context: HasGrade) {
        self.context = context
        super.init(layout: self.layout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initialSetup() {
        super.initialSetup()
        self.title = Loca.Grades.title
		self.tabBarItem.image = #imageLiteral(resourceName: "Grade")
    }

	// MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.contentInset = UIEdgeInsets(top: Const.margin,
                                                        left: Const.margin,
                                                        bottom: Const.margin,
                                                        right: Const.margin)

        self.refreshControl.addTarget(self, action: #selector(reload), for: .valueChanged)
		self.refreshControl.tintColor = .white
		
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .automatic

            self.collectionView.refreshControl = self.refreshControl
        } else {
            self.collectionView.add(self.refreshControl)
        }

        self.dataSource.collectionView = self.collectionView
        
        self.dataSource.register(type: GradeAverageCell.self)
        self.dataSource.register(type: GradeCell.self) { [weak self] cell, _, indexPath in
            if self?.selectedIndexPath == indexPath {
                cell.updatedExpanded(true)
            }
        }
        self.dataSource.registerSupplementary(CollectionHeaderView.self, kind: .header) { [weak self] view, indexPath in
            guard let information = self?.dataSource.information(for: indexPath.section) else {
                view.attributedTitle = nil
                return
            }
            
            let semesterTitle = information.semester.localized
            let attributedTitle = NSAttributedString(string: (semesterTitle),
                                                     attributes: [.foregroundColor: UIColor.htw.textHeadline, .font: UIFont.systemFont(ofSize: 22, weight: .bold)])
            let averageTitle = NSAttributedString(string: Loca.Grades.average(information.average),
                                                  attributes: [.foregroundColor: UIColor.htw.textBody, .font: UIFont.systemFont(ofSize: 16, weight: .semibold)])
            view.attributedTitle = attributedTitle + " " + averageTitle
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
            .delay(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.refreshControl.endRefreshing()
                self?.setLoading(false)
            })
            .disposed(by: self.rx_disposeBag)
        
        self.reload()
    }
    
    override func noResultsViewConfiguration() -> NoResultsView.Configuration? {
        return .init(title: Loca.Grades.noResults.title, message: Loca.Grades.noResults.message, image: nil)
    }

	// MARK: - Private

	@objc private func reload() {
		self.dataSource.load()
	}

	// MARK: - Actions

    private func showAlert(error: Error) {
        let alert = UIAlertController(title: "Fehler", message: "Some failure in loading: \(error.localizedDescription)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let _ = collectionView.cellForItem(at: indexPath) as? GradeCell else { return }
        
        func animate(block: @escaping () -> Void) {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: [.beginFromCurrentState, .curveEaseInOut], animations: block, completion: nil)
        }
        
        if self.selectedIndexPath == indexPath {
            self.selectedIndexPath = nil
            animate {
                collectionView.reloadItems(at: [indexPath])
            }
            return
        }
        
        let currentSelected = self.selectedIndexPath
        self.selectedIndexPath = indexPath
        let indexPaths = [indexPath] + (currentSelected.map { [$0] } ?? [])
        animate {
            collectionView.reloadItems(at: indexPaths)
        }
        
        let oldCell = currentSelected.flatMap(collectionView.cellForItem) as? GradeCell
        oldCell?.updatedExpanded(false)
        
        let newCell = collectionView.cellForItem(at: indexPath) as? GradeCell
        newCell?.updatedExpanded(true)
    }
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

}

extension GradeMainVC {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.itemWidth(collectionView: collectionView)
        let height: CGFloat
        if self.selectedIndexPath == indexPath {
            height = GradeCell.Const.expandedHeight
        } else {
            height = GradeCell.Const.collapsedHeight
        }
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: self.itemWidth(collectionView: collectionView), height: 20)
        }
        return CGSize(width: self.itemWidth(collectionView: collectionView), height: 60)
    }
    
}

extension GradeMainVC: TabbarChildViewController {
    func tabbarControllerDidSelectAlreadyActiveChild() {
        self.collectionView.setContentOffset(CGPoint(x: self.collectionView.contentOffset.x, y: -self.view.htw.safeAreaInsets.top), animated: true)
    }
}
