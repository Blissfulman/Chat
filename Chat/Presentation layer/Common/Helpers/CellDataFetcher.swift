//
//  CellDataFetcher.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 25.11.2021.
//

import Foundation

enum CellDataFetcher {
    
    /// Получение данных изображения, полученного по переданному `URL`.
    ///
    /// Сперва происходит проверка наличия изображения в кэше.
    /// В случае отсутствия изображения в кэше, происходит его фоновая загрузка из сети с автоматическим кэшированием.
    /// - Parameters:
    ///   - url: `URL` изображения.
    ///   - completion: Обработчик завершения, в который возращается полученные данные изображения и URL (вызывается на главном потоке).
    static func fetchImageData(with url: URL, completion: @escaping (Data, URL) -> Void) {
        let request = URLRequest(url: url)
        if let imageData = URLCache.shared.cachedResponse(for: request)?.data {
            completion(imageData, url)
        }
        DispatchQueue.global(qos: .userInteractive).async {
            if let imageData = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    completion(imageData, url)
                }
            }
        }
    }
}
