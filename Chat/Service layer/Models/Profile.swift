//
//  Profile.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 20.10.2021.
//

import Foundation

struct Profile: Codable {
    let fullName: String
    let description: String
    let avatarData: Data?
}
