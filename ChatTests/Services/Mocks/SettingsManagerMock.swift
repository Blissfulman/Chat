//
//  SettingsManagerMock.swift
//  ChatTests
//
//  Created by Evgeny Novgorodov on 09.12.2021.
//

@testable import Chat

final class SettingsManagerMock: SettingsManager {
    
    var theme = Theme.light
    
    func loadMySenderID() {}
}
