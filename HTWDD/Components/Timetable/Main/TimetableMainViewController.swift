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
            return Loca.Schedule.Style.week
        case .list:
            return Loca.Schedule.Style.list
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
        layoutMatchingEdges(self.containerView, self.view)
    }
    
    func updateNavButtons() {
        
        switch currentStyle {
        case .list:
            let scrollToTodayBtn = UIBarButtonItem(title: R.string.localizable.canteenToday(), style: .plain, target: self, action: #selector(scrollToToday))
            
            let listWeekBtn = UIBarButtonItem.menuButton(self, action: #selector(toggleLayout), imageName: "Icon_Calendar")
            let addBtn = UIBarButtonItem.menuButton(self, action: #selector(createLesson), imageName: "Icon_Plus")
            
            navigationItem.rightBarButtonItems = [scrollToTodayBtn, listWeekBtn, addBtn]
            
        case .week:
            let exportBtn = UIBarButtonItem(title: "Export", style: .plain, target: self, action: #selector(scrollToToday))
            let listWeekBtn = UIBarButtonItem.menuButton(self, action: #selector(toggleLayout), imageName: "Icon_Calendar")
            let addBtn = UIBarButtonItem.menuButton(self, action: #selector(createLesson), imageName: "Icon_Plus")
            
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
    
    @objc func createLesson() {
        
        let createLessonViewController = R.storyboard.timetable.timetableLessonDetailsViewController()!.also {
            $0.context      = context
            $0.viewModel    = viewModel
        }

        self.navigationController?.pushViewController(createLessonViewController, animated: true)
    }
    
    @objc func exportAll() {
        let allLessons = currentTimetableViewController?.getAllLessons()
        
        viewModel.export(lessons: allLessons)
    }
    
    private func showCalendarChooser() {
        let eventStore = EKEventStore()
        let calendarChooser = EKCalendarChooser(selectionStyle: .single, displayStyle: .allCalendars, entityType: .event, eventStore: eventStore)
        
        calendarChooser.showsDoneButton = true
        calendarChooser.showsCancelButton = true
        calendarChooser.delegate = self

        self.present(calendarChooser, animated: true, completion: nil)
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
        layoutMatchingEdges(self.currentTimetableViewController?.view, self.containerView)
    }

    private func addTimetableViewController(_ child: UIViewController?) {
        guard let child = child else { return }
        self.addChild(child)
        self.containerView.add(child.view)
        child.didMove(toParent: self)
//        self.updateBarButtonItems(navigationItem: child.navigationItem)
    }
    
    private let layoutMatchingEdges: (UIView?, UIView) -> Void = {
        guard let view = $0 else { return }
        view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: $1.leadingAnchor),
            view.topAnchor.constraint(equalTo: $1.htw.safeAreaLayoutGuide.topAnchor),
            view.trailingAnchor.constraint(equalTo: $1.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: $1.bottomAnchor)
        ])
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
