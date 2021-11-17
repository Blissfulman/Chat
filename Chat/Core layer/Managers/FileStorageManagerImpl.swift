//
//  FileStorageManagerImpl.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 17.11.2021.
//

import Foundation

enum FileStorageManagerError: Error, LocalizedError {
    case fileReadingError(wrappedError: Error?)
    case fileSavingError(wrappedError: Error)
    case decodingError(wrappedError: Error)
    case encodingError(wrappedError: Error)

    var errorDescription: String? {
        switch self {
        case .fileReadingError(let wrappedError):
            return "File reading error. \(wrappedError?.localizedDescription ?? "")"
        case .fileSavingError(let wrappedError):
            return "File saving error. \(wrappedError.localizedDescription)"
        case .decodingError(let wrappedError):
            return "Decoding error. \(wrappedError.localizedDescription)"
        case .encodingError(let wrappedError):
            return "Encoding error. \(wrappedError.localizedDescription)"
        }
    }
}

final class FileStorageManagerImpl: FileStorageManager {
    
    // MARK: - Public methods
    
    func getValue<Value: Decodable>(withKey key: String, dataType: FileStorageDataType) throws -> Value? {
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
    
    func saveValue<Value: Encodable>(_ value: Value, withKey key: String, dataType: FileStorageDataType) throws {
        guard let fileDirectory = fileDirectory(for: dataType) else {
            throw FileStorageManagerError.fileReadingError(wrappedError: nil)
        }
        
        do {
            let data = try PropertyListEncoder().encode([key: value])
            do {
                try data.write(to: fileDirectory, options: .noFileProtection)
            } catch {
                throw FileStorageManagerError.fileSavingError(wrappedError: error)
            }
        } catch {
            throw FileStorageManagerError.encodingError(wrappedError: error)
        }
    }
    
    // MARK: - Private methods
    
    private func fileDirectory(for dataType: FileStorageDataType) -> URL? {
        guard let folderDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return folderDirectory.appendingPathComponent(dataType.toFileName).appendingPathExtension("plist")
    }
}
