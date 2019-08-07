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
        self.management
    ]
    
    private let navigationController: UINavigationController = UIStoryboard(name: "SideMenu", bundle: nil).instantiateViewController(withIdentifier: "MainNavigation") as! SideMenuContainerNavigationController
    var rootNavigationController: SideMenuContainerNavigationController {
        return self.navigationController as! SideMenuContainerNavigationController
    }

    let appContext = AppContext()
    private let persistenceService = PersistenceService()

    private lazy var dashboard      = DashboardCoordinator(context: appContext)
    private lazy var schedule       = ScheduleCoordinator(context: appContext)
    private lazy var roomOccupancy  = RoomOccupancyCoordinator(context: appContext)
	private lazy var exams          = ExamsCoordinator(context: appContext)
	private lazy var grades         = GradeCoordinator(context: appContext)
    private lazy var canteen        = CanteenCoordinator(context: appContext)
    private lazy var settings       = SettingsCoordinator(context: appContext, delegate: self)
    private lazy var management     = ManagementCoordinator(context: appContext)

    private let disposeBag = DisposeBag()
    
	// MARK: - Lifecycle
	init(window: UIWindow) {
		self.window                     = window
        self.rootNavigationController.coordinator = self
        self.window.rootViewController  = self.rootNavigationController
        self.window.tintColor           = UIColor.htw.blue
        self.window.makeKeyAndVisible()
		
        goTo(controller: .dashboard)
        
        if UserDefaults.standard.needsOnboarding {
            self.showOnboarding(animated: false)
        }
	}

    private func injectAuthentication(schedule: ScheduleService.Auth?, grade: GradeService.Auth?) {
        self.schedule.auth          = schedule
        self.exams.auth             = schedule
        self.grades.auth            = grade
        self.settings.scheduleAuth  = schedule
        self.settings.gradeAuth     = grade
    }

	private func showOnboarding(animated: Bool) {

        let vc = R.storyboard.onboarding.onboardingMainViewController()!
        vc.modalPresentationStyle = .overCurrentContext
        vc.context = appContext
        rootNavigationController.present(vc, animated: animated, completion: nil)
        
        
        self.loadPersistedAuth { [weak self] schedule, grade in

            // If one of them has already been saved
            if schedule != nil || grade != nil {
                self?.injectAuthentication(schedule: schedule, grade: grade)
                return
            }

            let onboarding = OnboardingCoordinator()
            onboarding.onFinish = { [weak self, weak onboarding] res in
                self?.injectAuthentication(schedule: res.schedule, grade: res.grade)
                if let grade = res.grade { self?.persistenceService.save(grade) }
                if let schedule = res.schedule { self?.persistenceService.save(schedule) }

                guard let coordinator = onboarding else {
                    return
                }

                coordinator.rootViewController.dismiss(animated: true, completion: { [weak self] in
                    self?.removeChildCoordinator(coordinator)
                })
            }

            self?.addChildCoordinator(onboarding)
            
            
//            self?.rootViewController.present(onboarding.rootViewController, animated: animated, completion: nil)
        }

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
        self.persistenceService.clear()
        self.schedule.auth = nil
        self.exams.auth = nil
        self.grades.auth = nil
        self.showOnboarding(animated: true)
    }
    
    func refreshSchedule() {
        self.schedule.auth = self.schedule.auth
    }
    
    func triggerScheduleOnboarding(completion: @escaping (ScheduleService.Auth) -> Void) {
        self.triggerOnboarding(.studygroup) { [weak self] schedule, _ in
            guard let auth = schedule else {
                return
            }
            self?.schedule.auth = auth
            self?.exams.auth = auth
            self?.persistenceService.save(auth)
            completion(auth)
        }
    }
    
    func triggerGradeOnboarding(completion: @escaping (GradeService.Auth) -> Void) {
        self.triggerOnboarding(.unixlogin) { [weak self] _, auth in
            guard let auth = auth else {
                return
            }
            self?.grades.auth = auth
            self?.persistenceService.save(auth)
            completion(auth)
        }
    }
    
    private func triggerOnboarding(_ onboarding: OnboardingCoordinator.Onboarding, completion: @escaping (ScheduleService.Auth?, GradeService.Auth?) -> Void) {
        let onboarding = OnboardingCoordinator(onboardings: [onboarding])
        onboarding.onFinish = { [weak onboarding] response in
            completion(response.schedule, response.grade)
            onboarding?.rootViewController.dismiss(animated: true, completion: nil)
        }
        self.addChildCoordinator(onboarding)
        rootNavigationController.present(onboarding.rootViewController, animated: true, completion: nil)
//        self.rootViewController.present(onboarding.rootViewController, animated: true, completion: nil)
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
            viewController = schedule.rootViewController
            rootNavigationController.setTimeTableButtonHighLight()
        case .roomOccupancy:
            viewController = (roomOccupancy.rootViewController as! RoomOccupancyViewController).also {
                $0.appCoordinator = self
            }
        case .roomOccupancyDetail(let room):
            viewController = roomOccupancy.getDetailRoomOccupancyViewController(with: room)
        case .exams:
            viewController = exams.rootViewController
        case .grades:
            viewController = grades.rootViewController
        case .canteen:
            viewController = (canteen.rootViewController as! CanteenViewController).also {
                $0.appCoordinator = self
            }
        case .meal(let canteenDetail):
            viewController = canteen.getMealsTabViewController(for: canteenDetail)
        case .settings:
            viewController = settings.rootViewController
        case .management:
            viewController = management.rootViewController
        }
        
        if rootNavigationController.viewControllers.contains(viewController) {
            rootNavigationController.popToViewController(viewController, animated: animated)
        } else {
            rootNavigationController.pushViewController(viewController, animated: animated)
        }
    }
}
