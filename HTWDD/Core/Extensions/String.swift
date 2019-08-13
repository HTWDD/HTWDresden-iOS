//
//  String.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 20/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import UIKit.UIColor
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

extension String {

    var base64: String {
        return Data(self.utf8).base64EncodedString()
    }

	func rangeOfSubString(_ string: String) -> NSRange? {
		let range = NSString(string: self).range(of: string)
		return range.location != NSNotFound ? range : nil
	}
    
    func attrubutedString(_ attrs: [NSAttributedString.Key : Any], manipulation of: String, manipulated: [NSAttributedString.Key : Any]) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self).also {
            $0.addAttributes(attrs, range: NSRange(location: 0, length: self.count))
            if let range = self.rangeOfSubString(of) {
                $0.addAttributes(manipulated, range: range)
            }
        }
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(with comment: String) -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var uid: String {
        return md5()
            .enumerated()
            .compactMap {
                if $0.offset % 4 == 0 && $0.offset != 0 {
                    return String(format: "%02hhx-", $0.element)
                } else {
                    return String(format: "%02hhx", $0.element)
                }
            }.joined()
    }
    
    fileprivate func md5() -> Data {
        let length      = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = self.data(using: .utf8)!
        var digestData  = Data(count: length)
        
        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData
    }
    
    func toTimeDate() -> Date {
        return DateFormatter().also {
            $0.dateFormat = "HH:mm:ss"
        }.date(from: self)!
    }
    
    // MARK: - ID-To-UIColor
    var color: UIColor {
        
        let hexColorString = String(String(self.reversed())
            .md5()
            .enumerated()
            .compactMap( { String(format: "%02hhx", $0.element) })
            .joined()
            .prefix(6))
        
        return UIColor(hex: UInt(hexColorString, radix: 16)!)
        
    }
    
    var nilWhenEmpty: String? {
        guard isEmpty else { return self }
        return nil
    }
}

enum Constants {
	static let groupID = "group.develappers.htw-dresden.ios"
}
