//
//  GradeAverageViewCell.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 29.09.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit

class GradeAverageViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var lblAverage: UILabel!
    @IBOutlet weak var lblCredits: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblAverage.apply {
            $0.textColor = .white
        }
        
        lblCredits.apply {
            $0.textColor = .white
        }
        
        mainView.apply {
            $0.backgroundColor = UIColor.htw.averageGradeBackground
        }
    }

}

// MARK: - Loadable
extension GradeAverageViewCell: FromNibLoadable {
    
    func setup(with model: GradeAverage) {
        lblAverage.text = model.localizedAverage
        lblCredits.text = model.localizedCredits
    }
    
}
