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
    /// Сперва происходит проверка наличия изображения в кеше.
    /// В случае отсутствия изображения в кеше, происходит его фоновая загрузка из сети с автоматическим кешированием.
    /// - Parameter url: `URL` изображения.
    func setImage(with url: URL) {        
        let request = URLRequest(url: url)
        if let imageData = URLCache.shared.cachedResponse(for: request)?.data {
            image = UIImage(data: imageData)
            return
        }
        DispatchQueue.global(qos: .userInteractive).async {
            if let imageData = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.image = UIImage(data: imageData)
                }
            }
        }
    }
}
