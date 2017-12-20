//
//  UserDefaults.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04/01/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

extension UserDefaults {

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
    
    func saveAppVersion() {
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }
        self.set(appVersion, forKey: "HTW_APP_VERSION")
    }
	
}
