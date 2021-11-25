//
//  KeychainStorage.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 27.10.2021.
//

import Foundation

protocol KeychainStorage {
    /// Получение значения из хранилища.
    /// - Parameter label: Ярлык получаемого значения.
    func fetchValue(withLabel label: String) -> String?
    /// Сохранение значения в хранилище.
    /// - Parameters:
    ///   - value: Сохраняемое значение.
    ///   - label: Ярлык сохраняемого значения.
    @discardableResult func saveValue(_ value: String, withLabel label: String) -> Bool
}
