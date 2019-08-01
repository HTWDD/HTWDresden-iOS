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
        case analytics = "HTW_APP_ANALYTICS"
        case crashlytics = "HTW_APP_CRASHLYTICS"
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
}
