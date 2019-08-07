//
//  RestApi.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 30.06.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import Moya

// MARK: - Endpoints
enum HTWRestApi {
    case timeTable(year: String, major: String, group: String)
    case semesterPlaning
    case rooms(room: String)
    case studyGroups
    case courses(auth: String)
}

// MARK: - Endpoint Handling
extension HTWRestApi: TargetType {
    var baseURL: URL {
        switch self {
        case .courses:
            return URL(string: "https://wwwqis.htw-dresden.de/appservice/v2")!
        default:
            return URL(string: "http://rubu2.rz.htw-dresden.de/API/v0")!
        }
    }
    
    var path: String {
        switch self {
        case .timeTable: return "/studentTimetable.php"
        case .semesterPlaning: return "/semesterplan.json"
        case .rooms: return "/roomTimetable.php"
        case .studyGroups: return "/studyGroups.php"
        case .courses: return "/getcourses"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .timeTable(let year, let major, let group):
            return .requestParameters(parameters: [ "Stg": "\(major.urlEscaped)", "StgGrp": "\(group.urlEscaped)", "StgJhr": "\(year.urlEscaped)" ], encoding: URLEncoding.default)
        case .rooms(let room):
            return .requestParameters(parameters: ["room": room], encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .courses(let auth):
            return ["Content-Type": "application/json", "Authorization": "Basic \(auth)"]
        default:
            return ["Content-Type": "application/json"]
        }
    }
    
}
