//
//  SettingsManagerMock.swift
//  ChatTests
//
//  Created by Evgeny Novgorodov on 09.12.2021.
//

@testable import Chat

final class SettingsManagerMock: SettingsManager {
    
    // MARK: - Public properties
    
    var theme = Theme.light
    
    // MARK: - Public methods
    
    func loadMySenderID() {}
}
