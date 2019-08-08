//
//  Keychain.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 07.08.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class KeychainService {
    
    // MARK: - Properties
    private static var sharedKeychainService: KeychainService = {
        return KeychainService()
    }()
    static var shared: KeychainService {
        return sharedKeychainService
    }
    private let keychain: KeychainWrapper
    
    // MARK: - Keys
    enum Key: String {
        case authToken  = "HTW.Auth.Token"
        case studyToken = "HTW.Study.Token"
    }
    
    // MAKR: - Lifecycle
    private init() {
        keychain = KeychainWrapper.standard
    }
    
    subscript(key: Key) -> String? {
        get {
            return keychain.string(forKey: key.rawValue)
        }
        
        set {
            if let newValue = newValue {
                Log.debug("Keychain set: \(key.rawValue) -> \(newValue)")
                keychain.set(newValue, forKey: key.rawValue)
            }
        }
    }
    
    /// Store the Study Token to Keychain as Base64 Encoded
    /// - Parameters:
    ///     - year: Study Year
    ///     - major: Study Major (Fach)
    ///     - group: Study Group
    func storeStudyToken(year: String?, major: String?, group: String?, graduation: String?) {
        guard let year = year, let major = major, let group = group, let graduation = graduation else {
            Log.warn("Year, Major and Group are nil, .studyToken removed from Keychain")
            keychain.removeObject(forKey: Key.studyToken.rawValue)
            return
        }
        
        if let studyToken = "\(year):\(major):\(group):\(graduation)".data(using: .utf8) {
            KeychainService.shared[.studyToken] = studyToken.base64EncodedString(options: .lineLength64Characters)
        }
    }
    
    /// Try to read the Studytoken
    /// - Returns:
    ///     - Quad: Year, Major (Fach), Group, Graduation
    func readStudyToken() -> (year: String?, major: String?, group: String?, graduation: String?) {
        guard let studyToken = KeychainService.shared[.studyToken], let decodedStudyToken = Data(base64Encoded: studyToken)  else { return (nil, nil, nil, nil) }
        guard let components = String(data: decodedStudyToken, encoding: .utf8)?.components(separatedBy: ":"), components.count == 4 else { return (nil, nil, nil, nil) }
        return (components[0], components[1], components[2], components[3])
    }
    
    func removeAllKeys() {
        Log.warn("All Keys in Keychain are removed...")
        keychain.removeAllKeys()
    }
}
