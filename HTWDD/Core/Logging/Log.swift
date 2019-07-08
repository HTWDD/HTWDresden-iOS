//
//  Log.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04/01/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

final class Log {
    
    static func error(_ error: @autoclosure () -> Error) {
        self.error(String(describing: error()))
    }

    static func error(_ error: @autoclosure () -> String, file: String = #file, line: Int = #line, callerFunction: String = #function) {
        print("❤️", additionalInformation(file, line, callerFunction), error(), "\n")
    }

    static func info(_ text: @autoclosure () -> String, file: String = #file, line: Int = #line, callerFunction: String = #function) {
        print("💚", additionalInformation(file, line, callerFunction), text(), "\n")
    }
    
    static func verbose(_ text: @autoclosure () -> String, file: String = #file, line: Int = #line, callerFunction: String = #function) {
        print("💜", additionalInformation(file, line, callerFunction), text(), "\n")
    }
    
    static func debug(_ text: @autoclosure () -> String, file: String = #file, line: Int = #line, callerFunction: String = #function) {
        print("💙", additionalInformation(file, line, callerFunction), text(), "\n")
    }
    
    static func warn(_ text: @autoclosure () -> String, file: String = #file, line: Int = #line, callerFunction: String = #function) {
        print("💛", additionalInformation(file, line, callerFunction), text(), "\n")
    }

    static func typeAsString(_ obj: Any) -> String {
        return String(describing: type(of: obj))
    }
    
    static func fileNameFrom(fileURLWithPath: String) -> String {
        return NSURL(fileURLWithPath: fileURLWithPath).lastPathComponent ?? "NO-FILE"
    }
    
    fileprivate static func additionalInformation(_ file: String, _ line: Int, _ callerFunction: String) -> String {
        return "\(fileNameFrom(fileURLWithPath: file))::\(line) - \(callerFunction)\n\t"
    }
}
