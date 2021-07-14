//
//  TimetableWeekViewController.swift
//  HTWDD
//
//  Created by Chris Herlemann on 04.12.20.
//  Copyright © 2020 HTW Dresden. All rights reserved.
//

import JZCalendarWeekView
import Action
import RxSwift

class TimetableWeekViewController: TimetableBaseViewController {
    
    @IBOutlet weak var weekControllsBackgroundView: UIView!
    @IBOutlet weak var timetableWeekView: TimetableWeekView!
    @IBOutlet weak var currentWeekBtn: UIButton!
    @IBOutlet weak var nextWeekBtn: UIButton!
    
    lazy var action: Action<Void, [LessonEvent]> = Action { [weak self] (_) -> Observable<[LessonEvent]> in
        guard let self = self else { return Observable.empty() }
        return self.viewModel.load().observeOn(MainScheduler.instance)
    }
    
    var events: [LessonEvent] = [] {
        didSet {
            reloadData()
        }
    }
    
    override func setup() {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timetableWeekView.setupCalendar(numOfDays: 5,
                                        setDate: Date().dateOfWeek(for: .beginn),
                                        allEvents: JZWeekViewHelper.getIntraEventsByDate(originalEvents: events),
                                        scrollType: .pageScroll,
                                        firstDayOfWeek: .Monday,
                                        visibleTime:Calendar.current.date(bySettingHour: 7, minute: 15, second: 0, of: Date())!)
        
        weekControllsBackgroundView.backgroundColor = isDarkMode ? .black : UIColor.htw.blue
        
        currentWeekBtn.setTitle(R.string.localizable.currentWeek(), for: .normal)
        nextWeekBtn.setTitle(R.string.localizable.nextWeek(), for: .normal)
        timetableWeekView.collectionView.delegate = self
        timetableWeekView.delegate = self
        
        action.elements.subscribe(onNext: { [weak self] items in
            guard let self = self else { return }
            self.events = items
            self.stateView.isHidden = true
            
        }).disposed(by: rx_disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        load()
    }
    
    private func load() {
        
        action.execute()
    }
    
    override func reloadData(){
        
        timetableWeekView.forceReload(reloadEvents: JZWeekViewHelper.getIntraEventsByDate(originalEvents: events))
    }
    
    override func scrollToToday(notAnimated: Bool = true) {
        
        guard let today = Calendar.current.date(bySettingHour: 7, minute: 15, second: 0, of: Date().dateOfWeek(for: .beginn))
        else { return }
        
        timetableWeekView.scrollWeekView(to: today)
        timetableWeekView.updateWeekView(to: today)
    }
    
    override func getAllLessons() -> [Lesson]? {
        return events.map { event in
            event.lesson
        }
    }
    
    override func getSemesterWeeks() -> [Int] {
        var semesterWeeks: [Int] = []
        
        events.forEach {event in
            semesterWeeks.append(Calendar.current.component(.weekOfYear, from: event.startDate))
        }
        
        semesterWeeks.removeDuplicates()
        semesterWeeks.sort()
        return semesterWeeks
    }
    
    @IBAction func setCurrentWeek(_ sender: Any) {
        scrollToToday(notAnimated: false)
    }
    
    @IBAction func setNextWeek(_ sender: Any) {
        var nextWeek = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date().dateOfWeek(for: .beginn))
        nextWeek = Calendar.current.date(bySettingHour: 7, minute: 15, second: 0, of: nextWeek!)
        
        timetableWeekView.scrollWeekView(to: nextWeek!)
        timetableWeekView.updateWeekView(to: nextWeek!)
    }
}

extension TimetableWeekViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let event = timetableWeekView.getCurrentEvent(with: indexPath) as? LessonEvent else { return }
        
        let detailsLessonViewController = R.storyboard.timetable.timetableLessonDetailsViewController()!.also {
            $0.context      = context
            $0.semseterWeeks = getSemesterWeeks()
        }
        
        detailsLessonViewController.setup(model: event.lesson)
        self.navigationController?.pushViewController(detailsLessonViewController, animated: true)
    }
}

extension TimetableWeekViewController: TimetableWeekViewDelegate {
    
    func export(_ lessonEvent: LessonEvent) {
        
        let exportMenu = UIAlertController(title: R.string.localizable.exportTitle(), message: R.string.localizable.exportMessage(), preferredStyle: .actionSheet)
        
        let singleExportAction = UIAlertAction(title: R.string.localizable.exportSingleLesson(), style: .default, handler: { _ in
            
            let exportSingleLesson = Lesson(id: lessonEvent.lesson.id,
                                            lessonTag: lessonEvent.lesson.lessonTag,
                                            name: lessonEvent.lesson.name,
                                            type: lessonEvent.lesson.type,
                                            day: lessonEvent.lesson.day,
                                            beginTime: lessonEvent.lesson.beginTime,
                                            endTime: lessonEvent.lesson.endTime,
                                            week: lessonEvent.lesson.week,
                                            weeksOnly: [Calendar.current.component(.weekOfYear, from: lessonEvent.startDate)],
                                            professor: lessonEvent.lesson.professor,
                                            rooms: lessonEvent.lesson.rooms,
                                            lastChanged: lessonEvent.lesson.lastChanged)
            
            self.viewModel.export(lessons: [exportSingleLesson])
            self.showSuccessMessage()
        })
        
        let fullExportAction = UIAlertAction(title: R.string.localizable.exportAll(), style: .default, handler: { _ in
            
            self.viewModel.export(lessons: [lessonEvent.lesson])
            self.showSuccessMessage()
        })
        
        let cancelAction = UIAlertAction(title: R.string.localizable.cancel(), style: .cancel)
        
        exportMenu.addAction(singleExportAction)
        exportMenu.addAction(fullExportAction)
        exportMenu.addAction(cancelAction)
        
        self.present(exportMenu, animated: true, completion: nil)
    }
}
