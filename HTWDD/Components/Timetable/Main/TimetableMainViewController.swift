//
//  TimetableMainViewController.swift
//  HTWDD
//
//  Created by Chris Herlemann on 09.12.20.
//  Copyright © 2020 HTW Dresden. All rights reserved.
//

import UIKit
import EventKitUI
import Action
import RxSwift

private enum TimetableLayoutStyle: Int {
    case list = 0, week = 1
    
    var title: String {
        switch self {
        case .week:
            return   R.string.localizable.scheduleStyleWeek()
        case .list:
            return   R.string.localizable.scheduleStyleList()
        }
    }
    
    static let all = [TimetableLayoutStyle.list, .week]
    static let cachingKey = "\(TimetableLayoutStyle.self)_cache"
    
    mutating func toggle() {
        switch self {
        case .week:
            self = .list
        case .list:
            self = .week
        }
    }
}

final class TimetableMainViewController: ViewController, HasSideBarItem {
    
    private var currentTimetableViewController: TimetableBaseViewController? {
        didSet {
            updateNavButtons()
        }
    }
    
    private var containerView = View()
    var viewModel: TimetableViewModel
    var context: AppContext
    lazy var eventStore = EKEventStore()
    
    private var cachedStyles = [TimetableLayoutStyle: TimetableBaseViewController]()
    private var currentStyle: TimetableLayoutStyle? {
        didSet {
            self.switchStyle(to: currentStyle)
        }
    }
    
    init(context: AppContext) {
        self.context = context
        self.viewModel = TimetableViewModel(context: context)
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        let style = UserDefaults.standard.integer(forKey: TimetableLayoutStyle.cachingKey)
        self.currentStyle = TimetableLayoutStyle(rawValue: style) ?? .list
    }
    
    func setup() {
        title = R.string.localizable.scheduleTitle()
        
        self.view.add(self.containerView)
        self.view.layoutMatchingEdges(self.containerView)
    }
    
