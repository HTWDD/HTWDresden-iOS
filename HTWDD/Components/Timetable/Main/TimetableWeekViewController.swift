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
    
    var events: [LessonEvent] = [] {
        didSet {
            reloadData()
        }
    }
    
    override func setup() {

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timetableWeekView.setupCalendar(numOfDays: 5,
                                        setDate: Calendar.current.date(bySettingHour: 8, minute: 45, second: 0, of: Date().dateOfWeek(for: .beginn))!,
                                        allEvents: JZWeekViewHelper.getIntraEventsByDate(originalEvents: events),
                                       scrollType: .pageScroll,
                                       firstDayOfWeek: .Monday,
                                       visibleTime:Calendar.current.date(bySettingHour: 7, minute: 45, second: 0, of: Date().dateOfWeek(for: .beginn))!)
        
        weekControllsBackgroundView.backgroundColor = UIColor.htw.blue
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        load()
    }
    
    private func load() {
        
        action.elements.subscribe(onNext: { [weak self] items in
            guard let self = self else { return }
            self.events = items
            self.stateView.isHidden = true
            
        }).disposed(by: rx_disposeBag)
        
        action.execute()
    }
    
    override func reloadData(){

        timetableWeekView.forceReload(reloadEvents: JZWeekViewHelper.getIntraEventsByDate(originalEvents: events))
    }
    
    override func scrollToToday(notAnimated: Bool = true) {
        
        guard let today = Calendar.current.date(bySettingHour: 7, minute: 45, second: 0, of: Date().dateOfWeek(for: .beginn))
        else { return }
        
        timetableWeekView.scrollWeekView(to: today)
        timetableWeekView.updateWeekView(to: today)
        
        
    }
}
