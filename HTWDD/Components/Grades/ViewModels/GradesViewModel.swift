//
//  GradesViewModel.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 27.09.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

enum Grades {
    case average(model: GradeAverage)
    case header(model: GradeHeader)
    case grade(model: Grade)
    case legalInfo
}

class GradesViewModel {
    
    // MARK: - Properties
    private let context: HasGrade
    
    // MARK: - Lifecycle
    init(context: HasGrade) {
        self.context = context
    }
    
    // MARK: - Load
    func load() -> Observable<[Grades]> {
        return requestCourses()
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .flatMap { (courses: [Course]) -> Observable<[[Grade]]> in
                let requests: [Observable<[Grade]>] = courses.map { [unowned self] (course: Course) in
                    self.requestGrades(for: course).catchErrorJustReturn([Grade]())
                }
                return Observable.combineLatest(requests)
            }
            .map { (grades: [[Grade]]) -> [Grade] in
                return grades.reduce([], +)
            }
            .map { (grades: [Grade]) -> Dictionary<Int, [Grade]> in
                return Dictionary(grouping: grades) { $0.semester }
            }
            .map { [unowned self] (hMap: Dictionary<Int, [Grade]>) -> [Grades] in
                var result: [Grades] = []
                
                if (!hMap.isEmpty) {
                    //
                    let totalValues = Array(hMap.values).reduce([], +)
                    let totalCredits = totalValues.filter { $0.credits > 0.0 }.map { $0.credits }.reduce(0.0, +)
                    let totalGrades = totalValues.filter { $0.credits > 0.0 && $0.grade != nil }.map { $0.credits * (Double($0.grade ?? 0) / 100.0) }.reduce(0.0, +)
                    
                    result.append(.average(model: GradeAverage(average: totalGrades > 0 ? totalGrades / totalCredits : 0.0, credits: totalCredits)))
                    
                    for (key, values) in Array(hMap).sorted (by: { (lhs, rhs) in lhs.key > rhs.key }) {
                        // Credits calc
                        let credits = values.filter { $0.credits > 0.0 }.map { $0.credits }.reduce(0.0, +)
                        let grades  = values.filter { $0.credits > 0.0 && $0.grade != nil }.map { $0.credits * (Double($0.grade ?? 0) / 100.0) }.reduce(0.0, +)
                        
                        // Header
                        result.append(.header(model: GradeHeader(header: self.decodeSemester(from: key), subheader: R.string.localizable.gradesHeaderSubtitle(grades / credits, Int(credits)))))
                        
                        // Grade
                        var mutableValues = values
                        mutableValues.sort()
                        mutableValues.forEach { value in
                            result.append(.grade(model: value))
                        }
                    }
                }
                return result
            }
    }
    
    // MARK: - Requests
    private func requestCourses() -> Observable<[Course]> {
        return context
            .gradeService
            .requestCourses(auth: KeychainService.shared[.authToken])
    }
    
    private func requestGrades(for course: Course) -> Observable<[Grade]> {
        return context
            .gradeService
            .requestGrades(auth: KeychainService.shared[.authToken], course: course)
    }
    
    private func decodeSemester(from key: Int) -> String {
        let s = "\(key)"
        if s.count < 5 {
            return s
        }
        
        if s.hasSuffix("1") {
            return "\(R.string.localizable.summerSemester()) \(s[..<(s.index(s.startIndex, offsetBy: s.count - 1))])"
        }
        
        if s.hasSuffix("2") {
            return "\(R.string.localizable.winterSemester()) \(s[..<(s.index(s.startIndex, offsetBy: s.count - 1))])"
        }
        
        return s
    }
    
}
