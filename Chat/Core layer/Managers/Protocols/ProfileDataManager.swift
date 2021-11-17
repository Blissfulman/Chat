//
//  ProfileDataManager.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 21.10.2021.
//

import Foundation

protocol ProfileDataManager {
    /// Асинхронное сохранение данных профиля.
    /// - Parameters:
    ///   - profile: Профиль.
    ///   - completion: Обработчик завершения, в который возращается результат (вызывается на главном потоке).
    func saveProfile(profile: Profile, completion: @escaping (Result<Void, Error>) -> Void)
    /// Асинхронное получение данных профиля.
    /// - Parameter completion: Обработчик завершения, в который возращается результат (вызывается на главном потоке).
    func fetchProfile(completion: @escaping (Result<Profile?, Error>) -> Void)
}
