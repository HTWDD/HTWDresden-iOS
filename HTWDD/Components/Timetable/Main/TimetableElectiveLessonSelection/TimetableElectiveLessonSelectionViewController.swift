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
    
    private var electiveLessons = [Lesson](){
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        self.title = "Wähle eine Veranstaltung"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TimetableElectiveLessonCell.self)
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        }
        
        self.navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schließen", style: .plain, target: self, action: #selector(close))
        
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
}

extension TimetableElectiveLessonSelectionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.electiveLessons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(TimetableElectiveLessonCell.self, for: indexPath)!
        cell.setup(lesson: electiveLessons[indexPath.row])
        return cell
    }
}

extension TimetableElectiveLessonSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.saveElectiveLesson(selected: electiveLessons[indexPath.row])
        
        self.navigationController?.popViewController(animated: true)
    }
}
