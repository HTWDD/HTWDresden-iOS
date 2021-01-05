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
    
    override func setup() {

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timetableWeekView.setupCalendar(numOfDays: 5,
                                        setDate: Date().dateOfWeek(for: .beginn),
                                        allEvents: JZWeekViewHelper.getIntraEventsByDate(originalEvents: events),
                                        scrollType: .pageScroll,
                                       firstDayOfWeek: .Monday,
                                       visibleTime:Calendar.current.date(bySettingHour: 7, minute: 15, second: 0, of: Date())!)
        
        weekControllsBackgroundView.backgroundColor = UIColor.htw.blue
        
        currentWeekBtn.setTitle(R.string.localizable.currentWeek(), for: .normal)
        nextWeekBtn.setTitle(R.string.localizable.nextWeek(), for: .normal)
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
        
        guard let today = Calendar.current.date(bySettingHour: 7, minute: 15, second: 0, of: Date().dateOfWeek(for: .beginn))
        else { return }
        
        timetableWeekView.scrollWeekView(to: today)
        timetableWeekView.updateWeekView(to: today)
        
        
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
