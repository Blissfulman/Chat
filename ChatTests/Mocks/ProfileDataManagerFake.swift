//
//  ProfileDataManagerFake.swift
//  ChatTests
//
//  Created by Evgeny Novgorodov on 12.12.2021.
//

@testable import Chat

final class ProfileDataManagerFake: ProfileDataManager {
    
    // MARK: - Public properties
    
    var savedProfile: Profile?
    
    // MARK: - Public methods
    
    func saveProfile(
        profile: Profile,
        handlerType: AsyncHandlerType,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        savedProfile = profile
        completion(.success(()))
    }
    
    func fetchProfile(handlerType: AsyncHandlerType, completion: @escaping (Result<Profile?, Error>) -> Void) {
        completion(.success(savedProfile))
    }
}
