//
//  TimetableViewController.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 01.10.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//


class TimetableListViewController: TimetableBaseViewController {

    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.apply {
            $0.estimatedRowHeight   = 200
            $0.rowHeight            = UITableView.automaticDimension
        }
    }
    
    override func setup() {
        super.setup()
        
        tableView.apply {
            $0.separatorStyle   = .none
            $0.backgroundColor  = UIColor.htw.veryLightGrey
            $0.backgroundView   = stateView
            $0.register(TimetableHeaderViewCell.self)
            $0.register(TimetableLessonViewCell.self)
            $0.register(TimetableFreedayViewCell.self)
        }
    }
    
    override func reloadData(){
        tableView.reloadData()
    }
    
    override func scrollViewTo(index: Int, notAnimated: Bool = true) {
        self.tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .top, animated: !notAnimated)
    }
}

// MARK: - Timetable Datasource
extension TimetableListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (items[indexPath.row]) {
        case .header(let model):
            return tableView.dequeueReusableCell(TimetableHeaderViewCell.self, for: indexPath)!.also {
                $0.setup(with: model)
            }
        case .lesson(let model):
            return tableView.dequeueReusableCell(TimetableLessonViewCell.self, for: indexPath)!.also {
                $0.setup(with: model)
            }
        case .freeday(let model):
            return tableView.dequeueReusableCell(TimetableFreedayViewCell.self, for: indexPath)!.also {
                $0.setup(with: model)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = tableView.contentOffset.y
        if let cell = tableView.visibleCells.compactMap( { $0 as? TimetableFreedayViewCell } ).first {
            let x = cell.imageViewFreeday.frame.origin.x
            let w = cell.imageViewFreeday.bounds.width
            let h = cell.imageViewFreeday.bounds.height
            let y = (((offsetY + cell.frame.height * 2.5 ) - cell.frame.origin.y) / h) * 1.5
            cell.imageViewFreeday.frame = CGRect(x: x, y: y, width: w, height: h)
        }
    }
    
}
