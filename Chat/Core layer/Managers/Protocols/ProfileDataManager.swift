//
//  ProfileDataManager.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 21.10.2021.
//

import Foundation

/// Менеджер асинхронного взаимодействия с хранилищем данных профиля.
protocol ProfileDataManager {
    /// Асинхронное сохранение данных профиля.
    /// - Parameters:
    ///   - profile: Профиль.
    ///   - handlerType: Тип асинхронного обработчика.
    ///   - completion: Обработчик завершения, в который возращается результат (вызывается на главном потоке).
    func saveProfile(
        profile: Profile,
        handlerType: AsyncHandlerType,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    /// Асинхронное получение данных профиля.
    /// - Parameters:
    ///   - handlerType: Тип асинхронного обработчика.
    ///   - completion: Обработчик завершения, в который возращается результат (вызывается на главном потоке).
    func fetchProfile(handlerType: AsyncHandlerType, completion: @escaping (Result<Profile?, Error>) -> Void)
}
