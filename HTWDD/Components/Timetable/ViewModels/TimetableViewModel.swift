//
//  TimetableViewModel.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 01.10.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift
import EventKit
import RealmSwift
import Combine

// MARK: - Items
enum Timetables {
    case header(model: TimetableHeader)
    case lesson(model: Lesson)
    case freeday(model: FreeDays)
}

enum FreeDays {
    case noLesson
}


// MARK: - ViewModel
class TimetableViewModel {
    
    // MARK: - Properties
    private let context: HasTimetable
    private lazy var eventStore : EKEventStore = EKEventStore()
    
    
    // MARK: - Lifecycle
    init(context: HasTimetable) {
        self.context = context
    }
    
    // MARK: - Request
    func load() -> Observable<[Timetables]> {
        context
            .timetableService.requestTimetable()
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .map {[weak self] (items: [Lesson]) -> Dictionary<[String], [Lesson]> in
                
                return Dictionary(grouping: self?.appendCustomLessons(items) ?? []) { $0.lessonDays }
            }
            .map { (hMap: Dictionary<[String], [Lesson]>) -> (keys: [String], values: [Lesson]) in
                let keys = hMap.keys
                    .reduce([], +)
                    .reduce(into: Set<String>(), { dates, date in
                        dates.insert(date)
                    })
                    .sorted { (lhs, rhs) -> Bool in
                        let lhsDate = try! Date.from(string: lhs, format: "dd.MM.yyyy")
                        let rhsDate = try! Date.from(string: rhs, format: "dd.MM.yyyy")
                        return lhsDate.compare(rhsDate) == .orderedAscending
                    }
                
                let values = hMap
                    .values
                    .reduce([], +)
                    .reduce(into: Set<Lesson>(), { lessons, lesson in
                        lessons.insert(lesson)
                    }).sorted { (lhs: Lesson, rhs: Lesson) -> Bool in
                        return lhs.beginTime < rhs.beginTime
                    }
                
                return (keys, values)
        }
        .map { [weak self] items -> [Timetables] in
            var result: [Timetables] = []
            
            items.keys.forEach { date in
                result.append(.header(model: TimetableHeader(header: date, subheader: date)))
                items.values.filter { $0.lessonDays.contains(date) }.forEach { lesson in
                    result.append(.lesson(model: lesson))
                }
            }
            
            self?.appendFreedays(&result)
            return result
        }
    }
    
    func load() -> Observable<[LessonEvent]> {
        context
            .timetableService.requestTimetable()
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .map { [weak self] (items: [Lesson]) -> Dictionary<[String], [Lesson]> in
                
                return Dictionary(grouping: self?.appendCustomLessons(items) ?? []) { $0.lessonDays }
            }
            .map { (hMap: Dictionary<[String], [Lesson]>) -> (keys: [String], values: [Lesson]) in
                let keys = hMap.keys
                    .reduce([], +)
                    .reduce(into: Set<String>(), { dates, date in
                        dates.insert(date)
                    })
                    .sorted { (lhs, rhs) -> Bool in
                        let lhsDate = try! Date.from(string: lhs, format: "dd.MM.yyyy")
                        let rhsDate = try! Date.from(string: rhs, format: "dd.MM.yyyy")
                        return lhsDate.compare(rhsDate) == .orderedAscending
                    }
                
                let values = hMap
                    .values
                    .reduce([], +)
                    .reduce(into: Set<Lesson>(), { lessons, lesson in
                        lessons.insert(lesson)
                    }).sorted { (lhs: Lesson, rhs: Lesson) -> Bool in
                        return lhs.beginTime < rhs.beginTime
                    }
                
                return (keys, values)
        }
        .map { items -> [LessonEvent] in
            var result: [LessonEvent] = []
                
                items.values.forEach { lesson in
                    lesson.lessonDays.forEach { lessonDate in
                        
                        if let startDate = Date.from(time: lesson.beginTime, date: lessonDate),
                           let endDate = Date.from(time: lesson.endTime, date: lessonDate) {
                            
                            result.append(LessonEvent(id: lesson.id, lesson: lesson, startDate: startDate, endDate: endDate))
                        }
                    }
                }
            
            return result
        }
    }
    