    func updateNavButtons() {
        
        switch currentStyle {
        case .list:
            let scrollToTodayBtn = UIBarButtonItem(title: R.string.localizable.canteenToday(), style: .plain, target: self, action: #selector(scrollToToday))
            let addBtn = UIBarButtonItem.menuButton(self, action: #selector(addLesson), imageName: "Icon_Plus")
            let listWeekBtn = UIBarButtonItem.menuButton(self, action: #selector(toggleLayout), imageName: "Icon_Calendar")
            
            navigationItem.rightBarButtonItems = [scrollToTodayBtn, listWeekBtn, addBtn]
        case .week:
            let exportBtn = UIBarButtonItem.menuButton(self, action: #selector(exportAll), imageName: "Icon_Export")
            let listWeekBtn = UIBarButtonItem.menuButton(self, action: #selector(toggleLayout), imageName: "Icons_List")
            let addBtn = UIBarButtonItem.menuButton(self, action: #selector(addLesson), imageName: "Icon_Plus")
            
            navigationItem.rightBarButtonItems = [exportBtn, listWeekBtn, addBtn]
        default:
            let scrollToTodayBtn = UIBarButtonItem(title: R.string.localizable.canteenToday(), style: .plain, target: self, action: #selector(scrollToToday))
            navigationItem.rightBarButtonItems = [scrollToTodayBtn]
        }
    }
    
    @objc func scrollToToday(notAnimated: Bool = true) {
        currentTimetableViewController?.scrollToToday()
    }
    
    @objc func toggleLayout() {
        self.currentStyle?.toggle()
    }
    
    @objc func addLesson(_ sender: UIButton) {
        let addLessonMenu = UIAlertController(title: "Veranstaltung hinzufügen", message: nil, preferredStyle: .actionSheet)
        
        let addElectiveLessonAction = UIAlertAction(title: "Wahlpflichtfach", style: .default, handler: { _ in
            self.addElectiveLesson()
        })
        
        let addCustomLessonAction = UIAlertAction(title: "Eigene Veranstaltung", style: .default, handler: { _ in
            self.createLesson()
        })
        
        let cancelAction = UIAlertAction(title: R.string.localizable.cancel(), style: .cancel)
        
        addLessonMenu.addAction(addElectiveLessonAction)
        addLessonMenu.addAction(addCustomLessonAction)
        addLessonMenu.addAction(cancelAction)
        
        if let popoverController = addLessonMenu.popoverPresentationController {
            popoverController.sourceView = sender.imageView
            popoverController.sourceRect = CGRect(x: sender.imageView?.bounds.midX ?? 0, y: sender.imageView?.bounds.midY ?? 0, width: 0, height: 0)
        }
        
        self.present(addLessonMenu, animated: true, completion: nil)
    }
    
    private func addElectiveLesson() {
        
        let electiveLessonViewController = R.storyboard.timetable.timetableElectiveLessonSelectionViewController()!.also {
            $0.viewModel      = TimetableElectiveLessonSelectionViewModel(context: context) 
        }
        
        self.navigationController?.pushViewController(electiveLessonViewController, animated: true)
    }
    
    private func createLesson() {
        
        let createLessonViewController = R.storyboard.timetable.timetableLessonDetailsViewController()!.also {
            $0.context      = context
            $0.semseterWeeks = currentTimetableViewController?.getSemesterWeeks()
        }
        
        self.navigationController?.pushViewController(createLessonViewController, animated: true)
    }
    
    @objc func exportAll() {
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            
            guard (granted) && (error == nil) else {
                return
            }
            
            DispatchQueue.main.async {
                self.showExportDialog()
            }
        }
    }
    
    fileprivate func showExportDialog() {
        
        let exportMenu = UIAlertController(title: R.string.localizable.exportTitle(), message: R.string.localizable.exportMessage(), preferredStyle: .actionSheet)
        
        let currentWeekExportAction = UIAlertAction(title: R.string.localizable.exportCurrentWeek(), style: .default, handler: { _ in
            
            self.viewModel.export(lessons: self.prepareLessonsForExport(calendarWeek: Date().weekNumber))
            self.currentTimetableViewController?.showSuccessMessage()
        })
        
        let nextWeekExportAction = UIAlertAction(title: R.string.localizable.exportNextWeek(), style: .default, handler: { _ in
            
            self.viewModel.export(lessons: self.prepareLessonsForExport(calendarWeek: Date().weekNumber + 1))
            self.currentTimetableViewController?.showSuccessMessage()
        })
        
        let fullExportAction = UIAlertAction(title: R.string.localizable.exportAll(), style: .default, handler: { _ in
            
            self.viewModel.export(lessons: self.currentTimetableViewController?.getAllLessons())
            self.currentTimetableViewController?.showSuccessMessage()
        })
        
        let cancelAction = UIAlertAction(title: R.string.localizable.cancel(), style: .cancel)
        
        exportMenu.addAction(currentWeekExportAction)
        exportMenu.addAction(nextWeekExportAction)
        exportMenu.addAction(fullExportAction)
        exportMenu.addAction(cancelAction)
        
        self.present(exportMenu, animated: true, completion: nil)
    }
    
    private func prepareLessonsForExport(calendarWeek: Int) -> [Lesson] {
        guard let allLessons = self.currentTimetableViewController?.getAllLessons() else { return [] }
        
        var preparedLessons = allLessons.filter { $0.weeksOnly.contains(calendarWeek) }
        preparedLessons.removeDuplicates()
        
        for (index, _) in preparedLessons.enumerated() {
            preparedLessons[index].weeksOnly = [calendarWeek]
        }
        
        return preparedLessons
    }
    
    private func switchStyle(to style: TimetableLayoutStyle?) {
        guard let style = style else { return }
        UserDefaults.standard.set(style.rawValue, forKey: TimetableLayoutStyle.cachingKey)
        
        if let vc = self.currentTimetableViewController {
            vc.willMove(toParent: nil)
            vc.view.removeFromSuperview()
            vc.removeFromParent()
        }
        
        if let cached = self.cachedStyles[style] {
            self.currentTimetableViewController = cached
        } else {
            let newController: TimetableBaseViewController
            
            switch style {
            case .week:
                newController = R.storyboard.timetable.timetableWeekViewController()!.also {
                    $0.context      = context
                    $0.viewModel    = viewModel
                }
            case .list:
                newController = R.storyboard.timetable.timetableListViewController()!.also {
                    $0.context      = context
                    $0.viewModel    = viewModel
                }
            }
            
            self.cachedStyles[style] = newController
            self.currentTimetableViewController = newController
        }
        
        self.addTimetableViewController(self.currentTimetableViewController)
        self.containerView.layoutMatchingEdges(self.currentTimetableViewController?.view)
    }
    
    private func addTimetableViewController(_ child: UIViewController?) {
        guard let child = child else { return }
        self.addChild(child)
        self.containerView.add(child.view)
        child.didMove(toParent: self)
    }
    
}

extension TimetableMainViewController: EKCalendarChooserDelegate {
    func calendarChooserDidFinish(_ calendarChooser: EKCalendarChooser) {
        print(calendarChooser.selectedCalendars)
        dismiss(animated: true, completion: nil)
    }
    
    func calendarChooserDidCancel(_ calendarChooser: EKCalendarChooser) {
        dismiss(animated: true, completion: nil)
    }
}
