//
//  Parameter.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 20/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

public enum Parameter {
    case none
    case url([String: String])
    case json(Any)

    var data: Data? {
        switch self {
        case .none:
            return nil
        case .url(let dic):
            let parts: [String] = dic.map { k, v -> String in "\(k)=\(v)" }
            let together: String = parts.joined(separator: "&")
            return together.data(using: .utf8)
        case .json(let obj):
            return try? JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
        }
    }

    var contentType: String? {
        switch self {
        case .json(_): return "application/json"
        default: return nil
        }
    }
}
