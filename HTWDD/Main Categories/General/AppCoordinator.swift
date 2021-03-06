//
//  AppCoordinator.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 13.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift
import SideMenu

class AppCoordinator: Coordinator {
	private var window: UIWindow
	private let tabBarController = TabBarController()

    var rootViewController: UIViewController {
        return self.tabBarController
//        return self.rootNavigationController
	}
    
    lazy var childCoordinators: [Coordinator] = [
        self.schedule,
        self.exams,
        self.grades,
        self.canteen,
        self.settings,
        self.management,
        self.campusPlan
    ]
    
    private let navigationController: UINavigationController = UIStoryboard(name: "SideMenu", bundle: nil).instantiateViewController(withIdentifier: "MainNavigation") as! SideMenuContainerNavigationController
    var rootNavigationController: SideMenuContainerNavigationController {
        return self.navigationController as! SideMenuContainerNavigationController
    }

    let appContext = AppContext()
    private let persistenceService = PersistenceService()

    private lazy var dashboard      = DashboardCoordinator(context: appContext)
    private lazy var timetable      = TimetableCoordinator(context: appContext)
    private lazy var schedule       = ScheduleCoordinator(context: appContext)
    private lazy var roomOccupancy  = RoomOccupancyCoordinator(context: appContext)
	private lazy var exams          = ExamsCoordinator(context: appContext)
	private lazy var grades         = GradeCoordinator(context: appContext)
    private lazy var canteen        = CanteenCoordinator(context: appContext)
    private lazy var settings       = SettingsCoordinator(context: appContext, delegate: self)
    private lazy var management     = ManagementCoordinator(context: appContext)
    private lazy var campusPlan     = CampusPlanCoordinator(context: appContext)

    private let disposeBag = DisposeBag()
    
	// MARK: - Lifecycle
	init(window: UIWindow) {
		self.window                     = window
        self.rootNavigationController.coordinator = self
        self.window.rootViewController  = self.rootNavigationController
        self.window.tintColor           = UIColor.htw.blue
        self.window.makeKeyAndVisible()
        
        if #available(iOS 13.0, *) {
            let app = UINavigationBarAppearance()
            app.backgroundColor = .blue
            self.rootNavigationController.navigationController?.navigationBar.scrollEdgeAppearance = app
        }
		
        goTo(controller: .dashboard)
        
        if UserDefaults.standard.needsOnboarding {
            self.showOnboarding(animated: false)
        }
	}

    private func injectAuthentication(schedule: ScheduleService.Auth?, grade: GradeService.Auth?) {
        self.schedule.auth          = schedule
    }

	private func showOnboarding(animated: Bool) {
        rootNavigationController.present(OnboardingCoordinator(context: appContext).start(), animated: animated, completion: nil)
	}

    private func loadPersistedAuth(completion: @escaping (ScheduleService.Auth?, GradeService.Auth?) -> Void) {
        self.persistenceService.load()
            .take(1)
            .subscribe(onNext: { res in
                completion(res.schedule, res.grades)
            }, onError: { _ in
                completion(nil, nil)
            })
            .disposed(by: self.disposeBag)
    }
}

// MARK: - Routing
extension AppCoordinator {
    func selectChild(`for` url: URL) {
        guard let route = url.host?.removingPercentEncoding else { return }
        self.selectChild(coordinator: CoordinatorRoute(rawValue: route))
    }
    
    func selectChild(coordinator: CoordinatorRoute?) {
        guard let coordinator = coordinator else { return }
        
        switch coordinator {
        case .schedule:
            // Dismiss any ViewController presented on tabBarController
            if let presented = self.tabBarController.presentedViewController {
                presented.dismiss(animated: false)
            }
            self.tabBarController.selectedIndex = 0
        case .scheduleToday:
            // Dismiss any ViewController presented on tabBarController
            if let presented = self.tabBarController.presentedViewController {
                presented.dismiss(animated: false)
            }
            
            self.schedule.jumpToToday(animated: false)
            
            self.tabBarController.selectedIndex = 0
        default:
            break
        }
    }
}

// MARK: - Data handling

extension AppCoordinator: SettingsCoordinatorDelegate {
    
    func deleteAllData() {
        ExamRealm.clear()
        RoomRealm.clear()
        UserDefaults.standard.apply {
            $0.needsOnboarding  = true
            $0.analytics        = false
            $0.crashlytics      = false
        }
        self.persistenceService.clear()
        self.schedule.auth = nil
        KeychainService.shared.removeAllKeys()
        goTo(controller: .dashboard)
        self.showOnboarding(animated: true)
    }
}

// MARK: - Controller routing
extension AppCoordinator {

    /// # Routing to UIViewController
    func goTo(controller: CoordinatorRoute, animated: Bool = false) {
        let viewController: UIViewController
        
        switch controller {
        case .dashboard:
            viewController = (dashboard.rootViewController as! DashboardViewController).also {
                $0.appCoordinator = self
            }
        case .schedule,
             .scheduleToday:
            viewController = timetable.start()
        case .roomOccupancy:
            viewController = (roomOccupancy.rootViewController as! RoomOccupancyViewController).also {
                $0.appCoordinator = self
            }
        case .roomOccupancyDetail(let room):
            viewController = roomOccupancy.getDetailRoomOccupancyViewController(with: room)
        case .exams:
            viewController = exams.start()
        case .grades:
            viewController = grades.rootViewController
        case .canteen:
            viewController = (canteen.rootViewController as! CanteenViewController).also {
                $0.appCoordinator = self
            }
        case .meal(let canteenDetail):
            viewController = canteen.getMealsTabViewController(for: canteenDetail)
        case .settings:
            viewController = settings.start()
        case .management:
            viewController = management.rootViewController
        case .campusPlan:
            viewController = campusPlan.rootViewController
        }
        
        if rootNavigationController.viewControllers.contains(viewController) {
            rootNavigationController.popToViewController(viewController, animated: animated)
        } else {
            rootNavigationController.pushViewController(viewController, animated: animated)
        }
    }
}
