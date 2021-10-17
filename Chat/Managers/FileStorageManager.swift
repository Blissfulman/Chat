//
//  FileStorageManager.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 17.10.2021.
//

import Foundation

final class FileStorageManager {
    
    // MARK: - Nested types
    
    enum DataType: String {
        case settings
        case profile
        
        var key: String {
            self.rawValue.capitalized
        }
    }
    
    // MARK: - Public methods
    
    func getValue<Value: Decodable>(withKey key: String, dataType: DataType) -> Value? {
        guard let fileDirectory = fileDirectory(for: dataType) else { return nil }
        do {
            let data = try Data(contentsOf: fileDirectory)
            let dictionary = try PropertyListDecoder().decode([String: Value].self, from: data)
            return dictionary[key]
        } catch {
            print(error)
            return nil
        }
    }
    
    func saveValue<Value: Encodable>(_ value: Value, withKey key: String, dataType: DataType) {
        guard let fileDirectory = fileDirectory(for: dataType) else { return }
        do {
            let data = try PropertyListEncoder().encode([key: value])
            try data.write(to: fileDirectory, options: .noFileProtection)
        } catch {
            print(error)
        }
    }
    
    // MARK: - Private methods
    
    private func fileDirectory(for dataType: DataType) -> URL? {
        guard let folderDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return folderDirectory.appendingPathComponent(dataType.key).appendingPathExtension("plist")
    }
    
}
