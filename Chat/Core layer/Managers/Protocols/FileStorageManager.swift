//
//  FileStorageManager.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 17.10.2021.
//

import Foundation

protocol FileStorageManager {
    func getValue<Value: Decodable>(withKey key: String, dataType: FileStorageDataType) throws -> Value?
    func saveValue<Value: Encodable>(_ value: Value, withKey key: String, dataType: FileStorageDataType) throws
}
