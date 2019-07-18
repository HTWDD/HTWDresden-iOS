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
    var canteenDetail: CanteenDetails?
    var context: HasCanteen?
    var weekState: CanteenService.WeekState!
    private var meals: [[Meals]] = [] {
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
        cell.model(for: meals[indexPath.section][indexPath.row])
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
        
        // Blur Effect for Header
        let wrapper = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 60)).also { wrapperView in
            wrapperView.addSubview(UIVisualEffectView(effect: UIBlurEffect(style: .extraLight)).also { effectView in
                effectView.frame = wrapperView.bounds
            })
        }
        
        // REGION Header with SubHeader
        let vStack = UIStackView().also {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis         = .vertical
            $0.distribution = .fill
            $0.spacing      = 3
        }
        
        let lblHeader = UILabel().also {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.text         = categories[section]
            $0.textColor    = UIColor.htw.darkGrey
            $0.font         = UIFont.from(style: .big)
        }
        
        let day: Date
        switch section {
        case 0: day =   weekState == CanteenService.WeekState.current ? Date().dateOfWeek(for: Date.Week.beginn)    : Date().dateOfWeek(for: UInt(Date.Week.beginn.rawValue + 7))
        case 1: day =   weekState == CanteenService.WeekState.current ? Date().dateOfWeek(for: Date.Week.second)    : Date().dateOfWeek(for: UInt(Date.Week.second.rawValue + 7))
        case 2: day =   weekState == CanteenService.WeekState.current ? Date().dateOfWeek(for: Date.Week.mid)       : Date().dateOfWeek(for: UInt(Date.Week.mid.rawValue + 7))
        case 3: day =   weekState == CanteenService.WeekState.current ? Date().dateOfWeek(for: Date.Week.lead)      : Date().dateOfWeek(for: UInt(Date.Week.lead.rawValue + 7))
        default: day =  weekState == CanteenService.WeekState.current ? Date().dateOfWeek(for: Date.Week.end)       : Date().dateOfWeek(for: UInt(Date.Week.end.rawValue + 7))
        }
        
        let lblSubHeader = UILabel().also {
            $0.text         = day.string(format: "EEEE, dd. MMM")
            $0.textColor    = UIColor.htw.grey
            $0.font         = UIFont.from(style: .small)
        }
        // ENDREGION Header with SubHeader
        
        vStack.addArrangedSubview(lblHeader)
        vStack.addArrangedSubview(lblSubHeader)
        
        wrapper.addSubview(vStack)
        
        // Header Spacing
        NSLayoutConstraint.activate([
            lblHeader.leadingAnchor.constraint(equalTo: vStack.leadingAnchor, constant: 10),
            lblHeader.trailingAnchor.constraint(equalTo: vStack.trailingAnchor, constant: 10),
            lblHeader.topAnchor.constraint(equalTo: vStack.topAnchor, constant: 8)
            ])
        
        return wrapper
    }
}
