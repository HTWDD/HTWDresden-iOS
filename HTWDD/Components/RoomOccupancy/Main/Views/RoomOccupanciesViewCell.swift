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
    @IBOutlet weak var lblBeginn: BadgeLabel!
    @IBOutlet weak var lblEnd: BadgeLabel!
    @IBOutlet weak var collection: UICollectionView!
    
    // MARK: - Properties
    private var occupancies: [String] = [] {
        didSet {
            collection.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        main.apply {
            $0.layer.cornerRadius = 4
            $0.dropShadow()
        }
        
        lblName.apply {
            $0.textColor        = UIColor.htw.darkGrey
            $0.font             = UIFont.from(style: .description)
            $0.numberOfLines    = 0
        }
        
        lblProfessorName.apply {
            $0.textColor        = UIColor.htw.grey
            $0.font             = UIFont.from(style: .small)
            $0.numberOfLines    = 0
        }
        
        lblType.apply {
            $0.backgroundColor  = UIColor.htw.mediumOrange
            $0.textColor        = .white
            $0.font             = UIFont.from(style: .verySmall, isBold: true)
        }
        
        lblBeginn.apply {
            $0.backgroundColor  = UIColor(hex: 0xC9C9C9)
            $0.textColor        = UIColor.htw.darkGrey
            $0.font             = UIFont.from(style: .verySmall, isBold: true)
        }
        
        lblEnd.apply {
            $0.backgroundColor  = UIColor(hex: 0xC9C9C9)
            $0.textColor        = UIColor.htw.darkGrey
            $0.font             = UIFont.from(style: .verySmall, isBold: true)
        }
        
        collection.apply {
            $0.dataSource   = self
            $0.delegate     = self
            $0.register(UINib.init(nibName: "RoomOccupanciesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "roomOccupanciesCell")
        }
        
    }

}

// MARK: - Nib laodable
extension RoomOccupanciesViewCell: FromNibLoadable {
    
    func setup(with model: Occupancy?) {
        guard let model = model else { return }
        
        lblName.text            = model.name.nilWhenEmpty ?? R.string.localizable.roomOccupancyNoName()
        lblProfessorName.text   = model.professor.nilWhenEmpty ?? R.string.localizable.roomOccupancyNoDozent()
        lblType.text            = model.type
        lblBeginn.text          = String(model.beginTime.prefix(5))
        lblEnd.text             = String(model.endTime.prefix(5))
        
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
