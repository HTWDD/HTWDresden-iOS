//
//  RoomOccupanciesCollectionViewCell.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 30.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit

class RoomOccupanciesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblOccupancy: BadgeLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblOccupancy.apply {
            $0.backgroundColor  = UIColor.htw.Badge.date
            $0.textColor        = .white
        }
    }
}
