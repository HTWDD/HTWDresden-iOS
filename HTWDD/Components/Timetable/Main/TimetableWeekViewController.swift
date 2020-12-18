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
    
    
    lazy var action: Action<Void, [LessonEvent]> = Action { [weak self] (_) -> Observable<[LessonEvent]> in
        guard let self = self else { return Observable.empty() }
        return self.viewModel.load().observeOn(MainScheduler.instance)
    }
    
    // TEMPORÄR - BITTE LÖSCHEN
    
    private let firstDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
    private let secondDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    private let thirdDate = Calendar.current.date(byAdding: .day, value: 2, to: Date())!

    lazy var events: [LessonEvent] = []
    
    override func setup() {
//        super.setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let test: Observable<[LessonEvent]> = viewModel.load()
        
        timetableWeekView.setupCalendar(numOfDays: 5,
                                        setDate: Calendar.current.date(bySettingHour: 8, minute: 45, second: 0, of: Date().dateOfWeek(for: .beginn))!, //Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
                                       allEvents: JZWeekViewHelper.getIntraEventsByDate(originalEvents: events),
                                       scrollType: .pageScroll,
                                       firstDayOfWeek: .Monday,
                                       visibleTime:Calendar.current.date(bySettingHour: 7, minute: 45, second: 0, of: Date().dateOfWeek(for: .beginn))!)
        
        weekControllsBackgroundView.backgroundColor = UIColor.htw.blue
    }
    
    override func reloadData(){
    
    }
    
    override func scrollToToday(notAnimated: Bool = true) {
        
        guard let today = Calendar.current.date(bySettingHour: 7, minute: 45, second: 0, of: Date().dateOfWeek(for: .beginn))
        else { return }
        
        timetableWeekView.scrollWeekView(to: today)
        timetableWeekView.updateWeekView(to: today)
        
        
    }
}

extension JZBaseWeekView {
    
    
}
