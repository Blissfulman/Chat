//
//  CellDataFetcher.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 25.11.2021.
//

import Foundation

final class CellImageFetcher {
    
    // MARK: - Private properties
    
    private var lastURL: URL?
    private var lastDataTask: URLSessionDataTask?
    
    // MARK: - Public methods
    
    /// Получение данных изображения по переданному `URL`.
    ///
    /// Сперва происходит проверка наличия изображения в кэше.
    /// В случае отсутствия изображения в кэше, происходит его фоновая загрузка из сети с автоматическим кэшированием.
    /// Обработчик завершения вызывается только если к моменту получения данных не поступало нового запроса по другому URL.
    /// - Parameters:
    ///   - url: `URL` изображения.
    ///   - completion: Обработчик завершения, в который возращается полученные данные изображения (вызывается на главном потоке).
    func fetchImageData(with url: URL, completion: @escaping (Data) -> Void) {
        lastURL = url
        lastDataTask?.cancel()
        
        let request = URLRequest(url: url)
        if let imageData = URLCache.shared.cachedResponse(for: request)?.data,
           lastURL == url {
            completion(imageData)
            return
        }
        let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, _, _ in
            if let imageData = data,
               self?.lastURL == url {
                DispatchQueue.main.async {
                    completion(imageData)
                }
            }
        }
        dataTask.resume()
        lastDataTask = dataTask
    }
}
