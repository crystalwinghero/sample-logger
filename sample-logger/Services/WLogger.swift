//
//  WLogger.swift
//  sample-logger
//
//  Created by Crystalwing B. on 10/10/24.
//

import Foundation
import os

protocol WLoggable {
    func log(type: OSLogType, _ message: String)
}

@available(iOS 14.0, *)
extension Logger: WLoggable {
    func log(type: OSLogType, _ message: String) {
        self.log(level: type, "-> \(message, privacy: .private)")
    }
}
extension OSLog: WLoggable {
    func log(type: OSLogType, _ message: String) {
        os_log(type, log: self, "-> %{private}@", message)
    }
}

struct WLogger: WLoggable {
    private let logger: any WLoggable
    init(subsystem: String, category: String) {
        if #available(iOS 14.0, *) {
            self.logger = Logger(subsystem: subsystem, category: category)
        } else {
            self.logger = OSLog(subsystem: subsystem, category: category)
        }
    }
    init(logger: any WLoggable) {
        self.logger = logger
    }
    
    func log(type: OSLogType = .debug, _ message: String) {
        self.logger.log(type: type, message)
    }
    func log(type: OSLogType = .debug, _ args: Any..., separator: String = " ") {
        self.log(type: type, args.map({ String(describing: $0) }).joined(separator: separator))
    }
}

#if canImport(OSLog)
import OSLog
func fetchLogs() throws -> String? {
    // Available only in iOS 15+ to capture OSLog entries
    if #available(iOS 15.0, *) {
        do {
            let logStore = try OSLogStore(scope: .currentProcessIdentifier)
//            let oneHourAgo = logStore.position(timeIntervalSinceNow: -3600) // Logs from the last hour
            
            let entries = try logStore.getEntries(with: [.reverse])
            var logs: [String] = []
            
            for entry in entries {
                if let logEntry = entry as? OSLogEntryLog {
                    logs.append("[\(logEntry.date)] [\(logEntry.subsystem)] [\(logEntry.category)] \(logEntry.composedMessage)")
                }
            }
            
            return logs.joined(separator: "\n")
        } catch {
            print("Error fetching logs: \(error)")
        }
    }
    return nil
}
#else
func fetchLogs() throws -> String? {
    throw NSError(domain: "Not Supported", code: -1, userInfo: ["message": "OS does not support OSLog"])
}
#endif
