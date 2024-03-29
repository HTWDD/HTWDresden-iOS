//
//  TimetableElectiveLessonSelectionViewController.swift
//  HTWDD
//
//  Created by Chris Herlemann on 18.05.21.
//  Copyright © 2021 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift
import RxRealm

class TimetableElectiveLessonSelectionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: TimetableElectiveLessonSelectionViewModel!
    let searchController = UISearchController(searchResultsController: nil)
    
    private var filteredElectiveLessons = [Lesson]()
    private var electiveLessons = [Lesson]() {
        didSet {
            filteredElectiveLessons = electiveLessons
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        self.title = R.string.localizable.electiveLessonSelectionTitle()
        
        if #available(iOS 13.0, *) {
            searchController.searchResultsUpdater = self
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.placeholder = R.string.localizable.searchbarPlaceholder()
            searchController.searchBar.searchTextField.backgroundColor = .white
            navigationItem.hidesSearchBarWhenScrolling = false
            
            navigationItem.searchController = searchController
            definesPresentationContext = true
            
            searchController.searchBar.delegate = self
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TimetableElectiveLessonCell.self)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        }
        
        self.navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: R.string.localizable.close(), style: .plain, target: self, action: #selector(close))
        
        viewModel.loadElectiveLessons()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] electiveLessons in
                guard let self = self else { return }
                self.electiveLessons = electiveLessons
            }, onError: { (error) in
                Log.error(error)
            }).disposed(by: self.rx_disposeBag)
    }
    
    @objc func close() {
        self.dismiss(animated: true)
    }
    
    func filterContentForSearchText(_ searchText: String?) {
        guard let searchText = searchText, searchText.count > 0 else {
            filteredElectiveLessons = electiveLessons
            tableView.reloadData()
            return
        }
        
        filteredElectiveLessons = electiveLessons.filter { (lesson: Lesson) -> Bool in
            let nameFilter = lesson.name.lowercased().contains(searchText.lowercased())
            let professorFilter = (lesson.professor ?? "").lowercased().contains(searchText.lowercased())
            var dayFilter = false
            if let day = CalendarWeekDay(rawValue: lesson.day) {
                dayFilter = day.localizedDescription.lowercased().contains(searchText.lowercased())
            }
            
            let studiesIntegraleFilter = "studiumintegrale".contains(searchText.lowercased().replacingOccurrences(of: " ", with: "")) && lesson.isStudiesIntegrale ?? false
            
            return  nameFilter || professorFilter || dayFilter || studiesIntegraleFilter
        }
        tableView.reloadData()
    }
}

extension TimetableElectiveLessonSelectionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredElectiveLessons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(TimetableElectiveLessonCell.self, for: indexPath)!
        cell.setup(lesson: filteredElectiveLessons[indexPath.row])
        return cell
    }
}

extension TimetableElectiveLessonSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.saveElectiveLesson(selected: filteredElectiveLessons[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
}

extension TimetableElectiveLessonSelectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text)
    }
}

extension TimetableElectiveLessonSelectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text)
    }
}
