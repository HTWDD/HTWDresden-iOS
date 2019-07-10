//
//  OpenMensaRestApi.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 08.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import Moya

// MARK: - Endpoints
enum OpenMensaRestApi {
    case canteens(latitude: Double, longitude: Double, distance: Int)
    case meals(canteenId: Int, forDate: String)
}

// MARK: - Endpoint Handling
extension OpenMensaRestApi: TargetType {
    var baseURL: URL {
        return URL(string: "https://openmensa.org/api/v2")!
    }
    
    var path: String {
        switch self {
        case .canteens: return "/canteens"
        case .meals(let canteenId, let forDate): return "/canteens/\(canteenId)/days/\(forDate)/meals"
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
        case .canteens(let latitude, let longitude, let distance):
            return .requestParameters(parameters: ["near[lat]": latitude, "near[lng]": longitude, "near[dist]": distance], encoding: URLEncoding.default)
        
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
