//
//  SettingsManager.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 15.10.2021.
//

import Foundation

final class SettingsManager {
    
    static var mySenderID = String(describing: UUID()) // TEMP
    
    // MARK: - Private properties
    
    private let fileStorageManager = FileStorageManager()
    private let dataType = FileStorageManager.DataType.settings
    private let themeKey = "Theme"
    
    // MARK: - Public properties
    
    var theme: Theme {
        get {
            (try? fileStorageManager.getValue(withKey: themeKey, dataType: dataType)) ?? .light
        }
        set {
            try? fileStorageManager.saveValue(newValue, withKey: themeKey, dataType: dataType)
        }
    }
}
