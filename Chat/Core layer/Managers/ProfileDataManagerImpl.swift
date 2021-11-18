//
//  ProfileDataManagerImpl.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 17.11.2021.
//

import Foundation

final class ProfileDataManagerImpl: ProfileDataManager {
    
    // MARK: - Private properties
    
    private let syncProfileDataManager: SyncProfileDataManager
    private let gcdAsyncHandler: GCDAsyncHandler
    private let operationsAsyncHandler: OperationsAsyncHandler
    
    // MARK: - Initialization
    
    init(syncProfileDataManager: SyncProfileDataManager, handlerQoS: AsyncHandlerQoS) {
        self.syncProfileDataManager = syncProfileDataManager
        self.gcdAsyncHandler = GCDAsyncHandler(qos: handlerQoS.gcdQoS)
        self.operationsAsyncHandler = OperationsAsyncHandler(qos: handlerQoS.operationsQoS)
    }
    
    // MARK: - Public methods
    
    func saveProfile(
        profile: Profile,
        handlerType: AsyncHandlerType,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let handler: AsyncHandler = handlerType == .gcd ? gcdAsyncHandler : operationsAsyncHandler
        handler.handle { [weak self] in
            guard let self = self else { return }
            let result = self.syncProfileDataManager.saveProfile(profile: profile)
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func fetchProfile(handlerType: AsyncHandlerType, completion: @escaping (Result<Profile?, Error>) -> Void) {
        let handler: AsyncHandler = handlerType == .gcd ? gcdAsyncHandler : operationsAsyncHandler
        handler.handle { [weak self] in
            guard let self = self else { return }
            let result = self.syncProfileDataManager.fetchProfile()
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
