//
//  MealsViewController.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 11.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit

class MealsViewController: UITableViewController {

    // MARK: - Properties
    var canteenDetail: CanteenDetails?
    private var categories: [String]?
    private var meals: [[Meals]?] = []
    
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
    }
}

// MARK: - Setup
extension MealsViewController {
    
    private func setup() {

        tableView.apply {
            $0.separatorStyle   = .none
            $0.backgroundColor  = UIColor.htw.veryLightGrey
            $0.register(MealViewCell.self)
        }
        
        prepareDataSource()
    }
    
    private func prepareDataSource() {
        if let categories = canteenDetail?.meals.reduce(into: Set<String>(), { categories, meal in categories.insert(meal.category) }) {
            self.categories = Array(categories.sorted())
        }
        
        categories?.forEach { category in
            meals.append(canteenDetail?.meals.filter { $0.category == category })
        }
    }
}


// MARK: - TableView Datasource
extension MealsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals[section]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(MealViewCell.self, for: indexPath)!
        cell.model(for: meals[indexPath.section]?[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories?[section]
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        // No Categories? No Meal!
        if categories?.count == 0 {
            tableView.setEmptyMessage(R.string.localizable.canteenNoResultsTitle(), message: R.string.localizable.canteenNoResultsMessage(), icon: "🍽")
        } else {
            tableView.restore()
        }
        return categories?.count ?? 0
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
            $0.text         = categories?[section] ?? "N/A"
            $0.textColor    = UIColor.htw.darkGrey
            $0.font         = UIFont.from(style: .big)
        }
        
        let lblSubHeader = UILabel().also {
            $0.text         = Date().string(format: "EEEE, dd. MMM")
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
