//
//  SettingsManager.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 15.10.2021.
//

import Foundation

protocol SettingsManager {
    var theme: Theme { get set }
    func loadMySenderID()
}
