//
//  GlobalFlags.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 27.09.2021.
//

import Foundation

enum GlobalFlags {
    
    static var loggingEnabled: Bool {
        UserDefaults.standard.bool(forKey: "loggingEnabled")
    }
}
