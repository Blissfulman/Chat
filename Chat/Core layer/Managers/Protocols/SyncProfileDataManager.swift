//
//  SyncProfileDataManager.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 20.10.2021.
//

import Foundation

/// Менеджер синхронного взаимодействия с хранилищем данных профиля.
protocol SyncProfileDataManager {
    /// Синхронное сохранение данных профиля.
    /// - Parameter profile: Профиль.
    func saveProfile(profile: Profile) -> Result<Void, Error>
    /// Синхронное получение данных профиля.
    func fetchProfile() -> Result<Profile?, Error>
}
