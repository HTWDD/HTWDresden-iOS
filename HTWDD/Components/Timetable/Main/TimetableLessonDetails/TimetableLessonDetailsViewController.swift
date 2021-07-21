//
//  TimetableLessonDetailsViewController.swift
//  HTWDD
//
//  Created by Chris Herlemann on 18.12.20.
//  Copyright © 2020 HTW Dresden. All rights reserved.
//

import RxSwift
import UIKit

protocol TimetableLessonDetailsCellDelegate: AnyObject {
    
    func changeValue(forElement: LessonDetailElements,_ newValue: String?)
    func changeValue(forElement: LessonDetailElements,_ newValue: Int?)
    func changeValue(forElement: LessonDetailElements, _ date: Date)
    func changeValue(_ newValue: LessonType?)
}

class TimetableLessonDetailsViewController: UIViewController {
    
    var viewModel = TimetableDetailsViewModel()
    var context: AppContext!
    var lesson: CustomLesson = CustomLesson()
    var semseterWeeks: [Int]!
    
    private var elements = [[LessonDetailElements]]() {
        didSet {
            lessonDetailsTable.reloadData()
        }
    }
    
    private var isLessonCustomizable: Bool {
        guard let id = lesson.id else {
            return true
        }
        
        return viewModel.isCustomLesson(id: id)
    }
    
    @IBOutlet weak var lessonDetailsTable: UITableView!
    
