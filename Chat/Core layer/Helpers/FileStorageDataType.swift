//
//  FileStorageDataType.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 17.11.2021.
//

import Foundation

enum FileStorageDataType: String {
    case settings
    case profile
    
    var toFileName: String {
        self.rawValue.capitalized
    }
}