    private func appendFreedays(_ result: inout [Timetables]) {
        let headerItems = result.filter { item in
            switch item {
            case .header: return true
            default: return false
            }
        }
        
        
        if let first = headerItems.first {
            switch first {
            case .header(let model):
                do {
                    let currentDate = Date()
                    let currentDateStr = currentDate.string(format: "dd.MM.yyyy")
                    if try Date.from(string: model.header, format: "dd.MM.yyyy") > currentDate {
                        result.insert(.header(model: TimetableHeader(header: currentDateStr, subheader: currentDateStr)), at: 0)
                        result.insert(.freeday(model: .noLesson), at: 1)
                    }
                } catch {
                    Log.error(error)
                }
                break;
            default: break;
            }
        }
        
        if let last = headerItems.last {
            switch last {
            case .header(let model):
                do {
                    let currentDate = Date()
                    let currentDateStr = currentDate.string(format: "dd.MM.yyyy")
                    if try Date.from(string: model.header, format: "dd.MM.yyyy") < currentDate {
                        result.append(.header(model: TimetableHeader(header: currentDateStr, subheader: currentDateStr)))
                        result.append(.freeday(model: .noLesson))
                    }
                } catch {
                    Log.error(error)
                }
                break;
            default: break;
            }
        }
    }
    
    func export(lessons: [Lesson]?) {
        
        guard let lessons = lessons else { return }
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            
            guard (granted) && (error == nil) else {
                // MARK: ToDo - Auf Einstellungen verweisen wenn Berechtigung fehlt
                return
            }
            
            lessons.forEach { lesson in
                lesson.lessonDays.forEach { lessonDay in
                    
                    if let startDate = Date.from(time: lesson.beginTime, date: lessonDay),
                       let endDate = Date.from(time: lesson.endTime, date: lessonDay) {
                        
                        let event:EKEvent = EKEvent(eventStore: self.eventStore)
                        
                        event.title = lesson.name
                        event.location = lesson.rooms.joined(separator: ", ")
                        event.calendar = self.eventStore.defaultCalendarForNewEvents
                        event.startDate = startDate
                        event.endDate = endDate
                        do {
                            try self.eventStore.save(event, span: .thisEvent)
                        } catch let error as NSError {
                            print("failed to save event with error : \(error)")
                        }
                        
                    }
                }
            }
        }
    }
    
    func saveCustomLesson(_ customLesson: CustomLesson) -> Bool {
        
        guard let name = customLesson.name,
              let day = customLesson.day,
              let beginTime = customLesson.beginTime,
              let endTime = customLesson.endTime,
              let week = customLesson.week,
              let weeksOnly = customLesson.weeksOnly
              
        else { return false }
        
        let newLesson: Lesson = Lesson(id: customLesson.id ?? UUID().uuidString,
                               lessonTag: customLesson.lessonTag,
                               name: name,
                               type: customLesson.type ?? .unkown,
                               day: day,
                               beginTime: beginTime,
                               endTime: endTime,
                               week: week,
                               weeksOnly: weeksOnly,
                               professor: customLesson.professor,
                               rooms: [customLesson.rooms ?? " "],
                               lastChanged: Date().localized)
        
        if TimetableRealm.exist(id: newLesson.id) {
            TimetableRealm.update(from: newLesson)
        } else {
            TimetableRealm.save(from: newLesson)
        }
        
        return true
    }
    
    private func appendCustomLessons(_ items: [Lesson]) -> [Lesson] {
        
        var result = TimetableRealm.read()
        print("Loading custom lessons")
        print(result)
        result.append(contentsOf: items)
        return result
    }
    
    func deleteCustomLesson(lessonId: String) {
        TimetableRealm.delete(ids: [lessonId])
    }
    
    func isCustomLesson(id: String) -> Bool {
        
        return TimetableRealm.exist(id: id)
    }
}
