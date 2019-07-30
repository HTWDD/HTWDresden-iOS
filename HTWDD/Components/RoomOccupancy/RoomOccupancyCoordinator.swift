//
//  RoomOccupancyCoordinator.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 25.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation

class RoomOccupancyCoordinator: Coordinator {
    // MARK: - Typealias
    typealias Services = HasApiService & HasRoomOccupancy
    
    // MARK: - Properties
    let context: Services
    var rootViewController: UIViewController { return self.viewController }
    var childCoordinators: [Coordinator] = []
    private lazy var viewController: RoomOccupancyViewController = {
        return R.storyboard.roomOccupancy.roomOccupancyViewController()!.also {
            $0.context = context
            $0.roomOccupancyCoordinator = self
        }
    }()
    
    // MARK: - LifeCycle
    init(context: Services) {
        self.context = context
    }
    
    // MARK: - Detail ViewController
    func getDetailRoomOccupancyViewController(with roomName: String) -> RoomOccupancyDetailViewController {
        return R.storyboard.roomOccupancy.roomOccupancyDetailViewController()!.also {
            $0.context  = context
            $0.roomName = roomName
        }
    }
}
