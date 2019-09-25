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
    var viewModel: RoomOccupancyDetailViewModel!
    
    private var items: [Occupancies] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        viewModel
            .load(id: roomName.uid)
            .subscribe(onNext: { [weak self] items in
                guard let self = self else { return }
                self.items = items
            })
            .disposed(by: rx_disposeBag)
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
        title = roomName.uppercased()
        tableView.apply {
            $0.separatorStyle   = .none
            $0.backgroundColor  = UIColor.htw.veryLightGrey
            $0.register(RoomOccupanciesHeaderViewCell.self)
            $0.register(RoomOccupanciesViewCell.self)
        }
    }
}

// MARK: - TableView DataSource
extension RoomOccupancyDetailViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch items[indexPath.row] {
        case .header(let model):
            let cell = tableView.dequeueReusableCell(RoomOccupanciesHeaderViewCell.self, for: indexPath)!
            cell.setup(with: model)
            return cell
        case .occupancy(let model):
            let cell = tableView.dequeueReusableCell(RoomOccupanciesViewCell.self, for: indexPath)!
            cell.setup(with: model)
            return cell
        }
    }

}
