//
//  ProfileDataManagerImpl.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 17.11.2021.
//

import Foundation

final class ProfileDataManagerImpl: ProfileDataManager {
    
    // MARK: - Nested types
    
    enum AsyncHandlerType {
        case gcd
        case operations
    }
    
    // MARK: - Private properties
    
    private let syncProfileDataManager: SyncProfileDataManager
    private let asyncHandler: AsyncHandler
    
    // MARK: - Initialization
    
    init(syncProfileDataManager: SyncProfileDataManager, asyncHandlerType: AsyncHandlerType) {
        self.syncProfileDataManager = syncProfileDataManager
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
            let result = self.syncProfileDataManager.saveProfile(profile: profile)
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func fetchProfile(completion: @escaping (Result<Profile?, Error>) -> Void) {
        asyncHandler.handle { [weak self] in
            guard let self = self else { return }
            let result = self.syncProfileDataManager.fetchProfile()
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
