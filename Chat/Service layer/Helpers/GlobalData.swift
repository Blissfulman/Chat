//
//  GlobalData.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 17.11.2021.
//

import Foundation

struct GlobalData {
    /// Уникальный ID текущего пользователя для текущего устройства (доступно для чтения на протяжении всего времени работы приложения).
    static private(set) var mySenderID = ""
}

extension GlobalData {
    func setMySenderID(value: String) {
        Self.mySenderID = value
    }
}
