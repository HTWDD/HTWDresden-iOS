//
//  RoomOccupancyDetailViewController.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 29.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift


class RoomOccupancyDetailViewController: UITableViewController {
    
    // MARK: - Properties
    var context: HasRoomOccupancy!
    var roomName: String!
    private var items: [Int : [Occupancy]] = [:] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.apply {
            $0.estimatedRowHeight   = 230
            $0.rowHeight            = UITableView.automaticDimension
        }
    }
}

// MARK: - Setup
extension RoomOccupancyDetailViewController {
    
    private func setup() {
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .automatic
        }
        
        title = roomName
        
        tableView.apply {
            $0.separatorStyle   = .none
            $0.backgroundColor  = UIColor.htw.veryLightGrey
            $0.register(RoomOccupanciesViewCell.self)
        }
        
    }
    
    private func loadData() {
        let realm = try! Realm()
        let results = realm.objects(RoomRealm.self).filter(NSPredicate(format: "id = %@", roomName.uid)).first
        
        if let results = results {
            let occupancies = results.occupancies.sorted(byKeyPath: "day").map { occupancy -> Occupancy in
                
                let weeks = String(String(occupancy.weeksOnly.dropFirst()).dropLast()).replacingOccurrences(of: " ", with: "").components(separatedBy: ",")
                
                return Occupancy(id: occupancy.id,
                                 name: occupancy.name,
                                 type: occupancy.type,
                                 day: occupancy.day,
                                 beginTime: occupancy.beginTime,
                                 endTime: occupancy.endTime,
                                 week: occupancy.week,
                                 professor: occupancy.professor,
                                 weeksOnly: weeks.compactMap( { Int($0) }))
                }.sorted { (lhs, rhs) in lhs.beginTime < rhs.beginTime }
            
            self.items = Dictionary.init(grouping: occupancies) { (element: Occupancy) in
                return element.day
            }
        }
    }
    
}

// MARK: - TableView DataSource
extension RoomOccupancyDetailViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = items[section + 1]?.count {
            return count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(RoomOccupanciesViewCell.self, for: indexPath)!
        cell.setup(with: items[indexPath.section + 1]?[indexPath.row])
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let day = items[section + 1]?.first?.day {
            
            let localizedDay: String?
            switch day {
            case 1: localizedDay = R.string.localizable.monday()
            case 2: localizedDay = R.string.localizable.tuesday()
            case 3: localizedDay = R.string.localizable.wednesday()
            case 4: localizedDay = R.string.localizable.thursday()
            case 5: localizedDay = R.string.localizable.friday()
            case 6: localizedDay = R.string.localizable.saturday()
            case 7: localizedDay = R.string.localizable.sunday()
            default: localizedDay = nil
            }
            
            guard localizedDay != nil else { return nil }
            
            return BlurredSectionHeader(frame: tableView.frame, header: localizedDay!, subHeader: "\(items[section + 1]?.count ?? 0) \(R.string.localizable.roomOccupancyDescription())")
        }
        return nil
    }
}
