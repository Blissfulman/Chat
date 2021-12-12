//
//  KeychainStorageFake.swift
//  ChatTests
//
//  Created by Evgeny Novgorodov on 12.12.2021.
//

@testable import Chat

final class KeychainStorageFake: KeychainStorage {
    
    // MARK: - Public properties
    
    var savedValue: String?
    
    // MARK: - Public methods
    
    func fetchValue(withLabel label: String) -> String? {
        savedValue
    }
    
    @discardableResult func saveValue(_ value: String, withLabel label: String) -> Bool {
        savedValue = value
        return true
    }
}
