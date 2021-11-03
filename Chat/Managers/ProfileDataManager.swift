//
//  ProfileDataManager.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 20.10.2021.
//

import Foundation

final class ProfileDataManager {
    
    // MARK: - Nested types {
    
    private enum Constants {
        static let dataType: FileStorageManager.DataType = .profile
        static let profileKey = "Profile"
    }
    
    // MARK: - Private properties
    
    private let fileStorageManager = FileStorageManager()
    
    // MARK: - Public properties
    
    func saveProfile(profile: Profile) -> Result<Void, Error> {
        do {
            try fileStorageManager.saveValue(profile, withKey: Constants.profileKey, dataType: Constants.dataType)
            return .success(())
        } catch {
            return .failure(error)
        }
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
        try fileStorageManager.getValue(withKey: Constants.profileKey, dataType: Constants.dataType)
    }
}
