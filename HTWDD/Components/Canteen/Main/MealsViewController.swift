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
    var canteenDetail: CanteenDetail?
    private var categories: [String]?
    private var meals: [[Meal]?] = []
    
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
        cell.setup(with: meals[indexPath.section]?[indexPath.row])
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
        return BlurredSectionHeader(frame: tableView.frame, header: categories?[section] ?? "N/A", subHeader: Date().string(format: "EEEE, dd. MMM"))
    }
}
