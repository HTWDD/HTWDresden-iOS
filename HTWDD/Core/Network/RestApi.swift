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
enum RestApi {
    case timeTable(year: String, major: String, group: String)
    case semesterPlaning
}

// MARK: - Endpoint Handling
extension RestApi: TargetType {
    var baseURL: URL {
        return URL(string: "https://rubu2.rz.htw-dresden.de/API/v0")!
    }
    
    var path: String {
        switch self {
        case .timeTable: return "/studentTimetable.php"
        case .semesterPlaning: return "/semesterplan.json"
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
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
}
