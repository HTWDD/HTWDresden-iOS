//
//  DasboardLessonViewCell.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 30.09.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit

class DasboardLessonViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblBeginTime: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var lblLesson: UILabel!
    @IBOutlet weak var lblType: BadgeLabel!
    @IBOutlet weak var lblRoom: BadgeLabel!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var lblProfessor: UILabel!
    @IBOutlet weak var chevron: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView.apply {
            $0.backgroundColor      = UIColor.htw.cellBackground
            $0.layer.cornerRadius   = 4
        }
        
        lblBeginTime.apply {
            $0.textColor = UIColor.htw.Label.primary
        }
        
        lblEndTime.apply {
            $0.textColor = UIColor.htw.Label.primary
        }
        
        lblLesson.apply {
            $0.textColor = UIColor.htw.Label.primary
        }
        
        lblProfessor.apply {
            $0.textColor = UIColor.htw.Label.secondary
        }
        
        lblType.apply {
            $0.textColor        = UIColor.htw.Label.primary
            $0.backgroundColor  = UIColor.htw.Badge.primary
        }
        
        lblRoom.apply {
            $0.textColor        = .white
            $0.backgroundColor  = UIColor.htw.Material.blue
        }
        
        chevron.apply {
            $0.tintColor = UIColor.htw.Icon.primary
        }
    }
    
}

// MARK: - Loadable
extension DasboardLessonViewCell: FromNibLoadable {
    
    func setup(with model: Lesson) {
        separator.backgroundColor = "\(model.name) \(model.professor ?? String("prof"))".materialColor
        
        lblBeginTime.text = String(model.beginTime.prefix(5))
        lblEndTime.text = String(model.endTime.prefix(5))
        lblLesson.text = model.name
        lblProfessor.text = model.professor?.nilWhenEmpty ?? R.string.localizable.roomOccupancyNoDozent()
        lblType.text = model.type.localizedDescription
        lblRoom.text =  String(model.rooms.description.dropFirst().dropLast()).replacingOccurrences(of: "\"", with: "")
    }
    
}
