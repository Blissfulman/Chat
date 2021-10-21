//
//  ProfileDataManager.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 20.10.2021.
//

import Foundation

final class ProfileDataManager {
    
    // MARK: - Private properties
    
    private let fileStorageManager = FileStorageManager()
    private let dataType = FileStorageManager.DataType.profile
    private let profileKey = "Profile"
    
    // MARK: - Public properties
    
    func saveProfile(profile: Profile) -> Result<Void, Error> {
        fileStorageManager.saveValue(profile, withKey: profileKey, dataType: dataType)
        return .success(())
    }
    
    func fetchProfile() -> Result<Profile?, Error> {
        do {
            return .success(try getProfileValue())
        } catch {
            return .failure(error)
        }
    }
    
    // MARK: - Private methods
    
    private func getProfileValue() throws -> Profile? {
        try fileStorageManager.getValue(withKey: profileKey, dataType: dataType)
    }
}
