//
//  SettingsService.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 17.11.2021.
//

import Foundation

protocol SettingsService {
    func saveTheme(_ theme: Theme)
    func getTheme() -> Theme
}
