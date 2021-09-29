//
//  UIViewController+Extension.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 29.09.2021.
//

import UIKit

extension UIViewController {
    
    /// Отображение всплывающего окна с переданным заголовком и сообщением с помощью `UIAlertController`.
    ///
    /// Сообщение не является обязательным.
    /// - Parameters:
    ///   - title: Заголовок.
    ///   - message: Сообщение.
    ///   - competion: Блок, выполняемый после нажатия кнопки "Ok" в открывшемся `UIAlertController`.
    func showAlert(title: String, message: String? = nil, competion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            competion?()
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
