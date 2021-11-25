//
//  FileStorageDataType.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 17.11.2021.
//

import Foundation

/// Тип данных файлового хранилища.
enum FileStorageDataType: String {
    case settings
    case profile
    
    /// Используется для определения имени файла в файловом хранилище.
    var toFileName: String {
        self.rawValue.capitalized
    }
}
