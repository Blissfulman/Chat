//
//  FileStorageManager.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 17.10.2021.
//

import Foundation

enum FileStorageManagerError: Error, LocalizedError {
    case fileReadingError(wrappedError: Error?)
    case decodingError(wrappedError: Error)

    var errorDescription: String? {
        switch self {
        case .fileReadingError(let wrappedError):
            return "File reading error. \(wrappedError?.localizedDescription ?? "")"
        case .decodingError(let wrappedError):
            return "Decoding error. \(wrappedError.localizedDescription)"
        }
    }
}

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
    
    func getValue<Value: Decodable>(withKey key: String, dataType: DataType) throws -> Value? {
        guard let fileDirectory = fileDirectory(for: dataType) else {
            throw FileStorageManagerError.fileReadingError(wrappedError: nil)
        }
        
        do {
            let data = try Data(contentsOf: fileDirectory)
            do {
                let dictionary = try PropertyListDecoder().decode([String: Value].self, from: data)
                return dictionary[key]
            } catch {
                throw FileStorageManagerError.decodingError(wrappedError: error)
            }
        } catch {
            throw FileStorageManagerError.fileReadingError(wrappedError: error)
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
