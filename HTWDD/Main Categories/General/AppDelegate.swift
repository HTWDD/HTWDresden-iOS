//
//  AppDelegate.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 07/11/2016.
//  Copyright © 2016 HTW Dresden. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        analyticsAndCrashlytics()
        
        if NSClassFromString("XCTestCase") != nil {
            return true
        }
        
        Tracker.track(.start)

        let window = UIWindow(frame: UIScreen.main.bounds)

		self.appCoordinator = AppCoordinator(window: window)
		self.window = window

//		self.stylizeUI()
        
        UserDefaults.standard.saveAppVersion()

        realmConfiguration()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        Tracker.track(.open)
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        self.appCoordinator?.goTo(controller: .schedule)
        return true
    }
    
    
	// MARK: - UI Apperance
	private func stylizeUI() {
        UIRefreshControl.appearance().tintColor = .white
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = UIColor.htw.blue
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        }
	}
}

// MARK: - Bootup
extension AppDelegate {
    
    // MARK: - Realm
    func realmConfiguration() {
        let config = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                    migration.enumerateObjects(ofType: TimetableRealm.className()) { oldObject, newObject in
                        newObject!["isHidden"] = false
                                    }
                }
        })
        Realm.Configuration.defaultConfiguration = config
        let _ = try! Realm()
    }
    
    // MARK: - Crashlytics
    private func analyticsAndCrashlytics() {
        Analytics.setAnalyticsCollectionEnabled(false)
        if UserDefaults.standard.crashlytics {
            FirebaseApp.configure()
            Fabric.with([Crashlytics.self])
        }
    }
}

// MARK: - URL-Session
extension NSURLRequest {
    static func allowsAnyHTTPSCertificateForHost(host: String) -> Bool {
        return true
    }
}
