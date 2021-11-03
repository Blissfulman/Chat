//
//  UITableView+Extension.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 27.10.2021.
//

extension UITableView {
    
    /// Прокрутка таблицы до низа (работает корректно если у таблицы единственная секция).
    /// - Parameter animated: Логическое значение, указывающее на необходимость анимации при прокрутке.
    func scrollToBottom(animated: Bool) {
        let numberOfRows = numberOfRows(inSection: 0)
        let indexPath = IndexPath(row: numberOfRows - 1, section: 0)
        if numberOfRows > 0 {
            scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }
}
