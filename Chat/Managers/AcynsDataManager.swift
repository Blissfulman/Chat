//
//  AcynsDataManager.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 21.10.2021.
//

import Foundation

protocol AsyncDataManagerProtocol {
    var asyncHandler: AsyncHandler { get }
    
    func saveProfile(profile: Profile, completion: @escaping (Result<Void, Error>) -> Void)
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
            guard let self = self else { return }
            DispatchQueue.main.async {
                completion(self.profileDataManager.saveProfile(profile: profile))
            }
        }
    }
    
    func fetchProfile(completion: @escaping (Result<Profile?, Error>) -> Void) {
        asyncHandler.handle { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                completion(self.profileDataManager.fetchProfile())
            }
        }
    }
}
