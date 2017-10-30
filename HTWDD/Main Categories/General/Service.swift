//
//  Service.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 29.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import RxSwift

/// A Service is a type that can load a result for a given authentication
protocol Service {
    associatedtype Parameter
    associatedtype Result

    func load(parameters: Parameter) -> Observable<Result>
}
