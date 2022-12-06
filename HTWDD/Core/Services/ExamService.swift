//
//  ExamService.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 09.08.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

class ExamService {
    
    // MARK: - Propeties
    private let apiService: ApiService
    
    // MARK: - Lifecycle
    init(apiService: ApiService) {
        self.apiService = apiService
    }
    
    func loadExams() -> Observable<[Exam]> {
        let studyToken = KeychainService.shared.readStudyToken()
        if let year = studyToken.year, let major = studyToken.major, let group = studyToken.group, let grade = studyToken.graduation {
            return apiService
                .requestExams(year: year, major: major, group: group, grade: String(grade.prefix(1)))
                .asObservable()
        } else {
            return Observable.error(NSError(domain: "HTW.StudyToken.Not.Found", code: 704, userInfo: nil))
        }
    }
    
    func requestLegalNotes() -> Observable<Notes> {
        return apiService.requestLegalNotes()
            .asObservable()
    }
}

// MARK: - Exam Serviceable
extension ExamService: HasExam {
    var examService: ExamService {
        return self
    }
}