    override func viewDidLoad() {
        
        self.title = isLessonCustomizable ? R.string.localizable.editLesson() : R.string.localizable.lesson()
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        
        lessonDetailsTable.dataSource = self
        lessonDetailsTable.delegate = self
        lessonDetailsTable.sectionHeaderHeight = 50
        lessonDetailsTable.keyboardDismissMode = .onDrag
        
        lessonDetailsTable.register(TimetableLessonDetailCell.self)
        lessonDetailsTable.register(TimetableLessonDetailsSelectionCell.self)
        lessonDetailsTable.register(TimetableLessonDetailTimePickerCell.self)
        lessonDetailsTable.register(TimetableDetailsSectionHeader.self, forHeaderFooterViewReuseIdentifier: "sectionSpacer")
        lessonDetailsTable.register(RequiredFooter.self, forHeaderFooterViewReuseIdentifier: "requiredFooter")
        lessonDetailsTable.register(EmptyFooter.self, forHeaderFooterViewReuseIdentifier: "emptyFooter")
        lessonDetailsTable.backgroundColor = UIColor.htw.veryLightGrey
        
        self.view.backgroundColor = UIColor .htw.veryLightGrey
        
        if isLessonCustomizable {
            elements = [
                [.lessonName, .abbrevation, .professor, .lessonType, .room],
                [.weekrotation, .day, .startTime, .endTime]
            ]
        } else {
            elements = [
                [.lessonName, .abbrevation, .professor, .lessonType, .room],
                [.day, .startTime, .endTime]
            ]
        }
        
        if isLessonCustomizable, lesson.id != nil {
            let deleteBtn = UIBarButtonItem.menuButton(self, action: #selector(deleteLesson), imageName: "Icon_Delete", insets: false)
            navigationItem.rightBarButtonItems = [deleteBtn]
        }
        
        if isLessonCustomizable {
            
            let saveBtn = UIBarButtonItem(title: R.string.localizable.save(), style: .plain, target: self, action: #selector(save))
            saveBtn.width = 110
            navigationItem.rightBarButtonItems = [saveBtn]
        }
    }
    
    func setup(model: Lesson) {
        
        self.lesson.id = model.id
        self.lesson.lessonTag = model.lessonTag
        self.lesson.name = model.name
        self.lesson.type = model.type
        self.lesson.day = model.day
        self.lesson.week = model.week
        self.lesson.beginTime = model.beginTime
        self.lesson.endTime = model.endTime
        self.lesson.weeksOnly = model.weeksOnly
        self.lesson.professor = model.professor
        self.lesson.rooms = model.rooms.joined(separator: ", ")
        
        if model.isElective {
            let hideBtn = UIBarButtonItem.menuButton(self, action: #selector(hideElectiveLesson), imageName: "Icons_Eye", insets: false)
            navigationItem.rightBarButtonItems = [hideBtn]
        }
    }
    
    private func close() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func save() {
        
        self.resignFirstResponder()
        
        guard viewModel.saveCustomLesson(lesson) else {
            showErrorSaving()
            return
        }
        
        close()
    }
    
    private func showErrorSaving() {
        let alert = UIAlertController(title: R.string.localizable.fillRequiredFieldsTitle(), message: R.string.localizable.fillRequiredFieldsMessage(), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    @objc func deleteLesson() {
        guard let lessonId = lesson.id else { return }
        
        viewModel.deleteCustomLesson(lessonId: lessonId)
        close()
    }
    
    @objc func hideElectiveLesson() {
        guard let lessonId = lesson.id else { return }
        
        let electiveLesson = Lesson(id: lessonId, lessonTag: lesson.lessonTag, name: lesson.name!, type: lesson.type!, day: lesson.day!, beginTime: lesson.beginTime!, endTime: lesson.endTime!, week: lesson.week!, weeksOnly: lesson.weeksOnly!, professor: lesson.professor, rooms: [lesson.rooms!], lastChanged: "lesson.lastChanged", isHidden: true)
        
        viewModel.hideElectiveLesson(selected: electiveLesson)
        close()
    }
}

extension TimetableLessonDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionHeader: TimetableDetailsSectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionSpacer") as! TimetableDetailsSectionHeader
        sectionHeader.title.text = (section == 0 ? R.string.localizable.general() : R.string.localizable.time())
        
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 1 {
            let requiredFooter: RequiredFooter = tableView.dequeueReusableHeaderFooterView(withIdentifier: "requiredFooter") as! RequiredFooter
            requiredFooter.title.text = R.string.localizable.fieldRequiered()
            
            return requiredFooter
        } else {
            let emptyFooter: EmptyFooter = tableView.dequeueReusableHeaderFooterView(withIdentifier: "emptyFooter") as! EmptyFooter
            
            return emptyFooter
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard section == 1 else {
            return 10
        }
        
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let detailElement = elements[indexPath.section][indexPath.row]
        
        switch detailElement {
        case .lessonName, .abbrevation, .professor, .room:
            let cell = lessonDetailsTable.dequeueReusableCell(TimetableLessonDetailCell.self, for: indexPath)!
            cell.lessonElement = elements[indexPath.section][indexPath.row]
            cell.delegate = self
            cell.setup(model: lesson, isEditable: isLessonCustomizable)
            return cell
        case .lessonType, .weekrotation:
            let cell = lessonDetailsTable.dequeueReusableCell(TimetableLessonDetailsSelectionCell.self, for: indexPath)!
            cell.lessonElement = elements[indexPath.section][indexPath.row]
            cell.delegate = self
            cell.setup(model: lesson, isEditable: isLessonCustomizable)
            return cell
        case .startTime, .endTime:
            let cell = lessonDetailsTable.dequeueReusableCell(TimetableLessonDetailTimePickerCell.self, for: indexPath)!
            cell.delegate = self
            cell.lessonElement = elements[indexPath.section][indexPath.row]
            cell.setup(model: lesson, isEditable: isLessonCustomizable)
            return cell
        case .day:
            if lesson.week == CalendarWeekRotation.once.rawValue {
                let cell = lessonDetailsTable.dequeueReusableCell(TimetableLessonDetailTimePickerCell.self, for: indexPath)!
                cell.delegate = self
                cell.lessonElement = elements[indexPath.section][indexPath.row]
                cell.setup(model: lesson, isEditable: isLessonCustomizable)
                return cell
            } else {
                let cell = lessonDetailsTable.dequeueReusableCell(TimetableLessonDetailsSelectionCell.self, for: indexPath)!
                cell.lessonElement = elements[indexPath.section][indexPath.row]
                cell.delegate = self
                cell.setup(model: lesson, isEditable: isLessonCustomizable)
                return cell
            }
        }
    }
}

extension TimetableLessonDetailsViewController: TimetableLessonDetailsCellDelegate {
    
    func changeValue(forElement: LessonDetailElements, _ newValue: String?) {
        
        let result: String? = (newValue?.trimmingCharacters(in: .whitespacesAndNewlines) != "" ? newValue : .none)
        
        switch forElement {
        
        case .lessonName: self.lesson.name = result
        case .abbrevation: self.lesson.lessonTag = result
        case .professor: self.lesson.professor = result
        case .room: self.lesson.rooms = result
        case .startTime: self.lesson.beginTime = result
        case .endTime: self.lesson.endTime = result
            
        default: break
        }
    }
    
    func changeValue(forElement: LessonDetailElements, _ newValue: Int?) {
        
        switch forElement {
        
        case .weekrotation:
            lesson.week = newValue
            
            switch lesson.week {
            case CalendarWeekRotation.everyWeek.rawValue: lesson.weeksOnly = self.semseterWeeks
            case CalendarWeekRotation.evenWeeks.rawValue: lesson.weeksOnly = self.semseterWeeks.filter{ $0 % 2 == 0 }
            case CalendarWeekRotation.unevenWeeks.rawValue: lesson.weeksOnly = self.semseterWeeks.filter{ $0 % 2 == 1 }
            case CalendarWeekRotation.once.rawValue: lesson.weeksOnly = []
            default: lesson.weeksOnly = []
            }
        case .day:
            lesson.day = newValue
        default:break
        }
        
        lessonDetailsTable.reloadData()
    }
    
    func changeValue(_ newValue: LessonType?) {
        self.lesson.type = newValue
    }
    
    func changeValue(forElement: LessonDetailElements, _ date: Date) {
        
        switch forElement {
        case .day:
            lesson.weeksOnly = [Calendar.current.component(.weekOfYear, from: date)]
            lesson.day = Calendar.current.component(.weekday, from: date) - 1
        case .startTime:
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm:00"
            lesson.beginTime = timeFormatter.string(from: date)
        case .endTime:
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm:00"
            lesson.endTime = timeFormatter.string(from: date)
        default: break
        }
    }
}

enum LessonDetailElements {
    case lessonName
    case abbrevation
    case professor
    case lessonType
    case room
    case weekrotation
    case day
    case startTime
    case endTime
    
    var iconImage: UIImage? {
        
        switch self {
        case .lessonName: return UIImage(named: "Icon_LessonName")
        case .abbrevation: return UIImage(named: "Icon_Abbrevetion")
        case .professor: return UIImage(named: "Icons_Doctor")
        case .lessonType: return UIImage(named: "Icon_Lecture")
        case .room: return UIImage(named: "Icon_Room")
        case .weekrotation: return UIImage(named: "Icon_Calendar")
        case .day: return UIImage(named: "Icon_TodayList")
        case .startTime: return UIImage(named: "Icon_LessonBoard")
        case .endTime: return UIImage(named: "Icon_LessonBoard")
        }
    }
    
    var placeholder: String {
        
        switch self {
        
        case .lessonName: return R.string.localizable.lessonName()
        case .abbrevation: return R.string.localizable.abbreviation()
        case .professor: return R.string.localizable.docentName()
        case .lessonType: return R.string.localizable.lessonType()
        case .room: return R.string.localizable.room()
        case .weekrotation: return R.string.localizable.weekRotation()
        case .day: return R.string.localizable.weekday()
        case .startTime: return R.string.localizable.startTime()
        case .endTime: return R.string.localizable.endTime()
        }
    }
    
    var selectionOption: LessonDetailsOptions? {
        
        switch self {
        case .lessonType: return .lectureType(selection: .none)
        case .weekrotation: return .weekRotation(selection: .none)
        case .day: return .weekDay(selection: .none)
        default: return .none
        }
    }
}
