//
//  SettingsManager.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 15.10.2021.
//

import Foundation

final class SettingsManager {
    
    // MARK: - Private properties
    
    private let fileStorageManager = FileStorageManager()
    private let dataType = FileStorageManager.DataType.settings
    private let themeKey = "Theme"
    
    // MARK: - Public properties
    
    var theme: Theme {
        get {
            fileStorageManager.getValue(withKey: themeKey, dataType: dataType) ?? .light
        }
        set {
            fileStorageManager.saveValue(newValue, withKey: themeKey, dataType: dataType)
        }
    }
}
