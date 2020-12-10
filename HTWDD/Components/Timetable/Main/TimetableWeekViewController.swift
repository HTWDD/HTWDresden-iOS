//
//  TimetableWeekViewController.swift
//  HTWDD
//
//  Created by Chris Herlemann on 04.12.20.
//  Copyright © 2020 HTW Dresden. All rights reserved.
//

class TimetableWeekViewController: TimetableBaseViewController {
 
    @IBOutlet var collectionView: UICollectionView!
    
    override func setup() {
        super.setup()
        
//        tableView.apply {
//            $0.separatorStyle   = .none
//            $0.backgroundColor  = UIColor.htw.veryLightGrey
//            $0.backgroundView   = stateView
//            $0.register(TimetableHeaderViewCell.self)
//            $0.register(TimetableLessonViewCell.self)
//            $0.register(TimetableFreedayViewCell.self)
//        }
    }
    
    override func reloadData(){
        collectionView.reloadData()
    }
    
    override func scrollViewTo(index: Int, notAnimated: Bool = true) {
//        self.tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .top, animated: !notAnimated)
    }
}

extension TimetableWeekViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    
}
