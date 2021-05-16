//
//  TimetableLessonViewCell.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 01.10.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit

protocol LessonViewCellExportDelegate: class {
    func export(_ lesson: Lesson)
}

class TimetableLessonViewCell: UITableViewCell {

    @IBOutlet weak var main: UIView!
    @IBOutlet weak var lblExamName: UILabel!
    @IBOutlet weak var lblExaminer: UILabel!
    @IBOutlet weak var lblExamType: BadgeLabel!
    @IBOutlet weak var lblExamRooms: BadgeLabel!
    @IBOutlet weak var lblExamElective: BadgeLabel!
    @IBOutlet weak var lblExamBegin: UILabel!
    @IBOutlet weak var lblExamEnd: UILabel!
    @IBOutlet weak var separator: UIView!
    
    var lesson: Lesson?
    weak var exportDelegate: LessonViewCellExportDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        main.apply {
            $0.backgroundColor      = UIColor.htw.cellBackground
            $0.layer.cornerRadius   = 4
        }
        
        lblExamName.apply {
            $0.textColor = UIColor.htw.Label.primary
        }
        
        lblExaminer.apply {
            $0.textColor = UIColor.htw.Label.secondary
        }
        
        lblExamType.apply {
            $0.backgroundColor  = UIColor.htw.Badge.primary
            $0.textColor        = UIColor.htw.Label.primary
        }
        
        lblExamRooms.apply {
            $0.textColor        = .white
            $0.backgroundColor  = UIColor.htw.Material.blue
        }
        
        lblExamElective.apply {
            $0.backgroundColor  = UIColor.htw.Material.green
            $0.textColor        = .white
        }
        
        lblExamBegin.apply {
            $0.textColor = UIColor.htw.Label.primary
        }
        
        lblExamEnd.apply {
            $0.textColor = UIColor.htw.Label.primary
        }
        
        let exportGesture = UILongPressGestureRecognizer(target: self, action: #selector(exportLesson))
        self.addGestureRecognizer(exportGesture)
    }
    
    @objc func exportLesson() {
        guard let lesson = lesson else { return }
        
        exportDelegate?.export(lesson)
    }


}

// MARK: - Loadable
extension TimetableLessonViewCell: FromNibLoadable {
    
    func setup(with model: Lesson) {
        
        self.lesson = model
        
        separator.backgroundColor = model.type.timetableColor
        lblExamName.text    = model.name
        lblExamBegin.text   = String(model.beginTime.prefix(5))
        lblExamEnd.text     = String(model.endTime.prefix(5))
        lblExaminer.text    = model.professor?.nilWhenEmpty ?? R.string.localizable.roomOccupancyNoDozent()
        lblExamRooms.text   = String(model.rooms.description.dropFirst().dropLast()).replacingOccurrences(of: "\"", with: "")
        lblExamType.text    = model.type.localizedDescription
        
        switch model.type {
        case .electiveLesson, .electiveExercise, .electivePractical:
            lblExamElective.isHidden = false
        default:
            lblExamElective.isHidden = true
        }
    }
    
}
