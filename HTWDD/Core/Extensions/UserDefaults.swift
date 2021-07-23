//
//  UserDefaults.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04/01/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    enum Key: String {
        case firstLaunched       = "HTW.App.First.Launched"
        case analytics          = "HTW.Analytics.Enabled"
        case crashlytics        = "HTW.Crashlytics.Enabled"
        case crashlyticsAsked   = "HTW.Crashlytics.Asked"
        case needsOnboarding    = "HTW.Onboarding.Needs"
    }
    
    
    /// Clears ALL saved data from the user defaults.
    ///
    /// NOTE: Use with caution!
    ///
    /// - Returns: true if defaults were saved before, false if not
    @discardableResult func clear() -> Bool {
        if let bundle = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundle)
            return true
        } else {
            return false
        }
    }
    
    func set<T>(_ value: T?, forKey key: Key) {
        set(value, forKey: key.rawValue)
    }
    
    func value<T>(forKey key: Key) -> T? {
        return value(forKey: key.rawValue) as? T
    }
    
    func saveAppVersion() {
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }
        self.set(appVersion, forKey: "HTW_APP_VERSION")
    }
    
    func saveFirstLaunchDate() {
        guard self.firstLaunchDate == nil else {
            return
        }
        
        self.firstLaunchDate = Date()
    }
    
    var analytics: Bool {
        get {
            return value(forKey: .analytics) ?? false
        }
        set {
            set(newValue, forKey: .analytics)
        }
    }
    
    var crashlytics: Bool {
        get {
            return value(forKey: .crashlytics) ?? false
        }
        set {
            set(newValue, forKey: .crashlytics)
        }
    }
    
    var crashlyticsAsked: Bool {
        get {
            return value(forKey: .crashlyticsAsked) ?? false
        }
        set {
            set(newValue, forKey: .crashlyticsAsked)
        }
    }
    
    var firstLaunchDate: Date? {
        get {
            return value(forKey: .firstLaunched)
        }
        set {
            set(newValue, forKey: .firstLaunched)
        }
    }
    
    
    
    var needsOnboarding: Bool {
        get {
            return value(forKey: .needsOnboarding) ?? true
        }
        set {
            set(newValue, forKey: .needsOnboarding)
        }
    }
}
