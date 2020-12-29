//
//  TimetableFreedayViewCell.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 06.03.20.
//  Copyright © 2020 HTW Dresden. All rights reserved.
//

import UIKit

class TimetableFreedayViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var main: UIView!
    @IBOutlet weak var imageWrapper: UIView!
    @IBOutlet weak var imageViewFreeday: UIImageView!
    @IBOutlet weak var lblFreeday: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        main.apply {
            $0.layer.cornerRadius   = 4
            $0.backgroundColor      = UIColor.htw.cellBackground
            $0.clipsToBounds        = true
        }
        
        imageWrapper.apply {
            $0.layer.cornerRadius   = 4
            $0.clipsToBounds        = true
        }
        
        imageViewFreeday.apply {
            addParallaxToView($0, amount: 10)
            $0.layer.cornerRadius   = 4
            $0.clipsToBounds        = true
            $0.layer.masksToBounds  = true
        }
        
        lblFreeday.apply {
            addParallaxToView($0, amount: 20)
        }
    }
}

extension TimetableFreedayViewCell: FromNibLoadable {
    func setup(with model: FreeDays) {
        switch model {
        case .noLesson:
            lblFreeday.text = R.string.localizable.scheduleFreeDay()
            break
        }
    }
    
    private func addParallaxToView(_ view: UIView, amount: Int) {
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount

        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount

        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        view.addMotionEffect(group)
    }
}
