//
//  Config.swift
//  sample-logger
//
//  Created by Crystalwing B. on 10/10/24.
//

import Foundation

enum Global {
    
    static let subsystem: String = Bundle.main.bundleIdentifier ?? "com.teamcw.sample-logger"
    static let logger: WLogger = WLogger(subsystem: subsystem, category: "Global")
    
    static var logFileUrl: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("logs.txt")
    }
}
