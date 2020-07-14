//
//  Log.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04/01/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import os.log

/// Enum wich maps an appropiate symbol wich added as prefix for each log message
enum LogLevel: String {
    /// Verbose Level
    case v = "[🤍]"
    
    /// Info Level
    case i = "[💚]"
    
    /// Debug Level
    case d = "[💙]"
    
    /// Warning Level
    case w = "[💛]"
    
    /// Error Level
    case e = "[❤️]"
}


final class Log {
    
    static func error(_ error: @autoclosure () -> Error) {
        self.error(String(describing: error()))
    }

    static func error(_ error: @autoclosure () -> String, file: String = #file, line: Int = #line, column: Int = #column, callerFunction: String = #function) {
         consoleLog(.e, output: "[\(sourceFileName(file))]:[\(line) \(column)] \(callerFunction) -> \(error())")
    }

    static func info(_ text: @autoclosure () -> String, file: String = #file, line: Int = #line, column: Int = #column, callerFunction: String = #function) {
        consoleLog(.i, output: "[\(sourceFileName(file))]:[\(line) \(column)] \(callerFunction) -> \(text())")
    }
    
    static func verbose(_ text: @autoclosure () -> String, file: String = #file, line: Int = #line, column: Int = #column, callerFunction: String = #function) {
         consoleLog(.v, output: "[\(sourceFileName(file))]:[\(line) \(column)] \(callerFunction) -> \(text())")
    }
    
    static func debug(_ text: @autoclosure () -> String, file: String = #file, line: Int = #line, column: Int = #column, callerFunction: String = #function) {
         consoleLog(.d, output: "[\(sourceFileName(file))]:[\(line) \(column)] \(callerFunction) -> \(text())")
    }
    
    static func warn(_ text: @autoclosure () -> String, file: String = #file, line: Int = #line, column: Int = #column, callerFunction: String = #function) {
        consoleLog(.w, output: "[\(sourceFileName(file))]:[\(line) \(column)] \(callerFunction) -> \(text())")
    }

    /// Output to console, only in debug
    private static func consoleLog(_ level: LogLevel, output: String) {
        os_log("%@ %@", level.rawValue, output)
    }
    
    private static func sourceFileName(_ filePath: String) -> String {
        return filePath.components(separatedBy: "/").last ?? ""
    }
}
