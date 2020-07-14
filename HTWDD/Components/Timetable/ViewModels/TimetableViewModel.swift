//
//  TimetableViewModel.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 01.10.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

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
    
    // MARK: - Lifecycle
    init(context: HasTimetable) {
        self.context = context
    }
    
    // MARK: - Request
    func load() -> Observable<[Timetables]> {
        context
            .timetableService.requestTimetable()
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .map { (items: [Lesson]) -> Dictionary<[String], [Lesson]> in
                return Dictionary(grouping: items) { $0.lessonDays }
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
            self?.appedFreedays(&result)
            return result
        }
    }
    
    private func appedFreedays(_ result: inout [Timetables]) {
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
}
