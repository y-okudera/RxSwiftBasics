//
//  Logger.swift
//  Training2
//
//  Created by Yuki Okudera on 2019/10/25.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation

struct Logger {
    
    private static var dateString: String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter.string(from: date)
    }
    
    enum LogLevel: String {
        case verbose
        case debug
        case info
        case warn
        case error
    }
    
    static func verbose(file: String = #file, function: String = #function, line: Int = #line, _ message: String = "") {
        printToConsole(logLevel: .verbose, icon:"", file: file, function: function, line: line, message: message)
    }
    
    static func debug(file: String = #file, function: String = #function, line: Int = #line, _ message: String = "") {
        printToConsole(logLevel: .debug, icon:"", file: file, function: function, line: line, message: message)
    }
    
    static func info(file: String = #file, function: String = #function, line: Int = #line, _ message: String = "") {
        printToConsole(logLevel: .info, icon:"😬", file: file, function: function, line: line, message: message)
    }
    
    static func warn(file: String = #file, function: String = #function, line: Int = #line, _ message: String = "") {
        printToConsole(logLevel: .warn, icon:"⚠️", file: file, function: function, line: line, message: message)
    }
    
    static func error(file: String = #file, function: String = #function, line: Int = #line, _ message: String = "") {
        printToConsole(logLevel: .error, icon:"⛔️", file: file, function: function, line: line, message: message)
//        assertionFailure(message)
    }
    
    private static func className(from filePath: String) -> String {
        let fileName = filePath.components(separatedBy: "/").last
        return fileName?.components(separatedBy: ".").first ?? ""
    }
    
    private static func printToConsole(logLevel: LogLevel, icon: String, file: String, function: String, line: Int, message: String) {
        #if DEBUG
        print("\(dateString) [\(icon)\(logLevel.rawValue.uppercased())] \(className(from: file)).\(function) #\(line): \(message)")
        #endif
    }
}
