//
//  MealsForWeekTableViewController.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 15.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift

class MealsForWeekTableViewController: UITableViewController {

    // MARK: - Properties
    var canteenDetail: CanteenDetail?
    var context: HasCanteen?
    var weekState: CanteenService.WeekState!
    private var meals: [[Meal]] = [] {
        didSet {
            if !meals[0].isEmpty {
                categories.append(R.string.localizable.monday())
            }
            
            if !meals[1].isEmpty {
                categories.append(R.string.localizable.tuesday())
            }
            
            if !meals[2].isEmpty {
                categories.append(R.string.localizable.wednesday())
            }
            
            if !meals[3].isEmpty {
                categories.append(R.string.localizable.thursday())
            }
            
            if !meals[4].isEmpty {
                categories.append(R.string.localizable.friday())
            }
            tableView.reloadData()
            scrollToCurrenDay()
        }
    }
    private var categories: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        context?.canteenService.requestMeals(for: weekState, and: (canteenDetail?.canteen.id)!)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] meals in
                guard let self = self else { return }
                self.meals = meals
            }, onError: { [weak self] in
                guard let self = self else { return }
                Log.error($0)
                self.tableView.setEmptyMessage(R.string.localizable.canteenMealNoResultErrorTitle(), message: R.string.localizable.canteenMealNoResultErrorMessage(), icon: "😖")
            })
        .disposed(by: rx_disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.apply {
            $0.estimatedRowHeight   = 200
            $0.rowHeight            = UITableView.automaticDimension
        }
    }
    
    private func scrollToCurrenDay() {
        
        if !(meals.flatMap( { $0 } ).isEmpty) && weekState == CanteenService.WeekState.current {
            let section: Int
            switch Date().weekday {
            case .monday: section       = 0
            case .tuesday: section      = 1
            case .wednesday: section    = 2
            case .thursday: section     = 3
            case .friday: section       = 4
            default: section = 0
            }
            
            let indexPath = IndexPath(row: 0, section: section)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
}

// MARK: - Setup
extension MealsForWeekTableViewController {
    
    private func setup() {
        tableView.apply {
            $0.separatorStyle   = .none
            $0.backgroundColor  = UIColor.htw.veryLightGrey
            $0.register(MealViewCell.self)
        }
    }
    
}

// MARK: - TableView Datasource
extension MealsForWeekTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if meals.flatMap( { $0 } ).count == 0 {
            tableView.setEmptyMessage(R.string.localizable.canteenNoResultsTitle(), message: R.string.localizable.canteenMealNoResultForWeekErrorMessage(), icon: "🍽")
        } else {
            tableView.restore()
        }
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(MealViewCell.self, for: indexPath)!
        cell.setup(with: meals[indexPath.section][indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let day: Date
        switch section {
        case 0: day =   weekState == CanteenService.WeekState.current ? Date().dateOfWeek(for: Date.Week.beginn)    : Date().dateOfWeek(for: UInt(Date.Week.beginn.rawValue + 7))
        case 1: day =   weekState == CanteenService.WeekState.current ? Date().dateOfWeek(for: Date.Week.second)    : Date().dateOfWeek(for: UInt(Date.Week.second.rawValue + 7))
        case 2: day =   weekState == CanteenService.WeekState.current ? Date().dateOfWeek(for: Date.Week.mid)       : Date().dateOfWeek(for: UInt(Date.Week.mid.rawValue + 7))
        case 3: day =   weekState == CanteenService.WeekState.current ? Date().dateOfWeek(for: Date.Week.lead)      : Date().dateOfWeek(for: UInt(Date.Week.lead.rawValue + 7))
        default: day =  weekState == CanteenService.WeekState.current ? Date().dateOfWeek(for: Date.Week.end)       : Date().dateOfWeek(for: UInt(Date.Week.end.rawValue + 7))
        }
        
        return BlurredSectionHeader(frame: tableView.frame, header: categories[section], subHeader: day.string(format: "EEEE, dd. MMM"))
    }
}
