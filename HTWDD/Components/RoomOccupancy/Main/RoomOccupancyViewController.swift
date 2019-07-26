//
//  RoomOccupancyViewController.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 25.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift

class RoomOccupancyViewController: UITableViewController, HasSideBarItem {
    
    // MARK: - Properties
    var context: HasRoomOccupancy!
    private var notificationToken: NotificationToken? = nil
    private var items: [RoomRealm] = [] 
    private lazy var addRoomAlertDialog: UIAlertController = {
        return UIAlertController(title: R.string.localizable.roomOccupancyAddTitle(), message: R.string.localizable.roomOccupancyAddMessage(), preferredStyle: .alert).also { alert in
            alert.addAction(UIAlertAction(title: R.string.localizable.close(), style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: R.string.localizable.add(), style: .default, handler: { action in
                if let text = alert.textFields?.first?.text {
                    if let superView = self.navigationController?.view {
                        self.showLoadingIndicator(on: superView)
                    }
                    
                    self.context.roomOccupanyService.loadRooms(room: text)
                        .asObservable()
                        .observeOn(MainScheduler.instance)
                        .subscribe(onNext: { [weak self] in
                            guard let self = self else { return }
                            RoomRealm.save(room: text, numberOf: $0.count)
                            Log.verbose("Rooms: \($0)")
                        }, onError: { [weak self] error in
                            guard let self = self else { return }
                            let errorAlert = UIAlertController(title: R.string.localizable.roomOccupancyErrorAlertTitle(),
                                                               message: R.string.localizable.roomOccupancyErrorAlertMessage(text),
                                                               preferredStyle: .alert).also { $0.addAction(UIAlertAction(title: "OK", style: .default, handler: nil)) }
                            self.present(errorAlert, animated: true, completion: nil)
                            Log.error(error)
                        }, onDisposed: { [weak self] in
                            guard let self = self else { return }
                            self.removeLoadingIndicator()
                        })
                        .disposed(by: self.rx_disposeBag)
                }
            }))
            alert.actions[1].isEnabled = false
            alert.addTextField(configurationHandler: { textField in
                textField.placeholder   = R.string.localizable.roomOccupancyAddPlaceholder()
                textField.delegate      = self
            })
        }
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        observeRooms()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.apply {
            $0.estimatedRowHeight   = 200
            $0.rowHeight            = UITableView.automaticDimension
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }
}


// MARK: - Setup
extension RoomOccupancyViewController {
    
    private func setup() {
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .automatic
        }
        
        title = R.string.localizable.roomOccupancyTitle()
        
        tableView.apply {
            $0.separatorStyle   = .none
            $0.backgroundColor  = UIColor.htw.veryLightGrey
            $0.register(RoomViewCell.self)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRoom))
    }
    
    @objc private func addRoom() {
        present(addRoomAlertDialog, animated: true, completion: nil)
    }
    
}

// MARK: - Textfield Delegate
extension RoomOccupancyViewController: UITextFieldDelegate {
    
    private var validRegEx: String {
        return #"^[a-z] [a-z0-9]{3,5}$"#
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.subviews.forEach { $0.removeFromSuperview() }
        
        if let text = textField.text, let _ = NSString(string: text).replacingCharacters(in: range, with: string).range(of: validRegEx, options: .regularExpression) {
            addRoomAlertDialog.actions[1].isEnabled = true
        } else {
            textField.addSubview(UILabel(frame: CGRect(x: 0, y: textField.bounds.height + 2, width: textField.bounds.width, height: textField.bounds.height)).also {
                $0.text = R.string.localizable.roomOccupancyInvalid()
                $0.font = UIFont.from(style: .verySmall)
                $0.textColor = UIColor.htw.redMaterial
            })
            addRoomAlertDialog.actions[1].isEnabled = false
        }
        
        return true
    }
}


// MARK: - TableView Datasource
extension RoomOccupancyViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items.count == 0 {
            tableView.setEmptyMessage(R.string.localizable.roomOccupancyEmptyTitle(), message: R.string.localizable.roomOccupancyEmptyMessage(), icon: "💡")
        } else {
            tableView.restore()
        }
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(RoomViewCell.self, for: indexPath)!
        cell.setup(with: items[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction(style: .destructive, title: "🗑") { [weak self] (action, indexPath) in
            if let roomItem = self?.items[indexPath.row] {
                self?.items.remove(at: indexPath.row)
                RoomRealm.delete(room: roomItem)
            }
        }.also { $0.backgroundColor = UIColor.htw.veryLightGrey }]
    }
}


// MARK: - Realm Data Observing
extension RoomOccupancyViewController {
    
    private func observeRooms() {
        let realm   = try! Realm()
        let results = realm.objects(RoomRealm.self).sorted(byKeyPath: "name")
        items       = results.map { $0 }
        
        // Observe
        notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
            guard let self = self else { return }
            switch changes {
            case .initial:
                self.tableView.reloadData()
            case .update(let collectionResults, let deletions, let insertions, let modifications):
                guard let tableView = self.tableView else { return }
                self.items = collectionResults.sorted(byKeyPath: "name").map { $0 }
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                Log.error(error)
            }
        }
    }
}
