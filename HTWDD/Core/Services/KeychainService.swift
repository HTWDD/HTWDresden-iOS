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
    private let serviceName = "de.htw-dresden.app"
    private let accessGroup = "J748HG75JD.keychain-access-groups"
    private static var sharedKeychainService: KeychainService = {
        return KeychainService()
    }()
    static var shared: KeychainService {
        return sharedKeychainService
    }
    lazy var keychain: KeychainWrapper = { [unowned self] in
        return KeychainWrapper(serviceName: self.serviceName)
    }()
    
    // MARK: - Keys
    enum Key: String {
        case authToken  = "HTW.Auth.Token"
        case studyToken = "HTW.Study.Token"
    }
    
    subscript(key: Key) -> String? {
        get {
            let result = keychain.string(forKey: key.rawValue)
            Log.debug("Keychain <\(keychain): group <\(keychain.accessGroup ?? "")> service<\(keychain.serviceName)>>  get: \(key.rawValue) -> \(result ?? "")")
            return result
        }
        
        set {
            if let newValue = newValue {
                Log.debug("Keychain <\(keychain): group <\(keychain.accessGroup ?? "")> service<\(keychain.serviceName)>> set: \(key.rawValue) -> \(newValue)")
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
    
    /// Try to read the AuthToken
    /// - Returns:
    ///     - Login Account
    func readLoginAccount() -> String? {
        guard let authToken = KeychainService.shared[.authToken], let decodedAuthToken = Data(base64Encoded: authToken) else { return nil }
        guard let components = String(data: decodedAuthToken, encoding: .utf8)?.components(separatedBy: ":"), components.count == 2 else { return nil }
        return components[0]
    }
    
    func removeAllKeys() {
        Log.warn("All Keys in Keychain are removed...")
        keychain.removeAllKeys()
    }
}
