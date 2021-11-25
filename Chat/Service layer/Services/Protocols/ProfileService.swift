//
//  ProfileService.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 18.11.2021.
//

import Foundation

protocol ProfileService {
    /// Асинхронное сохранение данных профиля.
    /// - Parameters:
    ///   - profile: Профиль.
    ///   - asyncHandlerType: Тип асинхронного обработчика.
    ///   - completion: Обработчик завершения, в который возращается результат (вызывается на главном потоке).
    func saveProfile(
        profile: Profile,
        asyncHandlerType: AsyncHandlerType,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    /// Асинхронное получение данных профиля.
    /// - Parameter completion: Обработчик завершения, в который возращается результат (вызывается на главном потоке).
    func fetchProfile(completion: @escaping (Result<Profile?, Error>) -> Void)
}
