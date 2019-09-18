//
//  Logger.swift
//  Grades
//
//  Created by Ignacio Paradisi on 8/25/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation
import os

class Logger {
    
    enum Category: String {
        case term = "Term"
        case subject = "Subject"
        case assignment = "Assignment"
        case none
    }
    
    /// Logs a message
    ///
    /// - Parameters:
    ///   - message: Message to be logged
    ///   - category: Category of the log
    ///   - type: Type of log
    ///   - args: Arguments
    public static func log(_ message: StaticString, category: Logger.Category, type: OSLogType, _ args: CVarArg...) {
        let log = (category == .none) ? OSLog.default : OSLog(subsystem: "com.ignacioparadisi.Grades", category: category.rawValue)
        os_log(message, log: log, type: type, args)
    }
}
