//
//  AcynsDataManager.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 21.10.2021.
//

import Foundation

// MARK: - Protocols

protocol AsyncDataManagerProtocol {
    var asyncHandler: AsyncHandler { get }
    
    /// Асинхронное сохранение данных профиля.
    /// - Parameters:
    ///   - profile: Профиль.
    ///   - completion: Обработчик завершения, в который возращается результат (вызывается на главном потоке).
    func saveProfile(profile: Profile, completion: @escaping (Result<Void, Error>) -> Void)
    /// Асинхронное получение данных профиля.
    /// - Parameter completion: Обработчик завершения, в который возращается результат (вызывается на главном потоке).
    func fetchProfile(completion: @escaping (Result<Profile?, Error>) -> Void)
}

final class AsyncDataManager: AsyncDataManagerProtocol {
    
    // MARK: - Nested types
    
    enum AsyncHandlerType {
        case gcd
        case operations
    }
    
    // MARK: - Public properties
    
    let asyncHandler: AsyncHandler
    
    // MARK: - Private properties
    
    private let profileDataManager = ProfileDataManager()
    
    // MARK: - Initialization
    
    init(asyncHandlerType: AsyncHandlerType) {
        switch asyncHandlerType {
        case .gcd:
            asyncHandler = GCDAsyncHandler(qos: .userInteractive)
        case .operations:
            asyncHandler = OperationsAsyncHandler(qos: .userInteractive)
        }
    }
    
    // MARK: - Public methods
    
    func saveProfile(profile: Profile, completion: @escaping (Result<Void, Error>) -> Void) {
        asyncHandler.handle { [weak self] in
            sleep(2) // TEMP: Для демонстрации вью прогресса при сохранении профиля
            guard let self = self else { return }
            let result = self.profileDataManager.saveProfile(profile: profile)
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func fetchProfile(completion: @escaping (Result<Profile?, Error>) -> Void) {
        asyncHandler.handle { [weak self] in
            guard let self = self else { return }
            let result = self.profileDataManager.fetchProfile()
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
