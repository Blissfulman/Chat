//
//  FileStorageManager.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 17.10.2021.
//

import Foundation

/// Менеджер файлового хранилища.
protocol FileStorageManager {
    /// Получение данных из файла.
    /// - Parameters:
    ///   - key: Ключ данных.
    ///   - dataType: Тип данных файлового хранилища.
    func getValue<Value: Decodable>(withKey key: String, dataType: FileStorageDataType) throws -> Value?
    /// Сохранение данных в файл.
    /// - Parameters:
    ///   - value: Сохраняемые данные.
    ///   - key: Ключ данных.
    ///   - dataType: Тип данных файлового хранилища.
    func saveValue<Value: Encodable>(_ value: Value, withKey key: String, dataType: FileStorageDataType) throws
}
