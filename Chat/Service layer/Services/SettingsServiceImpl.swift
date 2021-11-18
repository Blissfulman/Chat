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
    private let asyncHandler: AsyncHandler
    
    // MARK: - Initialization
    
    init(settingsManager: SettingsManager, asyncHandler: AsyncHandler) {
        self.settingsManager = settingsManager
        self.asyncHandler = asyncHandler
    }
    
    // MARK: - Public methods
    
    func saveTheme(_ theme: Theme) {
        asyncHandler.handle { [weak self] in
            self?.settingsManager.theme = theme
        }
    }
    
    func getTheme(completion: @escaping (Theme) -> Void) {
        asyncHandler.handle { [weak self] in
            if let theme = self?.settingsManager.theme {
                DispatchQueue.main.async {
                    completion(theme)
                }
            }
        }
    }
}
