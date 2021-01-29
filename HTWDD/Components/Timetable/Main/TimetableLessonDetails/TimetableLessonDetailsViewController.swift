//
//  TimetableLessonDetailsViewController.swift
//  HTWDD
//
//  Created by Chris Herlemann on 18.12.20.
//  Copyright © 2020 HTW Dresden. All rights reserved.
//

import RxSwift
import UIKit

protocol TimetableLessonDetailsCellDelegate: class {
    
    func changeValue(forElement: LessonDetailElements,_ newValue: String?)
    func changeValue(forElement: LessonDetailElements,_ newValue: Int?)
    func changeValue(forElement: LessonDetailElements, _ date: Date)
    func changeValue(_ newValue: LessonType?)
}

class TimetableLessonDetailsViewController: UIViewController {
    
    var viewModel: TimetableViewModel!
    var context: AppContext!
    var lesson: CustomLesson = CustomLesson()
    var semseterWeeks: [Int]!
    
    private var elements = [[LessonDetailElements]]() {
        didSet {
            lessonDetailsTable.reloadData()
        }
    }
    
    private var isLessonCustomizable: Bool {
        guard let id = lesson.id else { return true }
        
        return viewModel.isCustomLesson(id: id)
    }
    
    @IBOutlet weak var lessonDetailsTable: UITableView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    
    override func viewDidLoad() {
        
        self.title = isLessonCustomizable ? R.string.localizable.editLesson() : R.string.localizable.lesson()
        
        lessonDetailsTable.dataSource = self
        lessonDetailsTable.delegate = self
        lessonDetailsTable.sectionHeaderHeight = 50
        lessonDetailsTable.keyboardDismissMode = .onDrag
        
        
        lessonDetailsTable.register(TimetableLessonDetailCell.self)
        lessonDetailsTable.register(TimetableLessonDetailsSelectionCell.self)
        lessonDetailsTable.register(TimetableLessonDetailTimePickerCell.self)
        lessonDetailsTable.register(SectionHeader.self, forHeaderFooterViewReuseIdentifier: "sectionSpacer")
        lessonDetailsTable.register(RequiredFooter.self, forHeaderFooterViewReuseIdentifier: "requiredFooter")
        lessonDetailsTable.backgroundColor = UIColor.htw.veryLightGrey
        
        self.view.backgroundColor = UIColor .htw.veryLightGrey
        styleButtons()
        
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
        
        saveBtn.isHidden = !isLessonCustomizable
        
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
    }
    
    private func styleButtons(){
        closeBtn.setTitle(R.string.localizable.close(), for: .normal)
        closeBtn.layer.cornerRadius = 4
        closeBtn.backgroundColor = UIColor.htw.grey400
        closeBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        saveBtn.setTitle(R.string.localizable.save(), for: .normal)
        saveBtn.layer.cornerRadius = 4
        saveBtn.backgroundColor = UIColor.htw.blue
        saveBtn.addTarget(self, action: #selector(save), for: .touchUpInside)
    }
    
    @objc
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
}

extension TimetableLessonDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionHeader: SectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionSpacer") as! SectionHeader
        sectionHeader.title.text = (section == 0 ? R.string.localizable.general() : R.string.localizable.time())
        
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard section == 1 else { return .none }
        
        let requiredFooter: RequiredFooter = tableView.dequeueReusableHeaderFooterView(withIdentifier: "requiredFooter") as! RequiredFooter
        requiredFooter.title.text = R.string.localizable.fieldRequiered()
        
        return requiredFooter
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
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

class HTWTextField: UITextField {
    
    override func draw(_ rect: CGRect) {
        
        let border = CALayer()
        
        border.backgroundColor = UIColor.htw.lightGrey.cgColor
        border.frame = CGRect(x: 0, y: frame.size.height * 1.2, width: frame.width, height: 1)
        
        layer.addSublayer(border)
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


class SectionHeader: UITableViewHeaderFooterView {
    
    
    let title = UILabel()
    let background = UIView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    func configureContents() {
        
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle == .light {
                contentView.backgroundColor = UIColor.htw.veryLightGrey
            }
        } else {
            contentView.backgroundColor = UIColor.htw.veryLightGrey
        }
        
        background.backgroundColor = UIColor.htw.cellBackground
        
        background.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(background)
        contentView.addSubview(title)
        
        NSLayoutConstraint.activate([
            background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 19),
            background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -19),
            background.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            title.heightAnchor.constraint(equalToConstant: 30),
            title.leadingAnchor.constraint(equalTo: background.leadingAnchor,
                                           constant: 16),
            title.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -14),
            title.centerYAnchor.constraint(equalTo: background.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RequiredFooter: UITableViewHeaderFooterView {
    
    let title = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    func configureContents() {
        
        contentView.backgroundColor = UIColor.htw.veryLightGrey
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 14)
        
        contentView.addSubview(title)
        
        NSLayoutConstraint.activate([
            
            title.heightAnchor.constraint(equalToConstant: 30),
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
