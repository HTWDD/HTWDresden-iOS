//
//  RoomOccupancyService.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 25.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

class RoomOccupancyService: Service {
    
    // MARK: - Properties
    private var apiService: ApiService
    
    // MARK: - Lifecycle
    init(apiService: ApiService) {
        self.apiService = apiService
    }
    
    func load(parameters: ()) -> Observable<()> {
        return Observable.empty()
    }
    
    func loadRooms(room: String) -> Single<[Lesson]> {
        return apiService.requestRoom(room: room)
    }
}
