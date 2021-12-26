//
//  ProfileServiceImpl.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 18.11.2021.
//

import Foundation

final class ProfileServiceImpl: ProfileService {
    
    // MARK: - Private properties
    
    private let profileDataManager: ProfileDataManager
    
    // MARK: - Initialization
    
    init(profileDataManager: ProfileDataManager) {
        self.profileDataManager = profileDataManager
    }
    
    // MARK: - Public methods
    
    func saveProfile(
        profile: Profile,
        asyncHandlerType: AsyncHandlerType,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        profileDataManager.saveProfile(profile: profile, handlerType: asyncHandlerType, completion: completion)
    }
    
    func fetchProfile(completion: @escaping (Result<Profile?, Error>) -> Void) {
        profileDataManager.fetchProfile(handlerType: .gcd, completion: completion)
    }
}
