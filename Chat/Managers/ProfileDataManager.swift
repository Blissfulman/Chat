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
    
    var profileData: Profile? {
        get {
            fileStorageManager.getValue(withKey: profileKey, dataType: dataType)
        }
        set {
            fileStorageManager.saveValue(newValue, withKey: profileKey, dataType: dataType)
        }
    }
}
