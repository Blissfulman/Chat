//
//  SyncProfileDataManager.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 20.10.2021.
//

import Foundation

protocol SyncProfileDataManager {
    func saveProfile(profile: Profile) -> Result<Void, Error>
    func fetchProfile() -> Result<Profile?, Error>
}
