//
//  SettingsManager.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 15.10.2021.
//

import Foundation

final class SettingsManager {
    
    // MARK: - Private properties
    
    private let themeKey = "ThemeKey"
    
    // MARK: - Public properties
    
    var theme: Theme {
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: themeKey)
        }
        get {
            guard let value = UserDefaults.standard.string(forKey: themeKey) else { return .light }
            return Theme(rawValue: value) ?? .light
        }
    }
}
