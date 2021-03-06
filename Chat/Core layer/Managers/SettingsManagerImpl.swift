//
//  SettingsManagerImpl.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 17.11.2021.
//

import Foundation

final class SettingsManagerImpl: SettingsManager {
    
    // MARK: - Nested types {
    
    private enum Constants {
        static let dataType: FileStorageDataType = .settings
        static let themeKey = "Theme"
        static let mySenderIDKey = "MySenderID"
    }
    
    // MARK: - Public properties
    
    var theme: Theme {
        get {
            (try? fileStorageManager.getValue(withKey: Constants.themeKey, dataType: Constants.dataType)) ?? .light
        }
        set {
            try? fileStorageManager.saveValue(newValue, withKey: Constants.themeKey, dataType: Constants.dataType)
        }
    }
    
    // MARK: - Private properties
    
    private let fileStorageManager: FileStorageManager
    private let keychainStorage: KeychainStorage
    
    // MARK: - Initialization
    
    init(fileStorageManager: FileStorageManager, keychainStorage: KeychainStorage) {
        self.fileStorageManager = fileStorageManager
        self.keychainStorage = keychainStorage
    }
    
    // MARK: - Public methods
    
    func loadMySenderID() {
        if let mySenderID = keychainStorage.fetchValue(withLabel: Constants.mySenderIDKey),
           !mySenderID.isEmpty {
            GlobalData().setMySenderID(value: mySenderID)
        } else {
            let newSenderID = String(describing: UUID())
            keychainStorage.saveValue(newSenderID, withLabel: Constants.mySenderIDKey)
            GlobalData().setMySenderID(value: newSenderID)
        }
    }
}
