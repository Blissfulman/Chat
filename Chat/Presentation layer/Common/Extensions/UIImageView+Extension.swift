//
//  UIImageView+Extension.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 23.11.2021.
//

import UIKit

extension UIImageView {
    
    /// Установка изображения, полученного по переданному `URL`.
    ///
    /// Сперва происходит проверка наличия изображения в кэше.
    /// В случае отсутствия изображения в кэше, происходит его фоновая загрузка из сети с автоматическим кэшированием.
    /// - Parameters:
    ///   - url: `URL` изображения.
    ///   - stubImage: Изображение, которое следует установить в случае ошибки получения изображения по URL.
    func setImage(with url: URL, stubImage: UIImage? = nil) {
        let request = URLRequest(url: url)
        if let imageData = URLCache.shared.cachedResponse(for: request)?.data {
            image = UIImage(data: imageData)
        }
        DispatchQueue.global(qos: .userInteractive).async {
            if let imageData = try? Data(contentsOf: url),
               let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    self.image = image
                }
            } else if stubImage != nil {
                DispatchQueue.main.async {
                    self.image = stubImage
                }
            }
        }
    }
}
