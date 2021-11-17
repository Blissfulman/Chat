//
//  SettingsServiceImpl.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 18.11.2021.
//

import Foundation

final class SettingsServiceImpl: SettingsService {
    
    // MARK: - Private properties
    
    private var settingsManager: SettingsManager
    
    // MARK: - Initialization
    
    init(settingsManager: SettingsManager) {
        self.settingsManager = settingsManager
    }
    
    // MARK: - Public methods
    
    func saveTheme(_ theme: Theme) {
        settingsManager.theme = theme
    }
    
    func getTheme() -> Theme {
        settingsManager.theme
    }
}
