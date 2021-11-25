//
//  SettingsService.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 17.11.2021.
//

import Foundation

protocol SettingsService {
    /// Сохранение темы приложения (выполняется в бэкграунд потоке).
    /// - Parameter theme: Тема.
    func saveTheme(_ theme: Theme)
    /// Получение темы приложения.
    /// - Parameter completion: Обработчик завершения, в который возращается результат (вызывается на главном потоке).
    func getTheme(completion: @escaping (Theme) -> Void)
}
