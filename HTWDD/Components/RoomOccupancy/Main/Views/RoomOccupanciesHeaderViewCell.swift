//
//  RoomOccupanciesHeaderViewCell.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 25.09.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit

class RoomOccupanciesHeaderViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblSubheader: UILabel!
    
    // MARK: - Properties
    
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        lblHeader.apply {
            $0.textColor = UIColor.htw.Label.primary
        }

        lblSubheader.apply {
            $0.textColor = UIColor.htw.Label.secondary
        }
    }

}

// MARK: - Nib loadable
extension RoomOccupanciesHeaderViewCell: FromNibLoadable {
    
    func setup(with model: OccupancyHeader) {
        lblHeader.apply {
            $0.text = model.localizedHeader
        }
        
        lblSubheader.apply {
            $0.text = model.subheader
        }
    }
}
