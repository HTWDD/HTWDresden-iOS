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
}

// MARK: - Endpoint Handling
extension HTWRestApi: TargetType {
    var baseURL: URL {
        return URL(string: "http://rubu2.rz.htw-dresden.de/API/v0")!
    }
    
    var path: String {
        switch self {
        case .timeTable: return "/studentTimetable.php"
        case .semesterPlaning: return "/semesterplan.json"
        case .rooms: return "/roomTimetable.php"
        case .studyGroups: return "/studyGroups.php"
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
            return .requestParameters(parameters: [ "room": room], encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
}
