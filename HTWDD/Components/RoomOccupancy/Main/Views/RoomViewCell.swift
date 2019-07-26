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
    @IBOutlet weak var lblRoomName: UILabel!
    @IBOutlet weak var lblCountOfOccupancies: BadgeLabel!
    @IBOutlet weak var lblDescriptionOccupancies: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        main.apply {
            $0.layer.cornerRadius = 4
        }
        
        lblRoomName.apply {
            $0.textColor    = UIColor.htw.darkGrey
            $0.font         = UIFont.from(style: .description)
        }
        
        lblCountOfOccupancies.apply {
            $0.textColor        = .white
            $0.backgroundColor  = UIColor.htw.mediumOrange
            $0.font             = UIFont.from(style: .small, isBold: true)
        }
        
        lblDescriptionOccupancies.apply {
            $0.textColor    = UIColor.htw.grey
            $0.font         = UIFont.from(style: .small)
            $0.text         = R.string.localizable.roomOccupancyDescription()
        }
    }

}

// MARK: - Nib Loadable
extension RoomViewCell: FromNibLoadable {
    
    // MARK: - Setup
    func setup(with model: RoomRealm) {
        lblRoomName.text = model.name
        lblCountOfOccupancies.text = "\(model.numberOfOccupancies)"
    }
    
}
