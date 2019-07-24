//
//  DashboardViewController.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 18.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift

class DashboardViewController: UITableViewController, HasSideBarItem {
    
    // MARK: - Properties
    var context: HasDashboard!
    weak var appCoordinator: AppCoordinator?
    private var sections: [Section] = []
    private var items: [[DashboardItem]] = [[], [], []] {
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
            $0.estimatedRowHeight   = 100
            $0.rowHeight            = UITableView.automaticDimension
        }
        
        request()
    }
    
    // MARK: - Sections
    struct Section {
        let title: String
        let subtitle: String
    }
}

// MARK: - Setup
extension DashboardViewController {
    
    private func setup() {
        
        if #available(iOS 11.00, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .automatic
        }
        
        title = R.string.localizable.dashboardTitle()
        
        tableView.apply {
            $0.separatorStyle   = .none
            $0.backgroundColor  = UIColor.htw.veryLightGrey
            $0.register(DashboardMealViewCell.self)
            $0.register(DashboardTimeTableViewCell.self)
            $0.register(DashboardGradeViewCell.self)
        }
        
        sections.append(contentsOf: [
            Section(title: R.string.localizable.scheduleTitle(), subtitle: Date().string(format: "EEEE, dd. MMM")),
            Section(title: R.string.localizable.canteenTitle(), subtitle: "⭐️ Reichenbachstraße"),
            Section(title: R.string.localizable.gradesTitle(), subtitle: "")
            ])
    }
    
    private func request() {
        requestTimeTable()
        requestMeals()
        requestGrades()
    }
    
    private func requestMeals() {
        context.dashboardService.loadMealFor()
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] meals in
                guard let self = self else { return }
                self.items[1] = meals
                }, onError: { Log.error($0) })
            .disposed(by: rx_disposeBag)
    }
    
    private func requestTimeTable() {
        context.dashboardService.loadTimeTable()
            .asObservable()
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .map { lessons in
                lessons
                    .filter { $0.day == Date().weekday.dayByAdding(days: 1).rawValue }
                    .filter { $0.weeksOnly.contains(where: { $0 == Date().weekNumber }) }
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] lessons in
                guard let self = self else { return }
                
                let current = lessons
                    .filter({ (lesson: Lesson) -> Bool in
                        return (lesson.beginTime...lesson.endTime).contains(Date().string(format: "HH:mm:ss"))
                    })
                    .map({ (lesson: Lesson) -> DashboardItem in
                        return DashboardItem.lesson(model: lesson)
                    }).first
                
                if let current = current {
                    self.items[0].removeAll()
                    self.items[0].append(current)
                    
                    let next = lessons
                        .filter { $0.beginTime > Date().string(format: "HH:mm:ss") }
                        .map({ (lesson: Lesson) -> DashboardItem in
                            return DashboardItem.lesson(model: lesson)
                        }).first
                    
                    if let next = next {
                        self.items[0].append(next)
                    }
                } else {
                    self.items[0].removeAll()
                    self.items[0].append(DashboardItem.lesson(model: nil))
                }
                
                }, onError: { Log.error($0) })
            .disposed(by: rx_disposeBag)
    }
    
    private func requestGrades() {
        context.dashboardService.loadGrades()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] grades in
                guard let self = self else { return }
                
                let avarage = GradeService.calculateAverage(from: grades)
                self.sections[2] = Section(title: R.string.localizable.gradesTitle(), subtitle: R.string.localizable.gradesAverage(avarage))
                self.items[2].removeAll()
                self.items[2].append(DashboardItem.grade(models: grades))
                self.tableView.reloadData()
                }, onError: { Log.error($0) })
            .disposed(by: rx_disposeBag)
    }
    
}

// MARK: - TableView Datasource
extension DashboardViewController {
    
    // MARK: - Fixed Reichenbach Canteen
    private var reichenbachCanteen: Canteen {
        return Canteen(id: 80, name: "Mensa Reichenbachstraße", address: "Reichenbachstr. 1, 01069 Dresden, Deutschland", coordinates: [51.0340605791208, 13.7340366840363])
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch items[indexPath.section][indexPath.row] {
        case .meal(let model):
            let cell = tableView.dequeueReusableCell(DashboardMealViewCell.self, for: indexPath)!
            cell.setup(with: model)
            return cell
            
        case .lesson(let model):
            let cell = tableView.dequeueReusableCell(DashboardTimeTableViewCell.self, for: indexPath)!
            cell.setup(with: model, isCurrent: indexPath.row == 0)
            return cell
            
        case .grade(let models):
            let cell = tableView.dequeueReusableCell(DashboardGradeViewCell.self, for: indexPath)!
            cell.setup(with: models)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch items[indexPath.section][indexPath.row] {
        case .meal(_):
            let canteenDetails = CanteenDetail(canteen: reichenbachCanteen, meals: items[indexPath.section].compactMap({ $0.meal }))
            appCoordinator?.goTo(controller: .meal(canteenDetail: canteenDetails), animated: true)

        case .lesson(_):
            appCoordinator?.goTo(controller: .scheduleToday)
            
        case .grade(_):
            appCoordinator?.goTo(controller: .grades)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return BlurredSectionHeader(frame: tableView.frame, header: sections[section].title, subHeader: sections[section].subtitle)
    }
    
}
