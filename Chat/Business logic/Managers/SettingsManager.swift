//
//  SettingsManager.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 15.10.2021.
//

import Foundation

final class SettingsManager {
    
    // MARK: - Static properties
    
    /// Уникальный ID текущего пользователя для текущего устройства.
    ///
    /// Значение данного свойства доступно для чтения на протяжении всего времени работы приложения.
    ///
    /// При запуске приложения должна происходить проверка наличия значения ID текущего пользователя в постоянном хранилище (Keychain).
    /// В случае успешного получения значения, оно присваивается данному параметру.
    /// В случае неудачной попытки, новое значение параметра должно генерироваться и сохраняться в постоянное хранилище (с его присвоением данному параметру).
    static private(set) var mySenderID = ""
    
    // MARK: - Nested types {
    
    private enum Constants {
        static let dataType: FileStorageManager.DataType = .settings
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
    
    private let fileStorageManager = FileStorageManager()
    private let keychainManager: KeychainManagerProtocol = KeychainManager()
    
    // MARK: - Public methods
    
    func loadMySenderID() {
        if let mySenderID = keychainManager.fetchValue(withLabel: Constants.mySenderIDKey),
           !mySenderID.isEmpty {
            SettingsManager.mySenderID = mySenderID
        } else {
            let newSenderID = String(describing: UUID())
            keychainManager.saveValue(newSenderID, withLabel: Constants.mySenderIDKey)
            SettingsManager.mySenderID = newSenderID
        }
    }
}
