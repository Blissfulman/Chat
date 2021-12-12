//
//  FileStorageManagerFake.swift
//  ChatTests
//
//  Created by Evgeny Novgorodov on 12.12.2021.
//

@testable import Chat

final class FileStorageManagerFake: FileStorageManager {
    
    // MARK: - Public properties
    
    var savedValue: Any?
    
    // MARK: - Public methods
    
    func getValue<Value: Decodable>(withKey key: String, dataType: FileStorageDataType) throws -> Value? {
        savedValue as? Value
    }
    
    func saveValue<Value: Encodable>(_ value: Value, withKey key: String, dataType: FileStorageDataType) throws {
        savedValue = value
    }
}
