//
//  KeychainStorage.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 27.10.2021.
//

import Foundation

protocol KeychainStorage {
    func fetchValue(withLabel label: String) -> String?
    @discardableResult func saveValue(_ value: String, withLabel label: String) -> Bool
}
