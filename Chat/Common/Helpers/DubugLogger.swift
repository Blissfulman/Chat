//
//  DubugLogger.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 18.11.2021.
//

import Foundation

enum DebugLogger {
    
    static func log(_ message: String) {
        #if DEBUG
        print(message)
        #endif
    }
}
