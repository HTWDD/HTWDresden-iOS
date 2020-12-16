//
//  TimetableWeekViewController.swift
//  HTWDD
//
//  Created by Chris Herlemann on 04.12.20.
//  Copyright © 2020 HTW Dresden. All rights reserved.
//

import JZCalendarWeekView

class TimetableWeekViewController: TimetableBaseViewController {
 
    
    @IBOutlet weak var weekControllsBackgroundView: UIView!
    @IBOutlet weak var timetableWeekView: TimetableWeekView!
    
    
    // TEMPORÄR - BITTE LÖSCHEN
    
    private let firstDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
    private let secondDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    private let thirdDate = Calendar.current.date(byAdding: .day, value: 2, to: Date())!

    lazy var events = [LessonEvent(id: "0", title: "One", startDate: firstDate, endDate: Calendar.current.date(byAdding: .hour, value: 1, to: Calendar.current.date(byAdding: .minute, value: 30, to: firstDate)!)!, location: "Melbourne"),
                       LessonEvent(id: "1", title: "Two", startDate: secondDate, endDate: Calendar.current.date(byAdding: .hour, value: 1, to: Calendar.current.date(byAdding: .minute, value: 30, to: secondDate)!)!, location: "Sydney"),
                       LessonEvent(id: "2", title: "Three", startDate: thirdDate, endDate: Calendar.current.date(byAdding: .hour, value: 1, to: Calendar.current.date(byAdding: .minute, value: 30, to: thirdDate)!)!, location: "Tasmania"),
                        LessonEvent(id: "3", title: "Four", startDate:  Calendar.current.date(bySettingHour: 7, minute: 45, second: 0, of: Date().dateOfWeek(for: .beginn))!, endDate:  Calendar.current.date(bySettingHour: 9, minute: 15, second: 0, of: Date().dateOfWeek(for: .beginn))!, location: "Vancouver")]
    
    override func setup() {
//        super.setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
