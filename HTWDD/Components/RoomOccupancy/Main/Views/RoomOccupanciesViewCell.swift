//
//  RoomOccupanciesViewCell.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 29.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit

class RoomOccupanciesViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var main: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblProfessorName: UILabel!
    @IBOutlet weak var lblType: BadgeLabel!
    @IBOutlet weak var lblBeginTime: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var viewSeparator: UIView!
    
    // MARK: - Properties
    private var occupancies: [String] = [] {
        didSet {
            collection.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        main.apply {
            $0.layer.cornerRadius   = 4
            $0.backgroundColor      = UIColor.htw.cellBackground
        }
        
        lblName.apply {
            $0.textColor        = UIColor.htw.Label.primary
            $0.numberOfLines    = 0
        }
        
        lblProfessorName.apply {
            $0.textColor        = UIColor.htw.Label.secondary
            $0.numberOfLines    = 0
        }
        
        lblType.apply {
            $0.backgroundColor  = UIColor.htw.Badge.primary
            $0.textColor        = UIColor.htw.Label.primary
        }
        
        lblBeginTime.apply {
            $0.textColor = UIColor.htw.Label.primary
        }
        
        lblEndTime.apply {
            $0.textColor = UIColor.htw.Label.primary
        }
        
        collection.apply {
            $0.dataSource       = self
            $0.delegate         = self
            $0.backgroundColor  = UIColor.htw.cellBackground
            $0.register(UINib.init(nibName: "RoomOccupanciesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "roomOccupanciesCell")
        }
        
    }

}

// MARK: - Nib laodable
extension RoomOccupanciesViewCell: FromNibLoadable {
    
    func setup(with model: Occupancy?) {
        guard let model = model else { return }
        viewSeparator.backgroundColor = "\(model.name) \(model.professor)".materialColor
        lblName.text            = model.name.nilWhenEmpty ?? R.string.localizable.roomOccupancyNoName()
        lblProfessorName.text   = model.professor.nilWhenEmpty ?? R.string.localizable.roomOccupancyNoDozent()
        lblType.text            = model.type
        lblBeginTime.text = String(model.beginTime.prefix(5))
        lblEndTime.text = String(model.endTime.prefix(5))
        
        occupancies = model.weeksOnly.compactMap { (week: Int) -> String? in
            let component = DateComponents(weekday: model.day, weekOfYear: week, yearForWeekOfYear: Int(Date().string(format: "yyyy")))
            
            if let date = Calendar.current.date(from: component)?.string(format: "dd.MM.") {
                return date
            } else {
                return nil
            }
        }
    }
}


// MARK: - CollectionView
extension RoomOccupanciesViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return occupancies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "roomOccupanciesCell", for: indexPath) as! RoomOccupanciesCollectionViewCell
        cell.lblOccupancy.text = occupancies[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 45, height: 20)
    }
}
