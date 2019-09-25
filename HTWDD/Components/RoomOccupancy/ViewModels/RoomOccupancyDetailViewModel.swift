//
//  RoomOccupancyDetailViewModel.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 25.09.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

// MARK: - Items
enum Occupancies {
    case header(model: OccupancyHeader)
    case occupancy(model: Occupancy)
}

// MARK: - VM
class RoomOccupancyDetailViewModel {
    
    private let bag = DisposeBag()
    
    func load(id: String) -> Observable<[Occupancies]> {
        
        let realm = try! Realm()
        let occupancies = realm
            .objects(RoomRealm.self).filter(NSPredicate(format: "id = %@", id))
            .first?.occupancies.sorted(byKeyPath: "day")
        
        guard let res = occupancies else { return Observable.empty() }
        
        return Observable
            .collection(from: res)
            .map { (items: Results<OccupancyRealm> ) -> [Occupancy] in
                items.map { (item: OccupancyRealm) -> Occupancy in
                    let weeks = String(String(item.weeksOnly.dropFirst()).dropLast()).replacingOccurrences(of: " ", with: "").components(separatedBy: ",").compactMap({ Int($0) })
                    return Occupancy(
                        id: item.id,
                        name: item.name,
                        type: item.type,
                        day: item.day,
                        beginTime: item.beginTime,
                        endTime: item.endTime,
                        week: item.week,
                        professor: item.professor,
                        weeksOnly: weeks
                    )
                }
            }
            .map { (items: [Occupancy]) -> Dictionary<Int, [Occupancy]> in
                return Dictionary.init(grouping: items) { (e: Occupancy) in
                    return e.day
                }
            }
            .map { (hMap: Dictionary<Int, [Occupancy]>) -> [Occupancies] in
                var result: [Occupancies] = []
                for (k, v) in hMap.sorted(by: { (lhs, rhs) in lhs.key < rhs.key }) {
                    result.append(.header(model: OccupancyHeader(header: k, subheader: "\(v.count) \(R.string.localizable.roomOccupancyDescription())")))
                    
                    v.sorted { (lhs, rhs) in lhs.beginTime < rhs.beginTime }.forEach { occupancy in
                        result.append(.occupancy(model: occupancy))
                    }
                }
                return result
            }
            .catchErrorJustReturn([])
    }
}
