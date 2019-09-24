//
//  RoomViewCell.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 26.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit

class RoomViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var main: UIView!
    @IBOutlet weak var lblRoomName: BadgeLabel!
    @IBOutlet weak var lblCountOfOccupancies: BadgeLabel!
    @IBOutlet weak var lblCurrentLesson: UILabel!
    @IBOutlet weak var imageViewChevron: UIImageView!
    @IBOutlet weak var viewSeparator: UIView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        main.apply {
            $0.layer.cornerRadius   = 4
            $0.backgroundColor      = UIColor.htw.cellBackground
        }
        
        lblRoomName.apply {
            $0.textColor        = UIColor.htw.Label.primary
        }
        
        lblCurrentLesson.apply {
            $0.textColor    = UIColor.htw.Label.secondary
        }
        
        lblCountOfOccupancies.apply {
            $0.textColor        = UIColor.htw.Label.primary
            $0.backgroundColor  = UIColor.htw.Badge.primary
        }
        
        imageViewChevron.apply {
            $0.tintColor = UIColor.htw.Icon.primary
        }
    }
}

// MARK: - Nib Loadable
extension RoomViewCell: FromNibLoadable {
    
    // MARK: - Setup
    func setup(with model: RoomRealm) {
        lblRoomName.text = model.name.uppercased()
        lblCountOfOccupancies.text = "\(model.occupancies.count)"
        
        // Get current occupancy for the day
        let occupanciesToday = Array(model.occupancies.filter("day = \(Date().weekday.dayByAdding(days: 1).rawValue)")).map { content -> Occupancy in
            
            let weeks = String(String(content.weeksOnly.dropFirst()).dropLast()).replacingOccurrences(of: " ", with: "").components(separatedBy: ",")
            return Occupancy(id: content.id,
                             name: content.name,
                             type: content.type,
                             day: content.day,
                             beginTime: content.beginTime,
                             endTime: content.endTime,
                             week: content.week,
                             professor: content.professor,
                             weeksOnly: weeks.compactMap( { Int($0) }))
        }
        
        if let current = occupanciesToday.filter({ $0.weeksOnly.contains(Date().weekday.rawValue) && ($0.beginTime...$0.endTime).contains(Date().string(format: "HH:mm:ss"))
        }).first {
            lblCurrentLesson.text = current.name
            viewSeparator.backgroundColor = UIColor.htw.Material.red
        } else {
            lblCurrentLesson.text = R.string.localizable.roomOccupancyFree()
            viewSeparator.backgroundColor = UIColor.htw.Material.green
        }
    }
}
