//
//  ThemesPresenter.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 19.11.2021.
//

import Foundation

protocol ThemesPresenterLogic {
    func getTheme(completion: @escaping (Theme) -> Void)
    func didChooseTheme(to theme: Theme)
}

final class ThemesPresenter: ThemesPresenterLogic {
    
    // MARK: - Private properties
    
    private let settingsService: SettingsService
    private let didChooseThemeHandler: (Theme) -> Void
    
    // MARK: - Initialization
    
    init(
        settingsService: SettingsService = ServiceLayer.shared.settingsService,
        didChooseThemeHandler: @escaping (Theme) -> Void
    ) {
        self.settingsService = settingsService
        self.didChooseThemeHandler = didChooseThemeHandler
    }
    
    // MARK: - Public methods
    
    func getTheme(completion: @escaping (Theme) -> Void) {
        settingsService.getTheme { theme in
            completion(theme)
        }
    }
    
    func didChooseTheme(to theme: Theme) {
        didChooseThemeHandler(theme)
    }
}
