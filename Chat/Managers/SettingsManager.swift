//
//  SettingsManager.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 15.10.2021.
//

import Foundation

final class SettingsManager {
    
    // MARK: - Public properties
    
    var theme: Theme {
        get {
            (try? fileStorageManager.getValue(withKey: themeKey, dataType: dataType)) ?? .light
        }
        set {
            try? fileStorageManager.saveValue(newValue, withKey: themeKey, dataType: dataType)
        }
    }
    
    var mySenderID: String {
        keychainManager.fetchValue(withLabel: mySenderIDKey) ?? ""
    }
    
    // MARK: - Private properties
    
    private let fileStorageManager = FileStorageManager()
    private let keychainManager: KeychainManagerProtocol = KeychainManager()
    private let dataType = FileStorageManager.DataType.settings
    private let themeKey = "Theme"
    private let mySenderIDKey = "MySenderID"
    
    // MARK: - Public methods
    
    func generateMySenderIDIfNeeded() {
        if mySenderID.isEmpty {
            let newSenderID = String(describing: UUID())
            keychainManager.saveValue(newSenderID, withLabel: mySenderIDKey)
        }
    }
}
