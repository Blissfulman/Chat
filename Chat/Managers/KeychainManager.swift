//
//  KeychainManager.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 27.10.2021.
//

import Foundation

// MARK: - Protocols

protocol KeychainManagerProtocol {
    func fetchValue(withLabel label: String) -> String?
    @discardableResult func saveValue(_ value: String, withLabel label: String) -> Bool
}

final class KeychainManager: KeychainManagerProtocol {
    
    // MARK: - Private properties
    
    private let serviceName = "TinkoffChat"
    
    // MARK: - Public methods
    
    func fetchValue(withLabel label: String) -> String? {
        guard
            let value = readValue(withLabel: label)
        else {
            print("Keychain data not found")
            return nil
        }
        return value
    }
    
    func saveValue(_ value: String, withLabel label: String) -> Bool {
        let data = value.data(using: .utf8)
        
        if readValue(withLabel: label) != nil {
            var attributesToUpdate = [String: AnyObject]()
            attributesToUpdate[kSecValueData as String] = data as AnyObject
            
            let query = keychainQuery(label: label)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            return status == noErr
        }
        var item = keychainQuery(label: label)
        item[kSecValueData as String] = data as AnyObject
        let status = SecItemAdd(item as CFDictionary, nil)
        
        if status == noErr {
            print("Data saved to Keychain")
        }
        return status == noErr
    }
    
    // MARK: - Private methods
    
    private func keychainQuery(label: String) -> [String: AnyObject] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked,
            kSecAttrLabel as String: label as AnyObject,
            kSecAttrService as String: serviceName as AnyObject
        ]
    }

    private func readValue(withLabel label: String) -> String? {
        var query = keychainQuery(label: label)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        
        var queryResult: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &queryResult)
        
        guard status == noErr else { return nil }
        
        guard
            let item = queryResult as? [String: AnyObject],
            let data = item[kSecValueData as String] as? Data,
            let value = String(data: data, encoding: .utf8)
        else {
            print("Unexpected Keychain data")
            return nil
        }
        return value
    }
}
